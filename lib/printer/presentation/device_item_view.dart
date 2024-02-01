import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/widgets/negative_button.dart';

import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';

class DeviceItemView extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback onConnect;

  const DeviceItemView({
    Key? key,
    required this.icon,
    required this.name,
    required this.onConnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSize.s12,
            horizontal: AppSize.s16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.black),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSize.s8),
                  child: Text(
                    name,
                    style: regularTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s16.rSp,
                    ),
                  ),
                ),
              ),
              NegativeButton(
                negativeText: AppStrings.connect.tr(),
                buttonRadius: AppSize.s200.rSp,
                horizontalPadding: AppSize.s16.rw,
                onTap: onConnect,
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
