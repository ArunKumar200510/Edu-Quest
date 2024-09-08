// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edu_quest/core/config/assets_constants.dart';
import 'package:edu_quest/core/extension/context.dart';
import 'package:edu_quest/core/navigation/route.dart';
import 'package:edu_quest/core/util/secure_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    // await Future.delayed(const Duration(seconds: 3), () async {
    //   final String? apiKey = await secureStorage.getApiKey();
    //   if (apiKey == null || apiKey.isEmpty) {
    //     AppRoute.welcome.go(context);
    //   } else {}
    //   AppRoute.welcome.go(context);
    // });
    await Future.delayed(const Duration(seconds: 3), () async {
      // final String? apiKey = await secureStorage.getApiKey();
      // if (apiKey == null || apiKey.isEmpty) {
      //   AppRoute.welcome.go(context);
      // } else {}
      AppRoute.welcome.go(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // image and text
          Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetConstants.eduquestlogo,
              width: 250.w,
              height: 250.h,
            ),
            SizedBox(height: 16.h),
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    context.colorScheme.primary,
                    context.colorScheme.secondary,
                  ],
                ).createShader(bounds);
              },
              child: Text(
                'Edu-Quest AI',
                style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
