import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/presentation/update_printer_setting_cubit.dart';
import 'package:klikit/printer/printing_handler.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/values.dart';

import '../../app/di.dart';
import '../../core/utils/response_state.dart';
import '../../modules/widgets/app_button.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';

class PrinterConnectionSettingPage extends StatefulWidget {
  const PrinterConnectionSettingPage({Key? key}) : super(key: key);

  @override
  State<PrinterConnectionSettingPage> createState() =>
      _PrinterConnectionSettingPageState();
}

class _PrinterConnectionSettingPageState
    extends State<PrinterConnectionSettingPage> {
  final _appPreferences = getIt.get<AppPreferences>();
  final _printingHandler = getIt.get<PrintingHandler>();
  late int _connectionType;
  late int _paperSize;

  @override
  void initState() {
    _connectionType = _appPreferences.connectionType();
    _paperSize = _appPreferences.paperSize();
    print(_paperSize);
    super.initState();
  }

  void _changePrinterConnectionType(int connectionType) {
    setState(() {
      _connectionType = connectionType;
    });
  }

  void _changePrinterPaperSize(int paperSize) {
    setState(() {
      _paperSize = paperSize;
    });
  }

  void _savePrinterSettingToPreferences() async {
    await _appPreferences.savePrinterConnectionType(_connectionType);
    await _appPreferences.savePrinterPaperSize(_paperSize);
    setState(() {});
  }

  void _updatePrinterSetting() {
    context.read<UpdatePrinterSettingCubit>().updatePrintSetting(
          connectionType: _connectionType,
          paperSize: _paperSize,
        );
  }

  void _showDeviceListView() {
    if (_appPreferences.connectionType() == ConnectionType.BLUETOOTH) {
      _printingHandler.showBleDevices();
    } else {
      _printingHandler.showUsbDevices();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_paperSize);
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
          /// connection type
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
              value: ConnectionType.BLUETOOTH,
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
              value: ConnectionType.USB,
              groupValue: _connectionType,
              onChanged: (int? type) => _changePrinterConnectionType(type!),
            ),
          ),

          /// Paper size

          Padding(
            padding: EdgeInsets.only(
              left: AppSize.s20.rw,
              right: AppSize.s20.rw,
              top: AppSize.s16.rh,
              bottom: AppSize.s8.rh,
            ),
            child: Text(
              AppStrings.set_paper_size.tr(),
              style: getRegularTextStyle(
                color: AppColors.purpleBlue,
                fontSize: AppFontSize.s18.rSp,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'mm58',
              style: getRegularTextStyle(
                color: AppColors.blueViolet,
                fontSize: AppSize.s16.rSp,
              ),
            ),
            leading: Radio(
              fillColor: MaterialStateColor.resolveWith(
                  (states) => AppColors.purpleBlue),
              value: RollId.mm58,
              groupValue: _paperSize,
              onChanged: (int? size) => _changePrinterPaperSize(size!),
            ),
          ),
          ListTile(
            title: Text(
              'mm80',
              style: getRegularTextStyle(
                color: AppColors.blueViolet,
                fontSize: AppSize.s16.rSp,
              ),
            ),
            leading: Radio(
              fillColor: MaterialStateColor.resolveWith(
                  (states) => AppColors.purpleBlue),
              value: RollId.mm80,
              groupValue: _paperSize,
              onChanged: (int? size) => _changePrinterPaperSize(size!),
            ),
          ),

          /// save button

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.s24.rw,
              vertical: AppSize.s24.rh,
            ),
            child: BlocConsumer<UpdatePrinterSettingCubit, ResponseState>(
              listener: (context, state) {
                if (state is Failed) {
                  showApiErrorSnackBar(context, state.failure);
                } else if (state is Success<ActionSuccess>) {
                  _savePrinterSettingToPreferences();
                  showSuccessSnackBar(context, state.data.message ?? '');
                }
              },
              builder: (context, state) {
                return LoadingButton(
                  isLoading: state is Loading,
                  verticalPadding: AppSize.s10.rh,
                  onTap: _updatePrinterSetting,
                  text: AppStrings.save.tr(),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s24.rw),
            child: AppButton(
              enable: _appPreferences.connectionType() == _connectionType,
              verticalPadding: AppSize.s10.rh,
              onTap: _showDeviceListView,
              text: AppStrings.show_devices.tr(),
              icon: _appPreferences.connectionType() == ConnectionType.BLUETOOTH
                  ? Icons.bluetooth
                  : Icons.usb,
            ),
          ),
        ],
      ),
    );
  }
}
