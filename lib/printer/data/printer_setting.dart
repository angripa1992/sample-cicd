import 'package:klikit/app/extensions.dart';

class PrinterSettingModel {
  int? branchId;
  int? typeId;

  PrinterSettingModel({this.branchId, this.typeId});

  PrinterSettingModel.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    typeId = json['type_id'];
  }

  PrinterSetting toEntity() {
    return PrinterSetting(branchId: branchId.orZero(), typeId: typeId.orZero());
  }
}

class PrinterSetting {
  final int branchId;
  final int typeId;

  PrinterSetting({required this.branchId, required this.typeId});
}
