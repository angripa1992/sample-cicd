import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../app/enums.dart';
import '../../../../../../core/route/routes.dart';
import '../../../../../base/base_screen_cubit.dart';
import '../../../../../widgets/app_button.dart';

class PaymentStatusPage extends StatelessWidget {
  final bool isSuccessful;
  final int orderID;
  final PaymentState paymentState;

  const PaymentStatusPage({
    super.key,
    required this.isSuccessful,
    required this.orderID,
    required this.paymentState,
  });

  void _navigateBack(BuildContext context) {
    if (isSuccessful) {
      if (paymentState == PaymentState.PRE_PAYMENT) {
        CartManager().clearAndNavigateToOrderScreen(context);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.base,
          (Route<dynamic> route) => false,
          arguments: {
            ArgumentKey.kIS_NAVIGATE: true,
            ArgumentKey.kNAVIGATE_DATA: NavigationData(
              index: BottomNavItem.ORDER,
              subTabIndex: OrderTab.NEW,
              data: null,
            ),
          },
        );
      }
    } else {
      if (paymentState == PaymentState.PRE_PAYMENT) {
        CartManager().clearAndNavigateToAddOrderScreen(context);
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateBack(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Status'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => _navigateBack(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s16.rw,
            vertical: AppSize.s16.rh,
          ),
          child: Column(
            children: [
              Image.asset(
                isSuccessful ? AppImages.paymentSuccess : AppImages.paymentFailed,
                height: AppSize.s200.rh,
                width: AppSize.s200.rw,
                fit: BoxFit.cover,
              ),
              SizedBox(height: AppSize.s8.rh),
              Text(
                isSuccessful ? 'Your Payment was Successful!' : 'Your Payment Failed!',
                textAlign: TextAlign.center,
                style: boldTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
              SizedBox(height: AppSize.s8.rh),
              Text(
                isSuccessful
                    ? 'Congratulations! Payment for Order ID #$orderID has been successfully processed.'
                    : 'We are sorry! Payment for order ID #$orderID couldn\’t be processed. Please try again later or use another payment method.',
                textAlign: TextAlign.center,
                style: regularTextStyle(
                  color: AppColors.greyDarker,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
              SizedBox(height: AppSize.s24.rh),
              isSuccessful
                  ? AppButton(
                      onTap: () {
                        _navigateBack(context);
                      },
                      text: 'View Order',
                      color: AppColors.black,
                      borderColor: AppColors.black,
                      textColor: AppColors.white,
                    )
                  : AppButton(
                      onTap: () {
                        _navigateBack(context);
                      },
                      text: 'Create Order Again',
                      color: AppColors.red,
                      borderColor: AppColors.red,
                      textColor: AppColors.white,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
