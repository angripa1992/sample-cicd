import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/language/language_setting_page.dart';
import 'package:klikit/modules/user/presentation/account/component/account_action_item.dart';

import '../../../../../core/route/routes.dart';
import '../../../../../resources/strings.dart';

class AccountActionHeader extends StatelessWidget {
  const AccountActionHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AccountActionItem(
          title: AppStrings.change_language.tr(),
          iconData: Icons.language,
          onTap: () {
            showLanguageSettingDialog(context: context);
          },
        ),
        AccountActionItem(
          title: AppStrings.printer_settings.tr(),
          iconData: Icons.print,
          onTap: () {
            Navigator.of(context).pushNamed(Routes.printerSettings);
          },
        ),
        AccountActionItem(
          title: AppStrings.contact_support.tr(),
          iconData: Icons.support_agent,
          onTap: () {
            Navigator.of(context).pushNamed(Routes.contactSupport);
          },
        ),
        AccountActionItem(
          title: AppStrings.change_password.tr(),
          iconData: Icons.lock,
          onTap: () {
            Navigator.of(context).pushNamed(Routes.changePassword);
          },
        ),
      ],
    );
  }
}
