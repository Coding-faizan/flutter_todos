import 'package:reactive_forms/reactive_forms.dart';

class FormControlModel {
  final FormControl<String> control;
  final Map<String, String Function(Object)>? validationMessages;

  FormControlModel({required this.control, this.validationMessages});

  factory FormControlModel.title({String? value}) => FormControlModel(
        control: FormControl<String>(
          validators: [Validators.required, Validators.minLength(3)],
          value: value,
        ),
        validationMessages: {
          ValidationMessage.required: (_) => 'Title required',
          ValidationMessage.minLength: (_) =>
              'Title should be at least 3 characters',
        },
      );

  factory FormControlModel.description({String? value}) => FormControlModel(
        control: FormControl<String>(
          validators: [Validators.required, Validators.minLength(3)],
          value: value,
        ),
        validationMessages: {
          ValidationMessage.required: (_) => 'Description required',
          ValidationMessage.minLength: (_) =>
              'Description should be at least 3 characters',
        },
      );
  factory FormControlModel.email({String? value}) => FormControlModel(
        control: FormControl<String>(
          validators: [Validators.required, Validators.email],
          value: value,
        ),
        validationMessages: {
          ValidationMessage.required: (_) => 'Email required',
          ValidationMessage.email: (_) => 'Invalid Email',
        },
      );

  factory FormControlModel.password({String? value}) => FormControlModel(
        control: FormControl<String>(
          validators: [Validators.required],
          value: value,
        ),
        validationMessages: {
          ValidationMessage.required: (_) => 'Password required',
        },
      );
}
