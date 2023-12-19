import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/actionable_tile.dart';
import 'package:klikit/core/widgets/kt_switch.dart';
import 'package:klikit/modules/user/presentation/account/component/notification_settings/notification_setting_dialog.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  final _controller = ValueNotifier<bool>(false);

  @override
  void initState() {
    _controller.value = SessionManager().notificationEnable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ActionableTile(
      title: AppStrings.notification.tr(),
      prefixWidget: ImageResourceResolver.notificationSVG.getImageWidget(width: 20.rw, height: 20.rh),
      suffixWidget: KTSwitch(
        controller: _controller,
        onChanged: (enabled) {
          showPauseNotificationConfirmationDialog(
            context: context,
            enable: enabled,
            onSuccess: () {
              _controller.value = enabled;
            },
          );
        },
        height: 18.rh,
        width: 36.rw,
      ),
    );
  }
}
