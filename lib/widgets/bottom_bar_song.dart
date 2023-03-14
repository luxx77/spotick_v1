import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:spoti_player_1_2/widgets/rich_title_text.dart';
import 'package:spoti_player_1_2/widgets/song_image_widget.dart';

import '../configs/space.dart';
import 'listenAbles/listen_able_play.dart';

class BottomBarProduct extends StatelessWidget {
  const BottomBarProduct({super.key});
  static final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: _provider.currentDur,
            builder: (context, duration, child) {
              return SongImageWidget(
                height: 45.sp,
                width: 45.sp,
                id: _provider.currentSong.value.id,
              );
            }),
        Space.hori(13),
        Expanded(
          
          child: ValueListenableBuilder(
              valueListenable: _provider.currentDur,
              builder: (context, duration, child) {
                return RichTitleText(
                  title: _provider.currentSong.value.title,
                  subTitle: _provider.currentSong.value.artist ?? '<unknown>',
                  size: 16,
                  id: 325987438589,
                );
              }),
        ),
        Space.hori(4),
        const ListenablePlayPause(forNavBar: true),
      ],
    );
  }
}
