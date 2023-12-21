import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/data/printer_setting.dart';
import 'package:klikit/printer/presentation/printer_setting_cubit.dart';
import 'package:klikit/printer/presentation/set_docket_type.dart';
import 'package:klikit/printer/presentation/set_font_size.dart';
import 'package:klikit/printer/presentation/set_paper_size.dart';
import 'package:klikit/printer/presentation/set_printer_connection_type.dart';
import 'package:klikit/printer/presentation/update_printer_setting_cubit.dart';
import 'package:klikit/printer/printing_handler.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../app/di.dart';
import '../../core/utils/response_state.dart';
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
  final _showDevicesController = KTButtonController(label: AppStrings.show_devices.tr());
  final _saveButtonController = KTButtonController(label: AppStrings.save.tr());

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
  }

  void _savePrinterSettingLocally({PrinterSetting? savingData}) async {
    await _appPreferences.savePrinterSettings(
      printerSetting: savingData ?? _createPrinterSettingFromLocalVariables(false),
    );
    if (savingData == null) {
      _connectionStateListener.value = 0;
      _connectionStateListener.value = _appPreferences.printerSetting().type;
    }
  }

  void _updatePrinterSetting() {
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
      customerCopyCount: isUpdating ? (_customerCopyEnabled ? _customerCopyCount : 1) : _customerCopyCount,
      kitchenCopyCount: isUpdating ? (_kitchenCopyEnabled ? (_kitchenCopyCount > 0 ? _kitchenCopyCount : 1) : 0) : _kitchenCopyCount,
      fonts: PrinterFonts.fromId(_printerFontId),
      fontId: _printerFontId,
      stickerPrinterEnabled: _appPreferences.printerSetting().stickerPrinterEnabled,
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

  Widget _body() => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: AppColors.white,
                    padding: EdgeInsets.all(13.rSp),
                    child: Row(
                      children: [
                        DecoratedImageView(
                          iconWidget: ImageResourceResolver.printerSVG.getImageWidget(
                            height: 20.rh,
                            width: 20.rw,
                            color: AppColors.primaryP300,
                          ),
                          padding: EdgeInsets.all(6.rSp),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLighter,
                            borderRadius: BorderRadius.all(
                              Radius.circular(200.rSp),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.rw),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Test Print',
                                style: semiBoldTextStyle(fontSize: AppFontSize.s14.rSp, color: AppColors.black),
                              ),
                              Text(
                                'Test your printing connectivity',
                                style: regularTextStyle(
                                  color: AppColors.neutralB100,
                                  fontSize: AppFontSize.s12.rSp,
                                ),
                              )
                            ],
                          ),
                        ),
                        KTButton(
                          controller: KTButtonController(label: 'Test Print'),
                          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP50),
                          prefixWidget: SizedBox(
                            width: 20.rw,
                          ),
                          labelStyle: mediumTextStyle(color: AppColors.primaryP300),
                          suffixWidget: SizedBox(
                            width: 20.rw,
                          ),
                          onTap: () {},
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 4.rh),
                  SetPrinterConnectionType(
                    initType: _connectionType,
                    willUsbEnabled: true,
                    onChanged: (type) {
                      _connectionType = type;
                      _connectionStateListener.value = type;
                    },
                  ),
                  SizedBox(height: 4.rh),
                  SetPaperSize(
                    initSize: _paperSize,
                    onChanged: (size) {
                      _paperSize = size;
                    },
                  ),
                  SizedBox(height: 4.rh),
                  SetFontSize(
                    initFont: _printerFontId,
                    onChanged: (font) {
                      _printerFontId = font;
                    },
                  ),
                  SizedBox(height: 4.rh),
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
                  SizedBox(height: 4.rh),
                ],
              ),
            ),
          ),
          SizedBox(height: 4.rh),
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
                valueListenable: _connectionStateListener,
                builder: (_, value, __) {
                  _showDevicesController.setEnabled(_appPreferences.printerSetting().type == value);

                  return KTButton(
                    controller: _showDevicesController,
                    prefixWidget: Icon(_appPreferences.printerSetting().type == CType.BLE ? Icons.bluetooth : Icons.usb),
                    backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.white, strokeColor: AppColors.neutralB40),
                    labelStyle: mediumTextStyle(),
                    splashColor: AppColors.greyBright,
                    onTap: () {
                      _printingHandler.showDevices(initialIndex: PrinterSelectIndex.docket);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
}
