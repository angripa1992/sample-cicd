import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';

import '../../resources/fonts.dart';
import '../../resources/styles.dart';

void dismissCurrentSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}

void showConnectivitySnackBar(BuildContext context) {
  dismissCurrentSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(
              'No Internet Connection',
              style: getBoldTextStyle(
                color: AppColors.white,
                fontSize: AppFontSize.s15.rSp,
              ),
            ),
          ),
          Icon(
            Icons.signal_wifi_connected_no_internet_4,
            color: AppColors.white,
          ),
        ],
      ),
      duration: const Duration(hours: 1),
      backgroundColor: AppColors.red,
    ),
  );
}