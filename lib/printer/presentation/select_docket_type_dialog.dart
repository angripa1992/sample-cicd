import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/widgets/app_button.dart';

import '../../core/route/routes_generator.dart';
import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';

void showSelectDocketTypeDialog({
  required Function(int) onSelect,
}) {
  showDialog(
    context: RoutesGenerator.navigatorKey.currentState!.context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSize.s16.rSp),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.select_docket_type,
              style: getMediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s20.rSp,
              ),
            ),
            DocketTypeSelectionView(
              onChange: (type) {
                Navigator.pop(context);
                onSelect(type);
              },
            ),
          ],
        ),
      );
    },
  );
}

class DocketTypeSelectionView extends StatefulWidget {
  final Function(int) onChange;

  const DocketTypeSelectionView({Key? key, required this.onChange})
      : super(key: key);

  @override
  State<DocketTypeSelectionView> createState() =>
      _DocketTypeSelectionViewState();
}

class _DocketTypeSelectionViewState extends State<DocketTypeSelectionView> {
  int _currentDocketType = DocketType.customer;

  void _changeDocketType(int type) {
    setState(() {
      _currentDocketType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            AppStrings.kitchen,
            style: getRegularTextStyle(
              color: AppColors.blueViolet,
              fontSize: AppSize.s16.rSp,
            ),
          ),
          leading: Radio(
            fillColor: MaterialStateColor.resolveWith(
                (states) => AppColors.purpleBlue),
            value: DocketType.kitchen,
            groupValue: _currentDocketType,
            onChanged: (int? type) => _changeDocketType(type!),
          ),
        ),
        ListTile(
          title: Text(
            AppStrings.customer,
            style: getRegularTextStyle(
              color: AppColors.blueViolet,
              fontSize: AppSize.s16.rSp,
            ),
          ),
          leading: Radio(
            fillColor: MaterialStateColor.resolveWith(
                (states) => AppColors.purpleBlue),
            value: DocketType.customer,
            groupValue: _currentDocketType,
            onChanged: (int? type) => _changeDocketType(type!),
          ),
        ),
        AppButton(
          onTap: () {
            widget.onChange(_currentDocketType);
          },
          enable: true,
          text: AppStrings.select.tr(),
          verticalPadding: AppSize.s8.rh,
        ),
      ],
    );
  }
}
