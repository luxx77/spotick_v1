import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/constants/colors.dart';

import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/screens/main_scaffold.dart';

void main() async {
  initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final theme = ThemeData(
      textSelectionTheme: const TextSelectionThemeData(
    selectionHandleColor: Colors.transparent,
    cursorColor: Colors.amber,
    selectionColor: selectedColor,
  ));
  @override
  Widget build(BuildContext context) {
    log('mainBuild');
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: theme,
        theme: theme,
        home: const MainScaffold(),
      ),
    );
  }
}
