import 'package:docket_design_template/utils/printer_configuration.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';

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

extension EmptyToNUll on String? {
  String? notEmptyOrNull() {
    if (this != null && this!.isNotEmpty) {
      return this!;
    } else {
      return null;
    }
  }

  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  bool isNotNullOrEmpty() {
    return !(this == null || this!.isEmpty);
  }
}

extension ZeroToNUll on int? {
  int? notZeroOrNull() {
    if (this != null && this! > 0) {
      return this!;
    } else {
      return null;
    }
  }
}

extension NumZeroToNUll on num? {
  num? notZeroOrNull() {
    if (this != null && this! > 0) {
      return this!;
    } else {
      return null;
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

extension NonNullNum on num? {
  num orZero() {
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
    if (this == RollId.mm58) {
      return Roll.mm58;
    } else {
      return Roll.mm80;
    }
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension RemoveDotFromString on String {
  String removeDot() {
    return replaceAll('.', '');
  }
}

extension SpaceDivider on num {
  SizedBox verticalSpacer() {
    return SizedBox(height: rh);
  }

  SizedBox horizontalSpacer() {
    return SizedBox(width: rw);
  }

  SizedBox axisBasedSpacer(Axis direction, num space) {
    return direction == Axis.horizontal ? space.horizontalSpacer() : space.verticalSpacer();
  }
}

extension WidgetVisibility on Widget? {
  Visibility setVisibility() {
    return Visibility(visible: this != null, child: this ?? const SizedBox());
  }

  Widget setVisibilityWithSpace({num? startSpace, num? endSpace, required Axis direction}) {
    if (this == null) {
      return const SizedBox();
    } else {
      return Padding(
        padding: EdgeInsets.only(
          top: direction == Axis.vertical && startSpace != null ? startSpace.rh : 0,
          bottom: direction == Axis.vertical && endSpace != null ? endSpace.rh : 0,
          left: direction == Axis.horizontal && startSpace != null ? startSpace.rw : 0,
          right: direction == Axis.horizontal && endSpace != null ? endSpace.rw : 0,
        ),
        child: this,
      );
    }
  }
}
