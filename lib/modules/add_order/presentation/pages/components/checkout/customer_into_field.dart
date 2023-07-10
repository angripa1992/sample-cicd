import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class CustomerInfoField extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const CustomerInfoField(
      {Key? key, required this.controller, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s4.rw),
          child: Text(
            title,
            style: mediumTextStyle(
              color: AppColors.dustyGreay,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            color: AppColors.seaShell,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintStyle: regularTextStyle(
                  color: AppColors.dustyGreay,
                  fontSize: AppFontSize.s14.rSp,
                ),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
              ),
            ),
          ),
        )
      ],
    );
  }
}
