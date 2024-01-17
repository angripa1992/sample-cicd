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

  const MenuTab({
    Key? key,
    required this.name,
    required this.isSelected,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTabChanged,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.rSp),
            color: isSelected ? AppColors.white : AppColors.neutralB20,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.rh),
            child: Center(
              child: Text(
                name,
                style: semiBoldTextStyle(
                  color: isSelected ? AppColors.black : AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
