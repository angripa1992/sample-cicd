import 'package:flutter/material.dart';

import '../../../../../resources/colors.dart';

class ModifierSwitchView extends StatefulWidget {
  const ModifierSwitchView({Key? key}) : super(key: key);

  @override
  State<ModifierSwitchView> createState() => _ModifierSwitchViewState();
}

class _ModifierSwitchViewState extends State<ModifierSwitchView> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: true,
      activeColor: AppColors.purpleBlue,
      activeTrackColor: AppColors.lightViolet,
      inactiveThumbColor: AppColors.black,
      inactiveTrackColor: AppColors.smokeyGrey,
      onChanged: (value) {},
    );
  }
}
