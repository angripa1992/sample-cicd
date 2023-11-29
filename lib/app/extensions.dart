import 'package:docket_design_template/utils/printer_configuration.dart';
import 'package:flutter/material.dart';
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

extension RemoveDotFromString on String {
  String removeDot() {
    return this.replaceAll('.', '');
  }
}

extension SpaceDivider on double {
  SizedBox verticalSpacer() {
    return SizedBox(height: this);
  }

  SizedBox horizontalSpacer() {
    return SizedBox(width: this);
  }

  SizedBox axisBasedSpacer(Axis direction, double space) {
    return direction == Axis.horizontal ? space.horizontalSpacer() : space.verticalSpacer();
  }
}

extension WidgetVisibility on Widget? {
  Visibility setVisibility() {
    return Visibility(visible: this != null, child: this!);
  }

  Widget setVisibilityWithSpace({double? startSpace, double? endSpace, required Axis direction}) {
    if (this == null) {
      return Container();
    } else {
      List<Widget> children = [];
      if (startSpace != null) {
        children.add(startSpace.axisBasedSpacer(direction, startSpace));
      }
      children.add(this!);
      if (endSpace != null) {
        children.add(endSpace.axisBasedSpacer(direction, endSpace));
      }

      if (direction == Axis.horizontal) {
        return Row(
          children: children,
        );
      } else {
        return Column(
          children: children,
        );
      }
    }
  }
}
