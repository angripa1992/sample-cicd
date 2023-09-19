import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/printer/presentation/printer_setting_cubit.dart';
import 'package:klikit/printer/presentation/set_printer_connection_type.dart';
import 'package:klikit/printer/presentation/update_printer_setting_cubit.dart';
import 'package:klikit/printer/printing_handler.dart';

import '../../app/app_preferences.dart';
import '../../app/constants.dart';
import '../../core/utils/response_state.dart';
import '../../modules/orders/data/models/action_success_model.dart';
import '../../modules/widgets/app_button.dart';
import '../../modules/widgets/loading_button.dart';
import '../../modules/widgets/snackbars.dart';
import '../../resources/colors.dart';
import '../../resources/strings.dart';
import '../../resources/values.dart';
import '../data/printer_setting.dart';

class StickerConfigTab extends StatefulWidget {
  const StickerConfigTab({Key? key}) : super(key: key);

  @override
  State<StickerConfigTab> createState() => _StickerConfigTabState();
}

class _StickerConfigTabState extends State<StickerConfigTab> {
  final _appPreferences = getIt.get<AppPreferences>();
  final _printingHandler = getIt.get<PrintingHandler>();
  late bool _stickerPrinterEnabled;
  late ValueNotifier<bool> _stickerPrinterStateListener;

  @override
  void initState() {
    context.read<PrinterSettingCubit>().getPrinterSetting();
    super.initState();
  }

  @override
  void dispose() {
    _stickerPrinterStateListener.dispose();
    super.dispose();
  }

  void _initPrinterSetting() {
    final printerSetting = _appPreferences.printerSetting();
    _stickerPrinterEnabled = printerSetting.stickerPrinterEnabled;
    _stickerPrinterStateListener = ValueNotifier(_stickerPrinterEnabled);
  }

  void _savePrinterSettingLocally({PrinterSetting? savingData}) async {
    await _appPreferences.savePrinterSettings(
      printerSetting: savingData ?? _createPrinterSettingFromLocalVariables(false),
    );
    if (savingData == null) {
      _stickerPrinterStateListener.value = !_stickerPrinterEnabled;
      _stickerPrinterStateListener.value = _appPreferences.printerSetting().stickerPrinterEnabled;
    }
  }

  void _updatePrinterSetting() {
    context.read<UpdatePrinterSettingCubit>().updatePrintSetting(
          printerSetting: _createPrinterSettingFromLocalVariables(true),
        );
  }

  PrinterSetting _createPrinterSettingFromLocalVariables(bool isUpdating) {
    final printerSetting = _appPreferences.printerSetting();
    return PrinterSetting(
      branchId: printerSetting.branchId,
      type: printerSetting.type,
      paperSize: printerSetting.paperSize,
      customerCopyEnabled: printerSetting.customerCopyEnabled,
      kitchenCopyEnabled: printerSetting.kitchenCopyEnabled,
      customerCopyCount: printerSetting.customerCopyCount,
      kitchenCopyCount: printerSetting.kitchenCopyCount,
      fonts: PrinterFonts.fromId(printerSetting.fontId),
      fontId: printerSetting.fontId,
      stickerPrinterEnabled: _stickerPrinterEnabled,
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
            SetPrinterConnectionType(
              willUsbEnabled: false,
              initType: _stickerPrinterEnabled ? CType.BLE : CType.USB,
              onChanged: (type) {
                _stickerPrinterEnabled = type == CType.BLE;
                _stickerPrinterStateListener.value = _stickerPrinterEnabled;
              },
            ),
            const Spacer(),
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
              valueListenable: _stickerPrinterStateListener,
              builder: (_, value, __) {
                return AppButton(
                  enable: _appPreferences.printerSetting().stickerPrinterEnabled,
                  onTap: () {
                    _printingHandler.showDevices(initialIndex: PrinterSelectIndex.sticker);
                  },
                  text: AppStrings.show_devices.tr(),
                  color: AppColors.white,
                  borderColor: AppColors.black,
                  textColor: AppColors.black,
                  icon: _appPreferences.printerSetting().stickerPrinterEnabled ? Icons.bluetooth : Icons.bluetooth_disabled,
                );
              },
            ),
          ),
        ],
      );
}
