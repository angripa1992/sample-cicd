import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/dialogs/promo_selector.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/dialogs/senior_citizen_discount.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../data/models/applied_promo.dart';
import '../../../../domain/entities/add_to_cart_item.dart';

class PromoModalView extends StatefulWidget {
  final num subtotal;
  final int orderType;
  final List<int> brands;
  final bool isItemDiscount;
  final PromoInfo? promoInfo;
  final int citizenMaxCount;
  final Function(AppliedPromo?, bool) onPromoChanged;
  final Function(int) onCitizenChanged;
  final Function(int) onCustomerChanged;

  const PromoModalView({
    Key? key,
    required this.subtotal,
    required this.brands,
    required this.orderType,
    required this.onPromoChanged,
    required this.citizenMaxCount,
    required this.onCitizenChanged,
    required this.onCustomerChanged,
    required this.isItemDiscount,
    this.promoInfo,
  }) : super(key: key);

  @override
  State<PromoModalView> createState() => _PromoModalViewState();
}

class _PromoModalViewState extends State<PromoModalView> {
  final _valueNotifier = ValueNotifier<int?>(null);
  AppliedPromo? _appliedPromo;
  int? _citizen;
  int? _customer;

  @override
  void initState() {
    _appliedPromo = widget.promoInfo?.promo;
    _citizen = widget.promoInfo?.citizen;
    _customer = widget.promoInfo?.customer;
    _valueNotifier.value = _appliedPromo?.id;
    super.initState();
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  Map<String, dynamic> _params() {
    final user = SessionManager().user();
    return {
      'country': user!.countryIds.first,
      'business': user.businessId,
      'branch': user.branchId,
      'product_type': 'add_order',
      'order_amount': widget.subtotal,
      'brands': ListParam<int>(widget.brands, ListFormat.csv),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s8.rw,
          vertical: AppSize.s8.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.available_promos.tr(),
              style: mediumTextStyle(
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
            SizedBox(height: AppSize.s2.rh),
            Text(
              AppStrings.select_only_one_promo.tr(),
              style: regularTextStyle(
                fontSize: AppFontSize.s12.rSp,
                color: AppColors.greyDarker,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                      child: FutureBuilder<dartz.Either<Failure, List<AppliedPromo>>>(
                        future: getIt.get<AddOrderRepository>().fetchPromos(_params()),
                        builder: (context, snap) {
                          if (snap.hasData && snap.data != null) {
                            return snap.data!.fold(
                              (l) {
                                return Center(child: Text(l.message));
                              },
                              (data) {
                                if (data.isNotEmpty) {
                                  return PromoSelectorView(
                                    initialPromo: widget.promoInfo?.promo,
                                    promos: data,
                                    onChanged: (promo, deleted) {
                                      _appliedPromo = promo;
                                      _valueNotifier.value = promo?.id;
                                      widget.onPromoChanged(promo, deleted);
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: AppSize.s32.rh),
                                      child: Text(
                                        AppStrings.no_promo_available.tr(),
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(top: AppSize.s32.rh),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    ValueListenableBuilder<int?>(
                      valueListenable: _valueNotifier,
                      builder: (_, data, __) {
                        if (data != null &&
                            _appliedPromo != null &&
                            _appliedPromo!.isSeniorCitizenPromo! &&
                            ((!widget.isItemDiscount && widget.orderType == OrderType.DINE_IN) || widget.isItemDiscount)) {
                          return SeniorCitizenDiscountView(
                            initialCustomerCount: _customer,
                            initialCitizenCount: _citizen,
                            citizenMaxCount: widget.citizenMaxCount,
                            onCitizenChanged: widget.onCitizenChanged,
                            onCustomerChanged: widget.onCustomerChanged,
                            isItemDiscount: widget.isItemDiscount,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
