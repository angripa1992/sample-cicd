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
      typeId: typeId ?? ConnectionType.BLUETOOTH,
      rollId: rollId ?? RollId.mm80,
    );
  }
}

class PrinterSetting {
  final int branchId;
  final int typeId;
  final int rollId;

  PrinterSetting({
    required this.branchId,
    required this.typeId,
    required this.rollId,
  });
}
