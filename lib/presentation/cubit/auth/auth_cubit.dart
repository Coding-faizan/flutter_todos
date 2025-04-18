import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(AuthState.initial());

  void logout() {
    _authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
