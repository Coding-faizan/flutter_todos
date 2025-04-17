import 'package:flutter/material.dart';

import '../../../core/assets.dart';
import '../../../core/routes/extension.dart';
import '../../../core/routes/route_argument.dart';
import '../../../core/size_util.dart';
import '../../shared_widgets/assets_wigdet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2)); // Adjust delay as needed
    if (!mounted) {
      return;
    }

    context.goToScreen(arg: const HomeScreenRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AssetImageWidget(
                path: Assets.logo,
                width: 200.w,
                height: 200.w,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
