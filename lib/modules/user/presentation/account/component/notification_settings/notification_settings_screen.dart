import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import 'notification_setting_dialog.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool? _isEnable;

  @override
  void initState() {
    _isEnable = SessionManager().notificationEnable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.notifications_active_outlined,
          color: AppColors.black,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.s16.rw,
            ),
            child: Text(
              AppStrings.notification.tr(),
              style: mediumTextStyle(
                color: AppColors.black,
                fontSize: AppSize.s16.rSp,
              ),
            ),
          ),
        ),
        Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            value: _isEnable!,
            activeColor: AppColors.primary,
            trackColor: AppColors.greyDarker,
            onChanged: (enable) {
              showPauseNotificationConfirmationDialog(
                context: context,
                enable: enable,
                onSuccess: () {
                  setState(() {
                    _isEnable = enable;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
