import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/edit_order/update_grab_order_cubit.dart';

import '../../../resources/assets.dart';
import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/strings.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';
import '../../widgets/loading_button.dart';
import '../../widgets/snackbars.dart';
import '../domain/entities/cart.dart';
import 'calculate_grab_order_cubit.dart';
import 'editing_item.dart';
import 'editing_manager.dart';

class EditGrabOrderView extends StatefulWidget {
  final Order order;
  final VoidCallback onClose;
  final Function(Order order) onEditSuccess;

  const EditGrabOrderView({
    Key? key,
    required this.order,
    required this.onClose,
    required this.onEditSuccess,
  }) : super(key: key);

  @override
  State<EditGrabOrderView> createState() => _EditGrabOrderViewState();
}

class _EditGrabOrderViewState extends State<EditGrabOrderView> {
  final _calculatedText = AppStrings.calculated_at_next_step.tr();
  final _enableButtonNotifier = ValueNotifier<bool>(false);
  late Order _currentOrder;
  bool _showPrice = true;

  @override
  void initState() {
    _currentOrder = widget.order.copy();
    super.initState();
  }

  void _calculateBill() {
    context
        .read<CalculateGrabBillCubit>()
        .calculateBill(_currentOrder.toModel());
  }

  void _onQuantityChange(String id, String externalId, int quantity) {
    if (quantity == 0) {
      _deleteItem(id, externalId);
    } else {
      final cartItem = _currentOrder.cartV2.firstWhere((element) => (element.id == id && element.externalId == externalId));
      cartItem.quantity = quantity;
    }
    _updateStateAndCalculate();
  }

  void _updateStateAndCalculate(){
    if (_currentOrder.cartV2.isEmpty) {
      _showPrice = false;
    } else {
      final status = EditingManager().enabledButton(widget.order, _currentOrder);
      _enableButtonNotifier.value = status;
      _showPrice = !status;
    }
    _calculateBill();
  }

  void _deleteItem(String id, String externalId){
    _currentOrder.cartV2.removeWhere((element) => (element.id == id && element.externalId == externalId));
    _updateStateAndCalculate();
  }

  void _removeAll() {
    _currentOrder.cartV2.clear();
    _enableButtonNotifier.value =
        EditingManager().enabledButton(widget.order, _currentOrder);
    _showPrice = false;
    _calculateBill();
  }

  void _discard() {
    setState(() {
      _currentOrder = widget.order.copy();
      _enableButtonNotifier.value =
          EditingManager().enabledButton(widget.order, _currentOrder);
      _showPrice = true;
    });
  }

