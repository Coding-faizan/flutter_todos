part of 'login_cubit.dart';

sealed class LoginState {
  final FormGroup form;

  const LoginState({required this.form});

  factory LoginState.initial() {
    return LoginInitial(
        form: FormGroup({
      FormControlName.email.name: FormControlModel.email().control,
      FormControlName.password.name: FormControlModel.password().control
    }));
  }
}

class LoginInitial extends LoginState {
  const LoginInitial({required super.form});
}

class LoginSuccess extends LoginState {
  const LoginSuccess({required super.form});
}

class LoginLoading extends LoginState {
  const LoginLoading({required super.form});
}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure({required super.form, required this.error});
}
