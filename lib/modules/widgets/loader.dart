import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';

import '../../resources/colors.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 0
    ..progressColor = AppColors.primary
    ..backgroundColor = AppColors.greyLighter
    ..indicatorColor = AppColors.primary
    ..textColor = AppColors.primary
    ..maskColor = AppColors.black.withOpacity(0.7)
    ..userInteractions = true
    ..indicatorWidget = const CircularProgress()
    ..dismissOnTap = false;
}

void showLoader() {
  EasyLoading.show();
}

void dismissLoader() {
  EasyLoading.dismiss();
}
