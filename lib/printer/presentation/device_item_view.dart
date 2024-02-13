import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';

import '../../resources/colors.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';

class PrinterDeviceItemView extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool willDisconnect;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const PrinterDeviceItemView({
    Key? key,
    required this.icon,
    required this.name,
    required this.willDisconnect,
    required this.onConnect,
    required this.onDisconnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.rh, horizontal: 16.rw),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.black),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.rw),
                  child: Text(
                    name,
                    style: regularTextStyle(color: AppColors.black, fontSize: 16.rSp),
                  ),
                ),
              ),
              KTButton(
                controller: KTButtonController(
                  label: willDisconnect ? AppStrings.disconnect.tr() : AppStrings.connect.tr(),
                ),
                labelStyle: mediumTextStyle(
                  color: willDisconnect ? AppColors.errorR300 : AppColors.neutralB500,
                  fontSize: 14.rSp,
                ),
                backgroundDecoration: BoxDecoration(
                  border: Border.all(
                    color: willDisconnect ? AppColors.errorR300 : AppColors.neutralB50,
                  ),
                  borderRadius: BorderRadius.circular(16.rSp),
                ),
                horizontalContentPadding: 16.rw,
                onTap: willDisconnect ? onDisconnect : onConnect,
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
