import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/constants/colors.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Here is nothig yet :)',
        style: TextStyle(
            color: selectedColor, fontFamily: 'spoti', fontSize: 30.sp),
      ),
    );
  }
}
