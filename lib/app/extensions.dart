const String EMPTY = '';
const int ZERO = 0;
const double ZERO_DECIMAL = 0.0;

// extension on String
extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return EMPTY;
    } else {
      return this!;
    }
  }
}

// extension on Integer
extension NonNullInteger on int? {
  int orZero() {
    if (this == null) {
      return ZERO;
    } else {
      return this!;
    }
  }
}

// extension on Double
extension NonNullDouble on double? {
  double orZero() {
    if (this == null) {
      return ZERO_DECIMAL;
    } else {
      return this!;
    }
  }
}
