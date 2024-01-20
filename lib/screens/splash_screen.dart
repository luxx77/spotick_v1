import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/constants/colors.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  List<String> titles = [
    'The Weeknd the Best! ⭐',
    'ScallyMilano oneLove! 🗽',
    'Dont be Dead Insides 🤡',
    'Dont Worry, be Happy 💩',
    'Nice emoji🗿, isnt?',
    'Mind is our manner 💫',
  ];
  final random = Random();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final index = random.nextInt(titles.length);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: FittedBox(
              child: Text(
                titles[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'spoti',
                  color: Colors.white,
                  fontSize: 666.w,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            child: SizedBox(
              height: height * 0.5,
              child: Image.asset(
                'assets/images/top_girl.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: SizedBox(
              height: 28.sp,
              width: 28.sp,
              child: const CircularProgressIndicator(
                color: selectedColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
