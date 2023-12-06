import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../resources/colors.dart';
import 'components/contact_item.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({Key? key}) : super(key: key);

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  Future<void> _launchWhatsapp() async {
    final whatsappAndroid = Uri.parse("whatsapp://send?phone=${AppConstant.whatsappSupportNumber}");
    try {
      await launchUrl(whatsappAndroid);
    } on PlatformException catch (e) {
      showErrorSnackBar(context, AppStrings.whatsapp_not_installed_msg.tr());
    }
  }

  Future<void> _mailSupport() async {
    if (!await launchUrl(Uri.parse('mailto:${AppConstant.supportMail}'))) {
      showErrorSnackBar(context, AppStrings.could_not_email_msg.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.contact_support.tr()),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s20.rw,
          vertical: AppSize.s26.rh,
        ),
        child: Column(
          children: [
            ContactItem(
              iconData: Icons.whatsapp,
              iconColor: AppColors.green,
              title: AppStrings.whatsapp.tr(),
              description: AppStrings.whatsapp_tile.tr(),
              onTap: () async {
                await _launchWhatsapp();
              },
            ),
            SizedBox(
              height: AppSize.s12.rh,
            ),
            ContactItem(
              iconData: Icons.email_outlined,
              title: AppStrings.email_support.tr(),
              description: AppStrings.email_tile.tr(),
              onTap: () async {
                await _mailSupport();
              },
            ),
          ],
        ),
      ),
    );
  }
}
