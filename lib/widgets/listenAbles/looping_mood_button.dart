
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spoti_player_1_2/Futures/handler_manager.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class LoopingModButton extends StatefulWidget {
  const LoopingModButton({
    super.key,
  });
  @override
  State<LoopingModButton> createState() => _LoopingModButtonState();
}

class _LoopingModButtonState extends State<LoopingModButton> {
  final modeIcons = {
    LoopMode.all: 'assets/icons/loop.png',
    LoopMode.off: 'assets/icons/shuffle.png',
    LoopMode.one: 'assets/icons/repeat-once.png',
  };
  final _provider = getIt<MainProvider>(instanceName: providerName);
  final handler = getIt<HandlerManager>(instanceName: 'handllerManner');
  int findIndex(int songId) {
    int index = 0;
    for (var i in _provider.currentPlayList) {
      if (i.id == songId) {
        return index;
      }
      index++;
    }

    return 6666;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          return;
          // _provider.loopIndex++;
          // if (_provider.loopIndex == 3) {
          //   _provider.loopIndex = 0;
          // }
          // _provider.loopMod.value =
          //     modeIcons.keys.toList()[_provider.loopIndex];
          await handler.newLogs();
          setState(() {});

          // // final theSongId = _provider.currentSong.value.id;
          // // final position = _provider.currentPos.value;
          // // await handler.reSetQueue(
          // //     _provider.playLists[_provider.playListid!]!..shuffle(),
          // //     _provider.playListid!);

          // // handler.playAtIndex(findIndex(theSongId));
          // // handler.seek(position);
        },
        child: Container(
          alignment: Alignment.center,
          child: ImageIcon(
            AssetImage(modeIcons.values
                .toList()[handler.handler!.shuffleOn.value ? 1 : 0]),
            size: 23.sp,
            color: Colors.white,
          ),
        ));
  }
}
