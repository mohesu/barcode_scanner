import 'package:flutter/foundation.dart';

/// Enum String validate types
enum ValidateType {
  startsWith,
  endsWith,
  contains,
}

/// Extension validate type
extension ValidateTypeIndex on ValidateType {
  bool toValidateTypeBool(String scanValue, String validateValue) {
    switch (this) {
      case ValidateType.startsWith:
        return scanValue.startsWith(validateValue);
      case ValidateType.endsWith:
        return scanValue.endsWith(validateValue);
      case ValidateType.contains:
        return scanValue.contains(validateValue);
      default:
        throw RangeError("enum ValidateType contains no value '$name'");
    }
  }
}

/// Extension validate type string to enum
extension ValidateTypeExtension on String {
  ValidateType toValidateTypeEnum() =>
      ValidateType.values.firstWhere((d) => describeEnum(d) == toLowerCase());
}
