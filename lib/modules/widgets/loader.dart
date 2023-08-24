import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../resources/colors.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.white
    ..backgroundColor = AppColors.primary
    ..indicatorColor = AppColors.white
    ..textColor = AppColors.white
    ..maskColor = AppColors.primary.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

void showLoader() {
  EasyLoading.show();
}

void dismissLoader() {
  EasyLoading.dismiss();
}
