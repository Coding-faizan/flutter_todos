import 'package:reactive_forms/reactive_forms.dart';

extension FormGroupExtension on FormGroup {
  /// Validate all controls and focus to the first invalid control
  bool get validateAndFocus {
    if (invalid) {
      markAllAsTouched();
      // focus to the first invalid control
      final firstInvalidControl = controls.entries.firstWhere(
        (element) => element.value.invalid,
        orElse: () => MapEntry('', FormControl()),
      );
      firstInvalidControl.value.focus();
      return false;
    }
    return true;
  }
}
