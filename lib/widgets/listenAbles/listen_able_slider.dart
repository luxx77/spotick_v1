import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/Futures/handler_manager.dart';
import 'package:spoti_player_1_2/constants/colors.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class ListenableSlider extends StatefulWidget {
  const ListenableSlider(
    this.forNavBar, {
    super.key,
  });

  final bool forNavBar;

  @override
  State<ListenableSlider> createState() => _ListenableSliderState();
}

class _ListenableSliderState extends State<ListenableSlider> {
  Duration currentVal = Duration.zero;
  bool seeking = false;
  final _handManager = getIt<HandlerManager>(instanceName: 'handllerManner');
  final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _provider.currentPos,
        builder: (context, durr, _) {
          return ProgressBar(
            timeLabelTextStyle: TextStyle(
              fontFamily: 'spoti',
              fontSize: widget.forNavBar ? 9.sp : 13.sp,
              color: const Color.fromRGBO(135, 135, 135, 1),
            ),
            progress: seeking ? currentVal : durr,
            total: Duration(milliseconds: _provider.currentPlayList[_provider.currentIndex].duration!) ,
            progressBarColor: selectedColor,
            baseBarColor: Colors.white.withOpacity(0.24),
            bufferedBarColor: Colors.white.withOpacity(0.24),
            thumbColor: Colors.white,
            barHeight: 5.h,
            thumbRadius: 7.r,
            thumbGlowRadius: 10,
            onDragStart: (value) {
              log('${value.timeStamp} start');
              setState(() {
                currentVal = value.timeStamp;
                seeking = true;
              });
            },
            onDragEnd: () {
              setState(() {
                seeking = false;
                _provider.currentPos.value = currentVal;
                _handManager.seek(currentVal);
              });
              log('end');
            },
            onDragUpdate: (newVal) {
              setState(() {
                currentVal = newVal.timeStamp;
              });
            },
          );
        });
  }
}
