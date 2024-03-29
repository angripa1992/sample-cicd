import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/app_update_manager.dart';
import 'package:klikit/modules/widgets/app_button.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

import '../../resources/values.dart';

class UpdateAvailableView extends StatelessWidget {
  const UpdateAvailableView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AppUpdateManager().checkForUpdate(),
      builder: (context, snapshot) {
        if (snapshot.hasData && (snapshot.data ?? false)) {
          return _body();
        }
        return const SizedBox();
      },
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.s6.rh, horizontal: AppSize.s16.rw),
      color: AppColors.white,
      child: Row(
        children: [
          SvgPicture.asset(AppIcons.updateStar),
          SizedBox(width: AppSize.s12.rw),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'New version available!',
                  style: semiBoldTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s15.rSp,
                  ),
                ),
                Text(
                  'Get the latest klikit app now',
                  style: regularTextStyle(
                    color: AppColors.greyDarker,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: AppButton(
              onTap: () async {
                await AppUpdateManager().gotoPlayStore();
              },
              text: AppStrings.update.tr(),
              color: AppColors.green,
              borderColor: AppColors.green,
            ),
          )
        ],
      ),
    );
  }
}
