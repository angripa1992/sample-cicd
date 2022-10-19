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
        SizedBox(
          height: AppSize.s40.rh,
          width: AppSize.s40.rw,
          child: FutureBuilder<Provider>(
            future: _infoProvider.getProviderById(order.providerId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ImageView(path: snapshot.data!.logo);
              }
              return SizedBox(
                height: AppSize.s12.rh,
                width: AppSize.s12.rw,
                child: const CircularProgressIndicator(),
              );
            },
          ),
        ),
        SizedBox(width: AppSize.s10.rw),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  (order.providerId == ProviderID.KLIKIT)
                      ? '#${order.id}'
                      : '#${order.shortId}',
                  style: getBoldTextStyle(
                    color: AppColors.purpleBlue,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
                IconButton(
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
              ],
            ),
            SizedBox(
              height: AppSize.s20.rh,
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
      ],
    );
  }
}
