import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/home/presentation/support/components/contact_item.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({Key? key}) : super(key: key);

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  Future<void> _callSupport() async {
    if (!await launchUrl(Uri.parse('tel:${AppConstant.supportNumber}'))) {
      showErrorSnackBar(context, 'Could not call on this number');
    }
  }

  Future<void> _mailSupport() async {
    if (!await launchUrl(Uri.parse('mailto:${AppConstant.supportMail}'))) {
      showErrorSnackBar(context, 'Could not email on this email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.contact_support.tr()),
        titleTextStyle: getAppBarTextStyle(),
        flexibleSpace: getAppBarBackground(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s20.rw,
          vertical: AppSize.s26.rh,
        ),
        child: Column(
          children: [
            ContactItem(
              iconData: Icons.phone,
              title: AppConstant.supportNumber,
              description: 'Available 9am - 12am',
              onTap: () async {
                await _callSupport();
              },
            ),
            SizedBox(
              height: AppSize.s12.rh,
            ),
            ContactItem(
              iconData: Icons.chat,
              title: 'Live Chat',
              description: 'Available 9am - 12am',
              onTap: () {},
            ),
            SizedBox(
              height: AppSize.s12.rh,
            ),
            ContactItem(
              iconData: Icons.email_outlined,
              title: 'Email Support',
              description: 'Available 24/7',
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
