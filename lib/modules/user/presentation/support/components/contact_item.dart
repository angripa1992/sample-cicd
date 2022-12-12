import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class ContactItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color? iconColor;

  const ContactItem(
      {Key? key,
      required this.iconData,
      required this.title,
      required this.description,
      required this.onTap,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteSmoke,
      borderRadius: BorderRadius.circular(AppSize.s16.rSp),
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.lightViolet,
        borderRadius: BorderRadius.circular(AppSize.s16.rSp),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.s24.rh,
            horizontal: AppSize.s24.rw,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getMediumTextStyle(
                        color: AppColors.purpleBlue,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                    SizedBox(height: AppSize.s4.rh),
                    Text(
                      description,
                      style: getRegularTextStyle(
                        color: AppColors.blackCow,
                        fontSize: AppFontSize.s12.rSp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSize.s28.rw),
              Icon(
                iconData,
                color: iconColor ?? AppColors.purpleBlue,
                size: AppSize.s32.rSp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
