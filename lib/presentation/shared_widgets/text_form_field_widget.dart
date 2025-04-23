import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../core/size_util.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/form_control_model.dart';
import 'localized_text.dart';

class TextFormFieldWidget<T> extends StatelessWidget {
  final LocalizedString label;
  final LocalizedString? hint;
  final FormControlName controlName;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;
  final bool readOnly;
  final int? maxLines;
  const TextFormFieldWidget({
    super.key,
    required this.label,
    this.hint,
    required this.controlName,
    this.keyboardType,
    this.obscureText = false,
    this.inputFormatters,
    this.validationMessages,
    this.decoration,
    this.readOnly = false,
    this.maxLines = 1,
  });

  factory TextFormFieldWidget.title() => TextFormFieldWidget<T>(
        controlName: FormControlName.title,
        label: 'title',
        hint: 'title',
        validationMessages: FormControlModel.title().validationMessages,
      );

  factory TextFormFieldWidget.description() => TextFormFieldWidget<T>(
        controlName: FormControlName.description,
        label: 'description',
        hint: 'description',
        validationMessages: FormControlModel.description().validationMessages,
      );
  factory TextFormFieldWidget.email() => TextFormFieldWidget<T>(
        controlName: FormControlName.email,
        label: 'email',
        hint: 'email',
        validationMessages: FormControlModel.email().validationMessages,
      );

  factory TextFormFieldWidget.password() => TextFormFieldWidget<T>(
        controlName: FormControlName.password,
        label: 'password',
        hint: 'password',
        obscureText: true,
        validationMessages: FormControlModel.password().validationMessages,
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocalizedText(
          label,
          style: theme.textTheme.labelMedium,
        ),
        SizedBox(height: 8.h),
        ReactiveTextField<T>(
          formControlName: controlName.name,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validationMessages: validationMessages,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          decoration: decoration ??
              InputDecoration(
                hintText: hint?.tr(),
              ),
          maxLines: maxLines,
        ),
      ],
    );
  }
}
