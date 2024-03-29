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
              AppStrings.select_docket_type.tr(),
              style: mediumTextStyle(
                color: AppColors.primary,
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

  const DocketTypeSelectionView({Key? key, required this.onChange}) : super(key: key);

  @override
  State<DocketTypeSelectionView> createState() => _DocketTypeSelectionViewState();
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
            AppStrings.kitchen.tr(),
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppSize.s16.rSp,
            ),
          ),
          leading: Radio(
            fillColor: MaterialStateColor.resolveWith((states) => AppColors.primary),
            value: DocketType.kitchen,
            groupValue: _currentDocketType,
            onChanged: (int? type) => _changeDocketType(type!),
          ),
        ),
        ListTile(
          title: Text(
            AppStrings.customer.tr(),
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppSize.s16.rSp,
            ),
          ),
          leading: Radio(
            fillColor: MaterialStateColor.resolveWith((states) => AppColors.primary),
            value: DocketType.customer,
            groupValue: _currentDocketType,
            onChanged: (int? type) => _changeDocketType(type!),
          ),
        ),
        AppButton(
          onTap: () {
            widget.onChange(_currentDocketType);
          },
          text: AppStrings.select.tr(),
        ),
      ],
    );
  }
}
