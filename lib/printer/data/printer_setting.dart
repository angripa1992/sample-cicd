import 'package:klikit/app/extensions.dart';

import '../../app/constants.dart';

class PrinterSettingModel {
  int? branchId;
  int? typeId;
  int? rollId;

  PrinterSettingModel({this.branchId, this.typeId, this.rollId});

  PrinterSettingModel.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    typeId = json['type_id'];
    rollId = json['roll_id'];
  }

  PrinterSetting toEntity() {
    return PrinterSetting(
      branchId: branchId.orZero(),
      connectionType: typeId ?? ConnectionType.BLUETOOTH,
      paperSize: rollId ?? RollId.mm80,
      docketType: DocketType.customer,
    );
  }
}

class PrinterSetting {
  final int branchId;
  final int connectionType;
  final int paperSize;
  final int docketType;

  PrinterSetting({
    required this.branchId,
    required this.connectionType,
    required this.paperSize,
    required this.docketType,
  });
}
