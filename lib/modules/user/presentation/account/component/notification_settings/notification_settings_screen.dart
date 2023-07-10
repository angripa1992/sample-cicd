import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Notification',
          style: boldTextStyle(
            color: AppColors.bluewood,
            fontSize: AppSize.s16.rSp,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pause Notification',
              style: regularTextStyle(
                color: AppColors.purpleBlue,
                fontSize: AppSize.s14.rSp,
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                value: _isEnable!,
                activeColor: AppColors.purpleBlue,
                trackColor: AppColors.smokeyGrey,
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
        ),
      ],
    );
  }
}
