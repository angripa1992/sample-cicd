import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../resources/colors.dart';

class MenuTab extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTabChanged;
  final BorderRadius borderRadius;

  const MenuTab({
    Key? key,
    required this.name,
    required this.isSelected,
    required this.onTabChanged,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTabChanged,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: isSelected ? AppColors.purpleBlue : AppColors.lightVioletTwo,
            boxShadow: [
              BoxShadow(
                color: AppColors.lightGrey,
                blurRadius: 2.0,
                offset:
                    const Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s10.rh),
            child: Center(
              child: Text(
                name,
                style: getRegularTextStyle(
                  color: isSelected ? AppColors.white : AppColors.black,
                  fontSize: AppFontSize.s15.rSp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
