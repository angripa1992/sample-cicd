import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class DocketCounterView extends StatelessWidget {
  final bool enabled;
  final int count;
  final int minCount;
  final Function(int) onChanged;

  const DocketCounterView({
    Key? key,
    required this.enabled,
    required this.count,
    required this.onChanged,
    required this.minCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        border: Border.all(
          color: enabled ? AppColors.bluewood : AppColors.dustyGrey,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s8.rw,
          //vertical: AppSize.s2.rh,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: (enabled && count > minCount)
                    ? () => onChanged(count - 1)
                    : null,
                icon: Icon(
                  Icons.remove,
                  color: enabled ? AppColors.bluewood : AppColors.dustyGrey,
                ),
              ),
              VerticalDivider(
                color: enabled ? AppColors.bluewood : AppColors.dustyGrey,
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
                child: Text(
                  count.toString(),
                  style: mediumTextStyle(
                    color: enabled ? AppColors.bluewood : AppColors.dustyGrey,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ),
              VerticalDivider(
                color: enabled ? AppColors.bluewood : AppColors.dustyGrey,
                thickness: 1,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                enableFeedback: false,
                onPressed:
                    (enabled && count < 5) ? () => onChanged(count + 1) : null,
                icon: Icon(
                  Icons.add,
                  color: enabled ? AppColors.bluewood : AppColors.dustyGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
