import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/order_information_provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/modules/widgets/image_view.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class OrderItemView extends StatelessWidget {
  final _infoProvider = getIt.get<OrderInformationProvider>();
  final VoidCallback seeDetails;
  final Order order;

  OrderItemView({Key? key, required this.order, required this.seeDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: AppSize.s8),
          child: FutureBuilder<Provider>(
            future: _infoProvider.getProviderById(order.providerId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: AppSize.s40.rh,
                  width: AppSize.s40.rw,
                  child: ImageView(path: snapshot.data!.logo),
                );
              }
              return Center(
                child: CircularProgressIndicator(strokeWidth: AppSize.s2.rSp),
              );
            },
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Flexible(
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
                  Flexible(
                    child: IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: (order.providerId == ProviderID.KLIKIT)
                                ? order.id.toString()
                                : order.shortId,
                          ),
                        ).then((value) {
                          showSuccessSnackBar(context, 'Order id copied');
                        });
                      },
                      icon: Icon(
                        Icons.copy,
                        size: AppSize.s14.rSp,
                        color: AppColors.purpleBlue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppSize.s20.rh,
                width: AppSize.s100.rw,
                child: ElevatedButton(
                  onPressed: seeDetails,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
                    primary: AppColors.canaryYellow,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSize.s12.rSp), // <-- Radius
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'See Details',
                        style: getMediumTextStyle(
                          color: AppColors.purpleBlue,
                          fontSize: AppFontSize.s12.rSp,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.purpleBlue,
                        size: AppSize.s14.rSp,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSize.s8.rh)
            ],
          ),
        ),
      ],
    );
  }
}