  void _updateOrder(){
    final requestModel = EditingManager().createRequestModel(widget.order, _currentOrder);
    context.read<UpdateGrabOrderCubit>().updateGrabOrder(requestModel);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke,
      child: Column(
        children: [
          _appBar(),
          Expanded(
            child: BlocConsumer<CalculateGrabBillCubit, ResponseState>(
              listener: (context, state) {
                if (state is Loading) {
                  EasyLoading.show();
                } else if (state is Success<Order>) {
                  _currentOrder = state.data;
                  EasyLoading.dismiss();
                } else {
                  EasyLoading.dismiss();
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    _brandSpecificCartItemsListView(),
                    _priceView(),
                    _bottomView(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
        child: Row(
          children: [
            IconButton(
                onPressed: widget.onClose, icon: const Icon(Icons.clear)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.cart.tr(),
                  style: mediumTextStyle(
                    color: AppColors.balticSea,
                    fontSize: AppFontSize.s17.rSp,
                  ),
                ),
                SizedBox(height: AppSize.s4.rh),
                Text(
                  '#${_currentOrder.id} (${AppStrings.order_id.tr()})',
                  style: regularTextStyle(
                    color: AppColors.dustyGreay,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCartView() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.s16.rh),
      child: Column(
        children: [
          SvgPicture.asset(AppImages.emptyCartSvg),
          SizedBox(height: AppSize.s16.rh),
          Text(
            AppStrings.your_cart_is_empty.tr(),
            style: mediumTextStyle(
              color: AppColors.purpleBlue,
              fontSize: AppFontSize.s20.rSp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandSpecificCartItemsListView() {
    final brandSpecificCartItems =
        EditingManager().extractCartItems(_currentOrder);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
        child: brandSpecificCartItems.isEmpty ||
                brandSpecificCartItems.first.isEmpty
            ? _emptyCartView()
            : ListView.builder(
                itemCount: brandSpecificCartItems.length,
                shrinkWrap: true,
                //  physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final menuBrand =
                      brandSpecificCartItems[index].first.cartBrand;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
                    margin: EdgeInsets.symmetric(vertical: AppSize.s10.rh),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                      color: AppColors.white,
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    menuBrand.title,
                                    style: boldTextStyle(
                                      color: AppColors.balticSea,
                                      fontSize: AppFontSize.s15.rSp,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _removeAll,
                                  child: Text(
                                    AppStrings.remove_all.tr(),
                                    style: mediumTextStyle(
                                      color: AppColors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(),
                            _cartItemListView(brandSpecificCartItems[index]),
                            const Divider(),
                            _totalOrder(),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _cartItemListView(List<CartV2> items) {
    return ListView.separated(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = items[index];
        return EditingItemVIew(
          item: item,
          currencySymbol: _currentOrder.currencySymbol,
          onQuantityChange: _onQuantityChange,
          onDeleteItem: _deleteItem,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  Widget _totalOrder() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSize.s8.rh,
        top: AppSize.s8.rh,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppStrings.total.tr(),
              style: regularTextStyle(
                color: AppColors.balticSea,
                fontSize: AppFontSize.s15.rSp,
              ),
            ),
          ),
          Text(
            '${_currentOrder.currencySymbol} ${_currentOrder.itemPriceDisplay}',
            style: TextStyle(
              color: AppColors.balticSea,
              fontSize: AppFontSize.s15.rSp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceView() {
    return Container(
      margin: EdgeInsets.only(
        left: AppSize.s12.rw,
        right: AppSize.s12.rw,
        bottom: AppSize.s8.rh,
        top: AppSize.s8.rh,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s12.rw,
        vertical: AppSize.s8.rh,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          _item(
            title: AppStrings.sub_total.tr(),
            price:
                '${_currentOrder.currencySymbol} ${_currentOrder.itemPriceDisplay}',
            subtotal: true,
          ),
          SizedBox(height: AppSize.s8.rh),
          _item(
            title: AppStrings.vat.tr(),
            price: _showPrice
                ? '${_currentOrder.currencySymbol} ${_currentOrder.vatDisplay}'
                : _calculatedText,
            subtotal: false,
          ),
          SizedBox(height: AppSize.s8.rh),
          _item(
            title: AppStrings.delivery_fee.tr(),
            price: _showPrice
                ? '${_currentOrder.currencySymbol} ${_currentOrder.deliveryFeeDisplay}'
                : _calculatedText,
            subtotal: false,
          ),
          SizedBox(height: AppSize.s8.rh),
          _item(
            title: AppStrings.discount.tr(),
            price: _showPrice
                ? '${_currentOrder.currencySymbol} ${_currentOrder.discountDisplay}'
                : _calculatedText,
            subtotal: false,
          ),
          SizedBox(height: AppSize.s8.rh),
          _item(
            title: AppStrings.additional_fee.tr(),
            price: _showPrice
                ? '${_currentOrder.currencySymbol} ${_currentOrder.additionalFeeDisplay}'
                : _calculatedText,
            subtotal: false,
          ),
        ],
      ),
    );
  }

  Widget _item({
    required String title,
    required String price,
    bool subtotal = false,
  }) {
    final textStyle = TextStyle(
      color: AppColors.balticSea,
      fontSize: subtotal ? AppFontSize.s16.rSp : AppFontSize.s14.rSp,
      fontWeight: subtotal ? FontWeight.w500 : FontWeight.w400,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textStyle,
        ),
        Text(
          price,
          style: textStyle,
        ),
      ],
    );
  }

  Widget _bottomView() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s8.rh,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: AppStrings.total.tr(),
                  style: mediumTextStyle(
                    color: AppColors.balticSea,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                  children: [
                    TextSpan(
                      text: ' (${AppStrings.inc_vat.tr()})',
                      style: regularTextStyle(
                        color: AppColors.dustyGreay,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _showPrice
                    ? '${_currentOrder.currencySymbol} ${_currentOrder.finalPriceDisplay}'
                    : _calculatedText,
                style: TextStyle(
                  color: AppColors.balticSea,
                  fontSize: AppFontSize.s16.rSp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.s8.rh),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: LoadingButton(
                  isLoading: false,
                  onTap: _discard,
                  text: AppStrings.discard.tr(),
                  verticalPadding: AppSize.s8.rh,
                  bgColor: AppColors.white,
                  textColor: AppColors.purpleBlue,
                ),
              ),
              SizedBox(width: AppSize.s12.rw),
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _enableButtonNotifier,
                  builder: (_, enabled, __) {
                    return BlocConsumer<UpdateGrabOrderCubit,ResponseState>(
                      listener: (context, state) {
                        if(state is Loading){
                          EasyLoading.show();
                        }else if(state is Failed){
                          EasyLoading.dismiss();
                          showApiErrorSnackBar(context,state.failure);
                        }else if(state is Success<ActionSuccess>){
                          EasyLoading.dismiss();
                          showSuccessSnackBar(context, state.data.message!);
                          _currentOrder.canUpdate = false;
                          widget.onEditSuccess(_currentOrder);
                          Navigator.pop(context);
                        }
                      },
                      builder: (_,state){
                        return LoadingButton(
                          enabled: state is! Loading && enabled,
                          isLoading: false,
                          onTap: _updateOrder,
                          text: AppStrings.save.tr(),
                          verticalPadding: AppSize.s8.rh,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
