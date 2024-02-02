import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';

import '../../resources/colors.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.primary
    ..backgroundColor = AppColors.white
    ..indicatorColor = AppColors.primary
    ..textColor = AppColors.primary
    ..maskColor = AppColors.primary.withOpacity(0.5)
    ..userInteractions = true
    ..indicatorWidget = CircularProgress()
    ..dismissOnTap = false;
}

void showLoader() {
  EasyLoading.show();
}

void dismissLoader() {
  EasyLoading.dismiss();
}
