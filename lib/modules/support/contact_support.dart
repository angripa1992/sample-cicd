import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../resources/colors.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({Key? key}) : super(key: key);

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  Future<String?> _launchWhatsapp() async {
    final whatsappAndroid = Uri.parse("whatsapp://send?phone=${AppConstant.whatsappSupportNumber}");
    try {
      await launchUrl(whatsappAndroid);
      return null;
    } on PlatformException catch (e) {
      debugPrint('WhatsApp launch error: ${e.message}');
      return AppStrings.whatsapp_not_installed_msg.tr();
    }
  }

  Future<String?> _mailSupport() async {
    if (!await launchUrl(Uri.parse('mailto:${AppConstant.supportMail}'))) {
      return AppStrings.could_not_email_msg.tr();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(12.rw, 0, 8.rw, 0),
          selected: true,
          selectedTileColor: AppColors.neutralB20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.rSp)),
          leading: ImageResourceResolver.whatsappSVG.getImageWidget(width: 24.rw, height: 24.rh),
          title: Text(
            AppStrings.whatsapp.tr(),
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          subtitle: Text(
            AppStrings.whatsapp_tile.tr(),
            style: regularTextStyle(
              color: AppColors.neutralB700,
              fontSize: AppFontSize.s12.rSp,
            ),
          ),
          trailing: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 16.rw, height: 16.rh),
          onTap: () async {
            String? message = await _launchWhatsapp();
            if (mounted && message.isNotNullOrEmpty()) {
              Navigator.pop(context, message!);
            }
          },
        ),
        SizedBox(
          height: AppSize.s12.rh,
        ),
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(12.rw, 0, 8.rw, 0),
          selected: true,
          selectedTileColor: AppColors.neutralB20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.rSp)),
          leading: ImageResourceResolver.emailSVG.getImageWidget(width: 24.rw, height: 24.rh),
          title: Text(
            AppStrings.email_support.tr(),
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          subtitle: Text(
            AppStrings.email_tile.tr(),
            style: regularTextStyle(
              color: AppColors.neutralB700,
              fontSize: AppFontSize.s12.rSp,
            ),
          ),
          trailing: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 16.rw, height: 16.rh),
          onTap: () async {
            String? message = await _mailSupport();
            if (mounted && message.isNotNullOrEmpty()) {
              Navigator.pop(context, message!);
            }
          },
        ),
        SizedBox(
          height: AppSize.s40.rh,
        ),
      ],
    );
  }
}
