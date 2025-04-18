import 'package:bloc/bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../domain/models/enums.dart';
import '../../../domain/models/form_control_model.dart';
import '../../../domain/repository/auth_repository.dart';
import '../../extensions/form_group_extension.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginState.initial());

  Future<void> login() async {
    if (!state.form.validateAndFocus) {
      return;
    }

    emit(LoginLoading(form: state.form));

    try {
      final bool result = await _authRepository.login(
          state.form.value['email'].toString(),
          state.form.value['email'].toString());
      if (result) {
        LoginSuccess(form: state.form);
      } else {
        throw Exception('Invalid Credentials');
      }
    } catch (e) {
      emit(LoginFailure(form: state.form, error: e.toString()));
    }
  }
}
