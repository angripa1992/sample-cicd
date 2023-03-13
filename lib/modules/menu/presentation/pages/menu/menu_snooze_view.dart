import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/items.dart';

import '../../../../../app/extensions.dart';
import '../../../../../resources/colors.dart';
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
  final Function(bool) onEnabledChange;
  final Function(Stock) onOosChanged;

  const MenuSnoozeView({
    Key? key,
    required this.items,
    required this.providerId,
    required this.borderRadius,
    required this.width,
    required this.bgColor,
    required this.parentEnabled,
    required this.onEnabledChange,
    required this.brandId,
    required this.onOosChanged,
  }) : super(key: key);

  String _duration() {
    final duration = items.stock.snooze.duration;
    if (duration == 24) {
      return '1 Day';
    } else if (duration == 72) {
      return '3 Days';
    } else if (duration == 168) {
      return '7 Days';
    } else if (duration == 0) {
      return 'Until turned back on';
    } else {
      return '$duration Hour(s)';
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
                      onEnabledChanged: onEnabledChange,
                      brandId: brandId,
                      providerId: providerId,
                      parentEnabled: parentEnabled,
                      onOosChanged: onOosChanged,
                    ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: bgColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.s4.rh,
                    horizontal: AppSize.s4.rw,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: AppColors.warmRed,
                        size: AppSize.s16.rSp,
                      ),
                      SizedBox(width: AppSize.s8.rw),
                      Expanded(
                        child: Text(
                          _duration(),
                          style:
                              getMediumTextStyle(color: AppColors.smokeyGrey),
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
