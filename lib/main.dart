import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/app.dart';
import 'core/app_bloc_observer.dart';
import 'core/injector.dart';
import 'core/localization.dart';
import 'core/size_util.dart';
import 'domain/repository/auth_repository.dart';
import 'presentation/cubit/auth/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    log(error.toString(), stackTrace: stack);
    return true;
  };

  Bloc.observer = const AppBlocObserver();

  await Injector.initialise();

  runApp(
    Localization(
      child: SizerUtils(
        builder: (BuildContext context, Orientation orientation) =>
            MultiBlocProvider(providers: [
          BlocProvider<AuthCubit>(
              create: (BuildContext context) =>
                  AuthCubit(authRepository: Injector.resolve<AuthRepository>()))
        ], child: const App()),
      ),
    ),
  );
}
