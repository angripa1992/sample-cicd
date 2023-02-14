import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/printer/data/printer_setting.dart';
import 'package:klikit/printer/presentation/printer_setting_body.dart';
import 'package:klikit/printer/presentation/printer_setting_cubit.dart';

import '../../app/di.dart';
import '../../core/utils/response_state.dart';
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

  @override
  void initState() {
    context.read<PrinterSettingCubit>().getPrinterSetting();
    super.initState();
  }

  void _savePrinterSettingLocally({
    required int connectionType,
    required int paperSize,
  }) async {
    await _appPreferences.savePrinterConnectionType(connectionType);
    await _appPreferences.savePrinterPaperSize(paperSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.printer_connection_settings.tr()),
        titleTextStyle: getAppBarTextStyle(),
        flexibleSpace: getAppBarBackground(),
      ),
      body: BlocBuilder<PrinterSettingCubit, ResponseState>(
        builder: (_, state) {
          if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Success<PrinterSetting>) {
            _savePrinterSettingLocally(
              connectionType: state.data.typeId,
              paperSize: state.data.rollId,
            );
          }
          return const PrinterSettingBody();
        },
      ),
    );
  }
}
