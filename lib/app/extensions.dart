const String EMPTY = '';
const int ZERO = 0;
const double ZERO_DECIMAL = 0.0;

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
extension MapQueryParameterExtension on Map<String, dynamic> {
  Map<String, dynamic> addParameterWithArray({
    required String parameterName,
    required List<dynamic> elements,
  }) {
    final currentParameters = this;
    Map<String, dynamic> newValues = {};

    elements.asMap().forEach((index, element) {
      newValues[parameterName[index]] = element;
    });

    currentParameters.addAll(newValues);
    return currentParameters;
  }
}
