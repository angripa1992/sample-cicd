import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/printer/data/printer_setting.dart';

class LocalPrinterDataManager {
  static final _instance = LocalPrinterDataManager._internal();
  late AppPreferences _appPreferences;

  factory LocalPrinterDataManager() => _instance;

  LocalPrinterDataManager._internal() {
    _appPreferences = getIt.get<AppPreferences>();
  }

  Future<void> setActiveDevice(int device) async => await _appPreferences.setActiveDevice(device);

  Future<void> saveLocalPrinter(LocalPrinter printer) async => await _appPreferences.saveLocalPrinter(printer);

  Future<void> savePrinterSetting(PrinterSetting printerSetting) async => await _appPreferences.savePrinterSettings(printerSetting);

  LocalPrinter? localPrinter() => _appPreferences.localPrinter();

  PrinterSetting printerSetting() => _appPreferences.printerSetting();

  Future<void> clearLocalPrinter() => _appPreferences.clearLocalPrinter();

  int activeDevice() => _appPreferences.activeDevice();

  int cType() => _appPreferences.printerSetting().type;

  bool stickerPrinterEnabled() => _appPreferences.printerSetting().stickerPrinterEnabled;
}
