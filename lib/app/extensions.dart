import 'package:docket_design_template/utils/printer_configuration.dart';
import 'package:klikit/app/constants.dart';

const String EMPTY = '';
const int ZERO = 0;
const double ZERO_DECIMAL = 0.0;
const bool FALSE = false;

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return EMPTY;
    } else {
      return this!;
    }
  }
}

extension NonNullInteger on int? {
  int orZero() {
    if (this == null) {
      return ZERO;
    } else {
      return this!;
    }
  }
}

extension NonNullDouble on double? {
  double orZero() {
    if (this == null) {
      return ZERO_DECIMAL;
    } else {
      return this!;
    }
  }
}

extension NonNullBoolean on bool? {
  bool orFalse() {
    return this ?? FALSE;
  }
}

extension StringToInteger on String? {
  int toInt() {
    if (this == null) {
      return ZERO;
    } else {
      return int.parse(this!);
    }
  }
}

extension PaperSizeToRollSize on int {
  Roll toRollSize() {
   if(this == RollId.mm58){
     return Roll.mm58;
   }else{
     return Roll.mm80;
   }
  }
}

extension RemoveDotFromString on String {
  String removeDot() {
    return this.replaceAll('.', '');
  }
}
