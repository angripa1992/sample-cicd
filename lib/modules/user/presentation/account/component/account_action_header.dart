import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/modules/user/presentation/account/component/account_action_item.dart';

import '../../../../../core/route/routes.dart';
import '../../../../../resources/strings.dart';

class AccountActionHeader extends StatelessWidget {
  final VoidCallback onLanguageChange;

  const AccountActionHeader({Key? key, required this.onLanguageChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          AccountActionItem(
            title: AppStrings.change_language.tr(),
            iconData: Icons.language,
            onTap: onLanguageChange,
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
      ),
    );
  }
}
