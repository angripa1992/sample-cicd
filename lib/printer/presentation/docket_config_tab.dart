import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/data/printer_setting.dart';
import 'package:klikit/printer/presentation/printer_setting_cubit.dart';
import 'package:klikit/printer/presentation/set_docket_type.dart';
import 'package:klikit/printer/presentation/set_font_size_dropdown.dart';
import 'package:klikit/printer/presentation/set_paper_size.dart';
import 'package:klikit/printer/presentation/set_printer_address.dart';
import 'package:klikit/printer/presentation/set_printer_connection_type.dart';
import 'package:klikit/printer/presentation/update_printer_setting_cubit.dart';
import 'package:klikit/printer/printing_handler.dart';
import 'package:klikit/resources/values.dart';

import '../../app/di.dart';
import '../../core/utils/response_state.dart';
import '../../modules/widgets/app_button.dart';
import '../../resources/colors.dart';
import '../../resources/strings.dart';

class DocketConfigTab extends StatefulWidget {
  const DocketConfigTab({Key? key}) : super(key: key);

  @override
  State<DocketConfigTab> createState() => _DocketConfigTabState();
}

class _DocketConfigTabState extends State<DocketConfigTab> {
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
  late ValueNotifier<int> _connectionStateListener;
  late String _printerIpAddress;

  @override
  void initState() {
    context.read<PrinterSettingCubit>().getPrinterSetting();
    super.initState();
  }

  @override
  void dispose() {
    _connectionStateListener.dispose();
    super.dispose();
  }

  void _initPrinterSetting() {
    final printerSetting = _appPreferences.printerSetting();
    _branchId = printerSetting.branchId;
    _connectionType = printerSetting.type;
    _paperSize = printerSetting.paperSize;
    _customerCopyEnabled = printerSetting.customerCopyEnabled;
    _kitchenCopyEnabled = printerSetting.kitchenCopyEnabled;
    _customerCopyCount = printerSetting.customerCopyCount;
    _kitchenCopyCount = printerSetting.kitchenCopyCount;
    _printerFontId = printerSetting.fontId;
    _connectionStateListener = ValueNotifier(_connectionType);
    _printerIpAddress=_appPreferences.getPrinterIpAddress()??'';
  }

  void _savePrinterSettingLocally({PrinterSetting? savingData}) async {
    // await _appPreferences.setPrinterIpAddress(_printerIpAddress);
    await _appPreferences.savePrinterSettings(
      printerSetting:
          savingData ?? _createPrinterSettingFromLocalVariables(false),
    );
    if (savingData == null) {
      _connectionStateListener.value = 0;
      _connectionStateListener.value =
          _appPreferences.printerSetting().type;
    }
  }

  void _updatePrinterSetting() {
    _appPreferences.setPrinterIpAddress(_printerIpAddress);
    context.read<UpdatePrinterSettingCubit>().updatePrintSetting(
          printerSetting: _createPrinterSettingFromLocalVariables(true),
        );
  }

  PrinterSetting _createPrinterSettingFromLocalVariables(bool isUpdating) {
    return PrinterSetting(
      branchId: _branchId,
      type: _connectionType,
      paperSize: _paperSize,
      customerCopyEnabled: _customerCopyEnabled,
      kitchenCopyEnabled: _kitchenCopyEnabled,
      customerCopyCount: isUpdating
          ? (_customerCopyEnabled ? _customerCopyCount : 1)
          : _customerCopyCount,
      kitchenCopyCount: isUpdating
          ? (_kitchenCopyEnabled
              ? (_kitchenCopyCount > 0 ? _kitchenCopyCount : 1)
              : 0)
          : _kitchenCopyCount,
      fonts: PrinterFonts.fromId(_printerFontId),
      fontId: _printerFontId,
      stickerPrinterEnabled:
          _appPreferences.printerSetting().stickerPrinterEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrinterSettingCubit, ResponseState>(
      builder: (_, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is Success<PrinterSetting>) {
          _savePrinterSettingLocally(savingData: state.data);
          _initPrinterSetting();
          return _body();
        }
        return const SizedBox();
      },
    );
  }

  Widget _body() => Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.s10.rh,
          horizontal: AppSize.s8.rw,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SetPrinterConnectionType(
                      initType: _connectionType,
                      willUsbEnabled: true,
                      onChanged: (type) {
                        _connectionType = type;
                        _connectionStateListener.value = type;
                      },
                    ),
                    SetPrinterAddressText(
                      address: _printerIpAddress,
                      onSaved: (txt){
                        _printerIpAddress = txt;
                      },
                    ),
                    SetPaperSize(
                      initSize: _paperSize,
                      onChanged: (size) {
                        _paperSize = size;
                      },
                    ),
                    SetDocketType(
                      initCustomerCopyEnabled: _customerCopyEnabled,
                      initCustomerCopyCount: _customerCopyCount,
                      initKitchenCopyEnabled: _kitchenCopyEnabled,
                      initKitchenCopyCount: _kitchenCopyCount,
                        changeCustomerCopyCount: (count) {
                        _customerCopyCount = count;
                      },
                      changeKitchenCopyCount: (count) {
                        _kitchenCopyCount = count;
                      },
                      changeKitchenCopyEnabled: (enabled) {
                        _kitchenCopyEnabled = enabled;
                      },
                    ),
                    SetFontSizeDropDown(
                      initFont: _printerFontId,
                      onChanged: (font) {
                        _printerFontId = font;
                      },
                    ),
                  ],
                ),
              ),
            ),
            _buttons(),
          ],
        ),
      );

  Widget _buttons() => Row(
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
                  onTap: _updatePrinterSetting,
                  text: AppStrings.save.tr(),
                );
              },
            ),
          ),
          SizedBox(width: AppSize.s8.rw),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _connectionStateListener,
              builder: (_, value, __) {
                return AppButton(
                  enable:
                      _appPreferences.printerSetting().type == value,
                  onTap: () {
                    _printingHandler.showDevices(
                        initialIndex: PrinterSelectIndex.docket);
                  },
                  text: AppStrings.show_devices.tr(),
                  color: AppColors.white,
                  borderColor: AppColors.black,
                  textColor: AppColors.black,
                  icon: _appPreferences.printerSetting().type ==
                          CType.BLE
                      ? Icons.bluetooth
                      : Icons.usb,
                );
              },
            ),
          ),
        ],
      );
}
