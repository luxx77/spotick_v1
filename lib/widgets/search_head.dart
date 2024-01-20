import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:spoti_player_1_2/widgets/build/songs_builder.dart';

import '../constants/colors.dart';

class SearchHead extends StatelessWidget {
  const SearchHead({super.key});
  static final List<String> history = [
    'weeknd',
    'чертыре',
    'lil',
    'scally',
    'limobo',
    'ur mom top',
  ];
  static final _builders = SongBuilders();
  static final _provider = getIt<MainProvider>(instanceName: providerName);
  @override
  Widget build(BuildContext context) {
    log('Search HEAD Build');
    return Container(
      margin: EdgeInsets.only(
        top: 10.h,
        bottom: 5.h,
      ),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 27.w, right: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'History',
                  style: TextStyle(
                    fontSize: 27.sp,
                    fontFamily: 'spoti',
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    log(_provider.currentSong.value.title);
                  },
                  child: Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50.h,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: history.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: 50,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: index != 0 ? 0 : 27.w,
                    right: 9.w,
                    top: 12.h,
                    bottom: 12.h,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: selectedColor, width: 1.7.sp),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    history[index],
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'spoti',
                      fontSize: 15.sp,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

