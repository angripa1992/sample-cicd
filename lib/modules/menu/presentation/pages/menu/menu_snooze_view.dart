import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/items.dart';

import '../../../../../app/extensions.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/stock.dart';
import 'oos_settings.dart';

class MenuSnoozeView extends StatelessWidget {
  final MenuItems items;
  final int brandId;
  final int providerId;
  final double borderRadius;
  final double width;
  final Color bgColor;
  final bool parentEnabled;
  final String iconPath;
  final Function(Stock) onChanged;

  const MenuSnoozeView({
    Key? key,
    required this.items,
    required this.providerId,
    required this.borderRadius,
    required this.width,
    required this.bgColor,
    required this.parentEnabled,
    required this.brandId,
    required this.onChanged,
    required this.iconPath,
  }) : super(key: key);

  String _duration() {
    final duration = items.stock.snooze.duration;
    if (duration == 24) {
      return '1 ${AppStrings.day.tr()}';
    } else if (duration == 72) {
      return '3 ${AppStrings.day.tr()}';
    } else if (duration == 168) {
      return '7 ${AppStrings.day.tr()}';
    } else if (duration == 0) {
      return AppStrings.untill_trun_back_on.tr();
    } else {
      return '$duration ${AppStrings.hours.tr()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return !items.stock.available && providerId == ZERO
        ? SizedBox(
            width: width,
            child: InkWell(
              onTap: () => !parentEnabled
                  ? null
                  : showOosDialog(
                      items: items,
                      brandId: brandId,
                      providerId: providerId,
                      parentEnabled: parentEnabled,
                      onChanged: onChanged,
                    ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: bgColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.s4.rh,
                    horizontal: AppSize.s6.rw,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(iconPath),
                      SizedBox(width: AppSize.s8.rw),
                      Expanded(
                        child: Text(
                          _duration(),
                          style: mediumTextStyle(color: AppColors.greyDarker),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
