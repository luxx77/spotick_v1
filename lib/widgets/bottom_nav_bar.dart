import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/constants/image_pathes.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:spoti_player_1_2/screens/current_song_screen.dart';
import 'package:spoti_player_1_2/widgets/bottom_bar_song.dart';
import '../configs/space.dart';
import '../constants/colors.dart';
import 'listenAbles/listen_able_slider.dart';
import 'nav_bars_dot.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});
  final List<double> margins = const [42.5, 124, 203, 286];
  static int _count = 0;
  static bool _go = false;
  static final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_count != 0) {
          _go = true;
        }
        _count++;
        if (_go) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CurrentSongScreen()));
          _count = 0;
          _go = false;
          return;
        }
        Future.delayed(const Duration(milliseconds: 250), () {
          _count = 0;
          _go = false;
        });
      },
      child: Container(
          padding:
              EdgeInsets.only(bottom: 5.h, top: 8.h, left: 32.w, right: 24.w),
          height: 125.h,
          width: 999.w,
          decoration: BoxDecoration(
            color: navBarColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              topRight: Radius.circular(18.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomBarProduct(),
              Space.verti(2),
              const ListenableSlider(true),
              const NavBarDot(),
              Expanded(
                child: Space.padSymmetrix(
                  25,
                  0,
                  ValueListenableBuilder(
                      valueListenable: _provider.bodyIndex,
                      builder: (context, bodyIndex, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int i = 0; i < 4; i++)
                              GestureDetector(
                                onTap: () {
                                  _provider.navDotMargin = margins[i];
                                  _provider.bodyIndex.value = i;
                                },
                                child: SizedBox(
                                  // alignment: Alignment.center,
                                  width: 40.w,
                                  // color: Colors.amber,
                                  child: ImageIcon(
                                      AssetImage(
                                        navBarIconPathes[i],
                                      ),
                                      color: _provider.bodyIndex.value == i
                                          ? selectedColor
                                          : Colors.white,
                                      size: i != 2 ? 28.sp : 30.sp),
                                ),
                              )
                          ],
                        );
                      }),
                ),
              )
            ],
          )),
    );
  }
}
