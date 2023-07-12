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
  final Function(int,num,PromoInfo?) onApply;

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
  }) : super(key: key);

  @override
  State<OrderDiscountModalView> createState() => _OrderDiscountModalViewState();
}

class _OrderDiscountModalViewState extends State<OrderDiscountModalView> {
  final _discountController = TextEditingController();
  bool _deleted = false;
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
      final value = _discountController.text.isEmpty ? '0' : _discountController.text;
      PromoInfo? promoInfo;
      if(_appliedPromo != null){
        promoInfo = PromoInfo(promo: _appliedPromo!, citizen: _citizen ?? 1,customer: _customer);
      }
      widget.onApply(_discountType, num.parse(value),promoInfo);
    } else {
      showErrorSnackBar(context, validatedMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s8.rw,
        vertical: AppSize.s8.rh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Apply Promo and Discounts',
                  style: mediumTextStyle(
                    color: AppColors.bluewood,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.clear),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
            child: AddDiscountModalView(
              initialType: _discountType,
              onTypeChanged: (discountType) {
                _discountType = discountType;
              },
              discountValueController: _discountController,
            ),
          ),
          Expanded(
            child: PromoModalView(
              isItemDiscount: widget.isItemDiscount,
              subtotal: widget.subtotal,
              brands: widget.brands,
              promoInfo: widget.promoInfo,
              citizenMaxCount: widget.itemQuantity,
              onCitizenChanged: (citizen) {
                _citizen = citizen;
              },
              onCustomerChanged: (customer) {
                _customer = customer;
              },
              onPromoChanged: (promo,deleted) {
                _appliedPromo = promo;
                _deleted = deleted;
              },
            ),
          ),
          SizedBox(height: AppSize.s8.rh),
          ElevatedButton(
            onPressed: _apply,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purpleBlue, // Background color
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
          )
        ],
      ),
    );
  }
}
