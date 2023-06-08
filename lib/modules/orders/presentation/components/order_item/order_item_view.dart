import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/widgets/image_view.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class OrderItemView extends StatelessWidget {
  final VoidCallback seeDetails;
  final Order order;

  OrderItemView({Key? key, required this.order, required this.seeDetails})
      : super(key: key);

  final _providerTextStyle = getRegularTextStyle(
    color: AppColors.blackCow,
    fontSize: AppFontSize.s14.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: AppSize.s10),
          child: SizedBox(
            child: ImageView(path: order.orderSource.logo),
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: AppSize.s2.rh),
                      child: Text(
                        (order.providerId == ProviderID.KLIKIT)
                            ? '#${order.id}'
                            : '#${order.shortId}',
                        style: getBoldTextStyle(
                          color: AppColors.purpleBlue,
                          fontSize: AppFontSize.s16.rSp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.s8.rw),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: (order.providerId == ProviderID.KLIKIT)
                              ? order.id.toString()
                              : order.shortId,
                        ),
                      ).then((value) {
                        showSuccessSnackBar(
                            context, AppStrings.order_id_copied.tr());
                      });
                    },
                    child: Icon(
                      Icons.copy,
                      size: AppSize.s14.rSp,
                      color: AppColors.purpleBlue,
                    ),
                  ),
                ],
              ),
              Text(
                order.orderSource.title,
                style: _providerTextStyle,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                child: InkWell(
                  onTap: seeDetails,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s16.rSp),
                      border: Border.all(color: AppColors.purpleBlue),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.s4.rh,
                        horizontal: AppSize.s16.rw,
                      ),
                      child: Text(
                        AppStrings.see_details.tr(),
                        style: getMediumTextStyle(
                          color: AppColors.purpleBlue,
                          fontSize: AppFontSize.s12.rSp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
