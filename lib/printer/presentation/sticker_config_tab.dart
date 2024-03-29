import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/printer/presentation/printer_setting_cubit.dart';
import 'package:klikit/printer/presentation/set_printer_connection_type.dart';
import 'package:klikit/printer/presentation/update_printer_setting_cubit.dart';
import 'package:klikit/printer/printer_local_data_manager.dart';
import 'package:klikit/printer/printer_manager.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/styles.dart';

import '../../app/constants.dart';
import '../../core/utils/response_state.dart';
import '../../modules/orders/data/models/action_success_model.dart';
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
  final _printingHandler = getIt.get<PrinterManager>();
  late bool _stickerPrinterEnabled;
  late ValueNotifier<bool> _stickerPrinterStateListener;
  final showDevicesController = KTButtonController(label: AppStrings.show_devices.tr());
  final _saveButtonController = KTButtonController(label: AppStrings.save.tr());

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
    _stickerPrinterEnabled = LocalPrinterDataManager().stickerPrinterEnabled();
    _stickerPrinterStateListener = ValueNotifier(_stickerPrinterEnabled);
  }

  void _savePrinterSettingLocally({PrinterSetting? savingData}) async {
    await LocalPrinterDataManager().savePrinterSetting(savingData ?? _createPrinterSettingFromLocalVariables(false));
    if (savingData == null) {
      _stickerPrinterStateListener.value = !_stickerPrinterEnabled;
      _stickerPrinterStateListener.value = LocalPrinterDataManager().stickerPrinterEnabled();
    }
  }

  void _updatePrinterSetting() {
    context.read<UpdatePrinterSettingCubit>().updatePrintSetting(printerSetting: _createPrinterSettingFromLocalVariables(true));
  }

  PrinterSetting _createPrinterSettingFromLocalVariables(bool isUpdating) {
    final printerSetting = LocalPrinterDataManager().printerSetting();
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
          return const Center(child: CircularProgress());
        } else if (state is Success<PrinterSetting>) {
          _savePrinterSettingLocally(savingData: state.data);
          _initPrinterSetting();
          return _body();
        }
        return const SizedBox();
      },
    );
  }

  Widget _body() => Column(
        children: [
          SetPrinterConnectionType(
            isDocket: false,
            initType: _stickerPrinterEnabled ? CType.BLE : CType.DISABLED,
            device: LocalPrinterDataManager().activeDevice(),
            onChanged: (type) {
              _stickerPrinterEnabled = (type == CType.BLE);
              _stickerPrinterStateListener.value = _stickerPrinterEnabled;
            },
          ),
          const Spacer(),
          _buttons(),
        ],
      );

  Widget _buttons() => Container(
        color: AppColors.white,
        padding: EdgeInsets.all(16.rSp),
        child: Row(
          children: [
            Expanded(
              child: BlocConsumer<UpdatePrinterSettingCubit, ResponseState>(
                listener: (context, state) {
                  _saveButtonController.setLoaded(state is! Loading);
                  if (state is Failed) {
                    showApiErrorSnackBar(context, state.failure);
                  } else if (state is Success<ActionSuccess>) {
                    _savePrinterSettingLocally();
                    showSuccessSnackBar(context, state.data.message ?? '');
                  }
                },
                builder: (context, state) {
                  return KTButton(
                    controller: _saveButtonController,
                    backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP300),
                    labelStyle: mediumTextStyle(color: AppColors.white),
                    progressPrimaryColor: AppColors.white,
                    verticalContentPadding: 10.rh,
                    onTap: _updatePrinterSetting,
                  );
                },
              ),
            ),
            SizedBox(width: AppSize.s8.rw),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _stickerPrinterStateListener,
                builder: (_, value, __) {
                  showDevicesController.setEnabled(LocalPrinterDataManager().stickerPrinterEnabled());
                  return KTButton(
                    controller: showDevicesController,
                    prefixWidget: Icon(
                      LocalPrinterDataManager().stickerPrinterEnabled() ? Icons.bluetooth : Icons.bluetooth_disabled,
                      size: 20.rSp,
                    ),
                    backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.white, strokeColor: AppColors.neutralB40),
                    labelStyle: mediumTextStyle(),
                    splashColor: AppColors.greyBright,
                    onTap: () {
                      _printingHandler.showPrinterDevicesForConnect(initialIndex: PrinterTab.STICKER);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
}
