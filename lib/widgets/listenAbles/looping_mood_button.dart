import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/enums/looping_mod_enum.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class LoopingModButton extends StatefulWidget {
  const LoopingModButton({super.key});

  @override
  State<LoopingModButton> createState() => _LoopingModButtonState();
}

class _LoopingModButtonState extends State<LoopingModButton> {
  final modeIcons = {
    LoopMode.all: 'assets/icons/loop.png',
    LoopMode.off: 'assets/icons/shuffle.png',
    LoopMode.one: 'assets/icons/repeat-once.png',
  };
  static final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // _provider.loopIndex++;
          // if (_provider.loopIndex == 3) {
          //   _provider.loopIndex = 0;
          // }
          // _provider.loopMod.value =
          //     modeIcons.keys.toList()[_provider.loopIndex];
          // setState(() {});
        },
        child: Container(
          alignment: Alignment.center,
          child: ImageIcon(
            AssetImage(modeIcons.values.toList()[0]),
            size: 23.sp,
            color: Colors.white,
          ),
        ));
  }
}
