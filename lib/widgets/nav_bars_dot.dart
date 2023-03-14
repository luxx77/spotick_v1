import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

import '../constants/colors.dart';

class NavBarDot extends StatelessWidget {
  const NavBarDot({super.key});

  static final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _provider.bodyIndex,
      builder: (context, bodyIndex, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(left: _provider.navDotMargin.w),
          decoration: BoxDecoration(
            color: selectedColor,
            borderRadius: BorderRadius.circular(99.r),
          ),
          height: 5.sp,
          width: 5.sp,
        );
      },
    );
  }
}
