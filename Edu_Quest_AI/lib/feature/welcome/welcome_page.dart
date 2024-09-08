import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:edu_quest/core/config/assets_constants.dart';
import 'package:edu_quest/core/extension/context.dart';
import 'package:edu_quest/core/navigation/route.dart';
import 'package:edu_quest/feature/home/widgets/background_curves_painter.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 500.h,
                  width: 600.w,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                        Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: BackgroundCurvesPainter(),
                size: Size.infinite,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.25),
                              offset: const Offset(4, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Edu Quest AI',
                              style: TextStyle(
                                color: context.colorScheme.background,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Image.asset(
                              AssetConstants.aiStarLogo,
                              scale: 23.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Lottie.asset(
                      AssetConstants.onboardingAnimation,
                      height: 400.h,
                    ),
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
                        'Welcome ✨',
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        AppRoute.home.go(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.onSurface,
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: Text(
                        'Get Started',
                        style: context.textTheme.labelLarge!.copyWith(
                          color: context.colorScheme.surface,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
