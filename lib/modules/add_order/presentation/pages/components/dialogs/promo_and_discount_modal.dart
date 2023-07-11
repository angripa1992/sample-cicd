import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../widgets/snackbars.dart';
import '../../../../data/models/applied_promo.dart';
import 'discount_modal_view.dart';

class OrderDiscountModalView extends StatefulWidget {
  final int initialDiscountType;
  final num initialDiscountVale;
  final num subtotal;
  final List<int> brands;
  final Function(int, num) onApply;

  const OrderDiscountModalView({
    Key? key,
    required this.initialDiscountType,
    required this.initialDiscountVale,
    required this.onApply,
    required this.subtotal,
    required this.brands,
  }) : super(key: key);

  @override
  State<OrderDiscountModalView> createState() => _OrderDiscountModalViewState();
}

class _OrderDiscountModalViewState extends State<OrderDiscountModalView> {
  final _discountController = TextEditingController();
  late int _discountType;

  @override
  void initState() {
    _discountType = widget.initialDiscountType;
    _discountController.text = widget.initialDiscountVale.toString();
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
      widget.onApply(_discountType, num.parse(value));
    } else {
      showErrorSnackBar(context, validatedMsg);
    }
  }

  Map<String, dynamic> _params() {
    final user = SessionManager().currentUser();
    return {
      'country': user.countryIds.first,
      'business': user.businessId,
      'branch': user.branchId,
      'product_type': 'add_order',
      'order_amount': widget.subtotal,
      'brands' : ListParam<int>(widget.brands, ListFormat.csv),
    };
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
          FutureBuilder<dartz.Either<Failure, List<AppliedPromo>>>(
            future: getIt.get<AddOrderRepository>().fetchPromos(_params()),
            builder: (context, snap) {
              if (snap.hasData && snap.data != null) {
                return snap.data!.fold(
                  (l) {
                    return Text(l.message);
                  },
                  (data) {
                    return Text(data.length.toString());
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          Spacer(),
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
