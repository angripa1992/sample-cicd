import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/dialogs/promo_modal_view.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../widgets/snackbars.dart';
import '../../../../data/models/applied_promo.dart';
import '../../../../domain/entities/add_to_cart_item.dart';
import 'discount_modal_view.dart';

class OrderDiscountModalView extends StatefulWidget {
  final PromoInfo? promoInfo;
  final int initialDiscountType;
  final num initialDiscountVale;
  final num subtotal;
  final List<int> brands;
  final bool isItemDiscount;
  final int itemQuantity;
  final bool willShowPromo;
  final int orderType;
  final Function(int, num, PromoInfo?) onApply;

  const OrderDiscountModalView({
    Key? key,
    this.promoInfo,
    required this.initialDiscountType,
    required this.initialDiscountVale,
    required this.onApply,
    required this.subtotal,
    required this.brands,
    required this.isItemDiscount,
    required this.itemQuantity,
    required this.willShowPromo,
    required this.orderType,
  }) : super(key: key);

  @override
  State<OrderDiscountModalView> createState() => _OrderDiscountModalViewState();
}

class _OrderDiscountModalViewState extends State<OrderDiscountModalView> {
  final _discountController = TextEditingController();
  late int _discountType;
  AppliedPromo? _appliedPromo;
  int? _citizen;
  int? _customer;

  @override
  void initState() {
    _discountType = widget.initialDiscountType;
    _discountController.text = widget.initialDiscountVale.toString();
    _appliedPromo = widget.promoInfo?.promo;
    _citizen = widget.promoInfo?.citizen;
    _customer = widget.promoInfo?.customer;
    super.initState();
  }

  String? _validate() {
    final text = _discountController.text;
    final amountString = text.isEmpty ? '0' : text;
    final amount = num.parse(amountString);
    if (_discountType == DiscountType.flat) {
      if (amount > widget.subtotal) {
        return AppStrings.can_not_be_greater_than_subtotal.tr();
      }
    } else {
      if (amount > 100) {
        return AppStrings.can_not_be_greater_than_100.tr();
      }
    }
    return null;
  }

  void _apply() {
    final validatedMsg = _validate();
    if (validatedMsg == null) {
      Navigator.pop(context);
      final value =
          _discountController.text.isEmpty ? '0' : _discountController.text;
      PromoInfo? promoInfo;
      if (_appliedPromo != null) {
        final willApplyCitizen = (_appliedPromo!.isSeniorCitizenPromo! &&
            ((!widget.isItemDiscount &&
                    widget.orderType == OrderType.DINE_IN) ||
                widget.isItemDiscount));
        promoInfo = PromoInfo(
          promo: _appliedPromo!,
          citizen: willApplyCitizen ? (_citizen ?? 1) : null,
          customer: willApplyCitizen
              ? ((!widget.isItemDiscount && _customer == null) ? 1 : _customer)
              : null,
        );
      }
      widget.onApply(_discountType, num.parse(value), promoInfo);
    } else {
      showErrorSnackBar(context, validatedMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _appBar(),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.s8.rh,
            horizontal: AppSize.s8.rw,
          ),
          child: AddDiscountModalView(
            initialType: _discountType,
            onTypeChanged: (discountType) {
              _discountType = discountType;
            },
            discountValueController: _discountController,
          ),
        ),
        if (widget.willShowPromo)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                // vertical: AppSize.s8.rh,
                horizontal: AppSize.s8.rw,
              ),
              child: PromoModalView(
                isItemDiscount: widget.isItemDiscount,
                subtotal: widget.subtotal,
                brands: widget.brands,
                promoInfo: widget.promoInfo,
                citizenMaxCount: widget.itemQuantity,
                orderType: widget.orderType,
                onCitizenChanged: (citizen) {
                  _citizen = citizen;
                },
                onCustomerChanged: (customer) {
                  _customer = customer;
                },
                onPromoChanged: (promo, deleted) {
                  _appliedPromo = promo;
                },
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.s8.rh,
            horizontal: AppSize.s8.rw,
          ),
          child: ElevatedButton(
            onPressed: _apply,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, // Background color
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
              child: Text(
                AppStrings.apply.tr(),
                style: mediumTextStyle(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _appBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s8.rw,
        vertical: AppSize.s12.rh,
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
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.isItemDiscount
                  ? 'Apply Item Promo and Discounts'
                  : 'Apply Promo and Discounts',
              style: mediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }
}
