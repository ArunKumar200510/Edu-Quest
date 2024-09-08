import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:edu_quest/core/app/style.dart';
import 'package:edu_quest/core/navigation/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp.router(
        title: 'Edu-Quest AI',
        theme: darkTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        builder: (context, child) {
          return child!;
        },
      ),
    );
  }
}
