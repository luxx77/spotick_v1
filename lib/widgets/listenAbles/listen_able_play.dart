import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/Futures/handler_manager.dart';
import 'package:spoti_player_1_2/constants/colors.dart';
import 'package:spoti_player_1_2/constants/image_pathes.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class ListenablePlayPause extends StatelessWidget {
  const ListenablePlayPause({
    super.key,
    this.forNavBar,
  });
  final bool? forNavBar;

  static final _handManager =
      getIt<HandlerManager>(instanceName: 'handllerManner');
  static final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _provider.isPlaying,
        builder: (context, playing, child) {
          log('reBuild');
          return ClipRRect(
            borderRadius: BorderRadius.circular(666.r),
            child: Material(
              color: selectedColor,
              child: InkWell(
                splashColor: MaterialStateColor.resolveWith(
                    (states) => Color.fromRGBO(255, 255, 255, 0.4)),
                onTap: () {
                  log('playTap');
                  if (_provider.isPlaying.value) {
                    _handManager.pause();
                    return;
                  }
                  _handManager.play();
                },
                child: Container(
                  height: forNavBar != true ? 77.sp : 43.sp,
                  width: forNavBar != true ? 77.sp : 43.sp,
                  alignment: Alignment.center,
                  child: ImageIcon(
                    AssetImage(
                      playing ? pausePAth : playPath,
                    ),
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
