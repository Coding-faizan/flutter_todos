import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/assets.dart';
import '../../../core/routes/extension.dart';
import '../../../core/routes/route_argument.dart';
import '../../../core/size_util.dart';
import '../../cubit/auth/login/login_cubit.dart';
import '../../extensions/build_context_extension.dart';
import '../../shared_widgets/assets_wigdet.dart';
import '../../shared_widgets/localized_text.dart';
import '../../shared_widgets/primary_button_widget.dart';
import '../../shared_widgets/text_form_field_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (BuildContext context, LoginState state) {
        switch (state) {
          case LoginSuccess():
            context.goToScreen(arg: const HomeScreenRoute());

          case LoginFailure(error: final error):
            context.showSnackBar(error);
          case LoginInitial() || LoginLoading():
            break;
        }
      },
      builder: (BuildContext context, LoginState state) {
        return Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 24.w,
            ),
            child: LoginForm(state: state),
          )),
        );
      },
    );
  }
}

class LoginForm extends StatelessWidget {
  final LoginState state;

  const LoginForm({
    super.key,
    required this.state,
  });

  void onLoginPressed(BuildContext context) {
    context.read<LoginCubit>().login();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ReactiveForm(
      formGroup: state.form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          // Logo
          Center(
            child: AssetImageWidget(
              path: Assets.logo,
              width: 250.w,
              height: 250.h,
            ),
          ),
          SizedBox(height: 32.h),
          // Title
          LocalizedText(
            'login.title',
            style: theme.textTheme.headlineLarge,
          ),
          SizedBox(height: 8.h),
          // Subtitle
          LocalizedText(
            'login.subtitle',
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 32.h),
          // Phone input
          TextFormFieldWidget.email(),
          SizedBox(height: 32.h),

          TextFormFieldWidget.password(),
          // Login button
          SizedBox(height: 32.h),

          PrimaryButtonWidget(
            text: 'login',
            loading: state is LoginLoading,
            onPressed: () => onLoginPressed(context),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
