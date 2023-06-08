import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/data/dockets_fonts.dart';
import 'package:klikit/printer/data/printer_setting.dart';
import 'package:klikit/printer/presentation/printer_setting_checkbox.dart';
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
import 'docket_counter_view.dart';
import 'printer_setting_radio_item.dart';

class PrinterSettingBody extends StatefulWidget {
  const PrinterSettingBody({Key? key}) : super(key: key);

  @override
  State<PrinterSettingBody> createState() => _PrinterSettingBodyState();
}

class _PrinterSettingBodyState extends State<PrinterSettingBody> {
  final _appPreferences = getIt.get<AppPreferences>();
  final _printingHandler = getIt.get<PrintingHandler>();
  late int _branchId;
  late int _connectionType;
  late int _paperSize;
  late bool _customerCopyEnabled;
  late int _customerCopyCount;
  late bool _kitchenCopyEnabled;
  late int _kitchenCopyCount;
  late int _printerFontId;

  @override
  void initState() {
    _initPrinterSetting();
    super.initState();
  }

  void _initPrinterSetting() {
    final printerSetting = _appPreferences.printerSetting();
    _branchId = printerSetting.branchId;
    _connectionType = printerSetting.connectionType;
    _paperSize = printerSetting.paperSize;
    _customerCopyEnabled = printerSetting.customerCopyEnabled;
    _kitchenCopyEnabled = printerSetting.kitchenCopyEnabled;
    _customerCopyCount = printerSetting.customerCopyCount;
    _kitchenCopyCount = printerSetting.kitchenCopyCount;
    _printerFontId = printerSetting.fontId;
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

  void _changePrinterFont(int fontId) {
    setState(() {
      _printerFontId = fontId;
    });
  }

  void _changeCustomerCopyEnabled(bool enabled) {
    setState(() {
      _customerCopyEnabled = enabled;
    });
  }

  void _changeKitchenCopyEnabled(bool enabled) {
    setState(() {
      _kitchenCopyEnabled = enabled;
    });
  }

  void _changeCustomerCopyCount(int count) {
    setState(() {
      _customerCopyCount = count;
    });
  }

  void _changeKitchenCopyCount(int count) {
    setState(() {
      _kitchenCopyCount = count;
    });
  }

  void _savePrinterSettingLocally() async {
    await _appPreferences.savePrinterSettings(
      printerSetting: _createPrinterSettingFromLocalVariables(false),
    );
    setState(() {});
  }

  void _updatePrinterSetting() {
    context.read<UpdatePrinterSettingCubit>().updatePrintSetting(
          printerSetting: _createPrinterSettingFromLocalVariables(true),
        );
  }

  PrinterSetting _createPrinterSettingFromLocalVariables(bool isUpdating) {
    return PrinterSetting(
      branchId: _branchId,
      connectionType: _connectionType,
      paperSize: _paperSize,
      customerCopyEnabled: _customerCopyEnabled,
      kitchenCopyEnabled: _kitchenCopyEnabled,
      customerCopyCount: isUpdating
          ? (_customerCopyEnabled ? _customerCopyCount : 1)
          : _customerCopyCount,
      kitchenCopyCount: isUpdating
          ? (_kitchenCopyEnabled ? _kitchenCopyCount : 1)
          : _kitchenCopyCount,
      fonts: PrinterFonts.fromId(_printerFontId),
      fontId: _printerFontId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s10.rh,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// connection type
                  _title(AppStrings.set_printer_connection_type.tr()),
                  PrinterSettingRadioItem(
                    value: ConnectionType.BLUETOOTH,
                    groupValue: _connectionType,
                    onChanged: _changePrinterConnectionType,
                    name: AppStrings.bluetooth.tr(),
                  ),
                  PrinterSettingRadioItem(
                    value: ConnectionType.USB,
                    groupValue: _connectionType,
                    onChanged: _changePrinterConnectionType,
                    name: AppStrings.usb.tr(),
                  ),

                  Divider(color: AppColors.blueViolet),

                  /// Paper size
                  _title(AppStrings.set_paper_size.tr()),
                  PrinterSettingRadioItem(
                    value: RollId.mm58,
                    groupValue: _paperSize,
                    onChanged: _changePrinterPaperSize,
                    name: '58mm',
                  ),
                  PrinterSettingRadioItem(
                    value: RollId.mm80,
                    groupValue: _paperSize,
                    onChanged: _changePrinterPaperSize,
                    name: '80mm',
                  ),

                  Divider(color: AppColors.blueViolet),

                  /// Docket type

                  _title(AppStrings.set_docket_type),
                  Row(
                    children: [
                      Expanded(
                        child: PrinterSettingCheckbox(
                          enabled: _kitchenCopyEnabled,
                          onChanged: _changeKitchenCopyEnabled,
                          name: AppStrings.kitchen,
                          willAlwaysChecked: false,
                          activeColor: AppColors.purpleBlue,
                        ),
                      ),
                      DocketCounterView(
                        enabled: _kitchenCopyEnabled,
                        count: _kitchenCopyCount,
                        onChanged: _changeKitchenCopyCount,
                        minCount: 0,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PrinterSettingCheckbox(
                          enabled: _customerCopyEnabled,
                          onChanged: _changeKitchenCopyEnabled,
                          name: AppStrings.customer,
                          willAlwaysChecked: true,
                          activeColor: AppColors.dustyGrey,
                        ),
                      ),
                      DocketCounterView(
                        enabled: _customerCopyEnabled,
                        count: _customerCopyCount,
                        onChanged: _changeCustomerCopyCount,
                        minCount: 1,
                      ),
                    ],
                  ),
                  Divider(color: AppColors.blueViolet),

                  /// Font size
                  _title(AppStrings.set_font_size),
                  PrinterSettingRadioItem(
                    value: PrinterFontSize.small,
                    groupValue: _printerFontId,
                    onChanged: _changePrinterFont,
                    name: AppStrings.small,
                  ),
                  PrinterSettingRadioItem(
                    value: PrinterFontSize.normal,
                    groupValue: _printerFontId,
                    onChanged: _changePrinterFont,
                    name: AppStrings.normal,
                  ),
                  PrinterSettingRadioItem(
                    value: PrinterFontSize.large,
                    groupValue: _printerFontId,
                    onChanged: _changePrinterFont,
                    name: AppStrings.large,
                  ),
                  PrinterSettingRadioItem(
                    value: PrinterFontSize.huge,
                    groupValue: _printerFontId,
                    onChanged: _changePrinterFont,
                    name: AppStrings.huge,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSize.s8.rh),
          Row(
            children: [
              Expanded(
                child: BlocConsumer<UpdatePrinterSettingCubit, ResponseState>(
                  listener: (context, state) {
                    if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    } else if (state is Success<ActionSuccess>) {
                      _savePrinterSettingLocally();
                      showSuccessSnackBar(context, state.data.message ?? '');
                    }
                  },
                  builder: (context, state) {
                    return LoadingButton(
                      isLoading: state is Loading,
                      verticalPadding: AppSize.s12.rh,
                      onTap: _updatePrinterSetting,
                      text: AppStrings.save.tr(),
                      textSize: AppFontSize.s13.rSp,
                    );
                  },
                ),
              ),
              SizedBox(width: AppSize.s8.rw),
              Expanded(
                child: AppButton(
                  enable: _appPreferences.printerSetting().connectionType ==
                      _connectionType,
                  verticalPadding: AppSize.s10.rh,
                  onTap: () {
                    _printingHandler.showDevices();
                  },
                  text: AppStrings.show_devices.tr(),
                  textSize: AppFontSize.s13.rSp,
                  icon: _appPreferences.printerSetting().connectionType ==
                          ConnectionType.BLUETOOTH
                      ? Icons.bluetooth
                      : Icons.usb,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _title(String title) {
    return Text(
      title,
      style: getMediumTextStyle(
        color: AppColors.purpleBlue,
        fontSize: AppFontSize.s16.rSp,
      ),
    );
  }
}
