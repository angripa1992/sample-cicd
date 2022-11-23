import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/values.dart';

import '../app/di.dart';
import '../resources/strings.dart';
import '../resources/styles.dart';

class PrinterConnectionSettingPage extends StatefulWidget {
  const PrinterConnectionSettingPage({Key? key}) : super(key: key);

  @override
  State<PrinterConnectionSettingPage> createState() =>
      _PrinterConnectionSettingPageState();
}

class _PrinterConnectionSettingPageState
    extends State<PrinterConnectionSettingPage> {
  final _appPreferences = getIt.get<AppPreferences>();
  late int _connectionType;

  @override
  void initState() {
    _connectionType = _appPreferences.getPrinterConnectionType();
    super.initState();
  }

  void _changePrinterConnectionType(int connectionType) {
    setState(() {
      _connectionType = connectionType;
    });
  }

  void _save() {
    _appPreferences.savePrinterConnectionType(_connectionType).then((value){
      showSuccessSnackBar(context, AppStrings.successfully_saved);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.printer_connection_settings.tr()),
        titleTextStyle: getAppBarTextStyle(),
        flexibleSpace: getAppBarBackground(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: AppSize.s20.rw,
              right: AppSize.s20.rw,
              top: AppSize.s16.rh,
              bottom: AppSize.s8.rh,
            ),
            child: Text(
              AppStrings.set_printer_connection_type.tr(),
              style: getRegularTextStyle(
                color: AppColors.purpleBlue,
                fontSize: AppFontSize.s18.rSp,
              ),
            ),
          ),
          ListTile(
            title: Text(
              AppStrings.bluetooth.tr(),
              style: getRegularTextStyle(
                color: AppColors.blueViolet,
                fontSize: AppSize.s16.rSp,
              ),
            ),
            leading: Radio(
              fillColor: MaterialStateColor.resolveWith(
                  (states) => AppColors.purpleBlue),
              value: PrinterConnectionType.BLUETOOTH,
              groupValue: _connectionType,
              onChanged: (int? type) => _changePrinterConnectionType(type!),
            ),
          ),
          ListTile(
            title: Text(
              AppStrings.usb.tr(),
              style: getRegularTextStyle(
                color: AppColors.blueViolet,
                fontSize: AppSize.s16.rSp,
              ),
            ),
            leading: Radio(
              fillColor: MaterialStateColor.resolveWith(
                  (states) => AppColors.purpleBlue),
              value: PrinterConnectionType.USB,
              groupValue: _connectionType,
              onChanged: (int? type) => _changePrinterConnectionType(type!),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.s24.rw,
              vertical: AppSize.s24.rh,
            ),
            child: LoadingButton(
              isLoading: false,
              verticalPadding: AppSize.s8.rh,
              onTap: _save,
              text: AppStrings.save.tr(),
            ),
          )
        ],
      ),
    );
  }
}
