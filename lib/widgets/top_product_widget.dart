import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:spoti_player_1_2/Futures/handler_manager.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:spoti_player_1_2/widgets/rich_title_text.dart';
import 'package:spoti_player_1_2/widgets/song_image_widget.dart';

import '../screens/current_song_screen.dart';

class TopProductWidget extends StatelessWidget {
  const TopProductWidget({super.key, required this.index, required this.song});
  final int index;
  final SongModel song;
  static final _handManager =
      getIt<HandlerManager>(instanceName: 'handllerManner');
  static final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _handManager.newLogs();
      },
      onTap: () async {
        log('Taap');
        final currentSongId = _provider.currentSong.value.id;

        if (song.id == currentSongId) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CurrentSongScreen(),
              ));
          return;
        }
        if (_provider.playListid != 333) {
          log('REsetting SongWidget');
          await _handManager.reSetQueue(
            _provider.playLists[333]!,
            333,
          );
        }
        await _handManager.loggs();

        if (song.id != currentSongId) {
          _handManager.playAtIndex(index);
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 13.w, left: index != 0 ? 0 : 28.w),
        width: 140.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 155.h,
              width: 139.w,
              child: SongImageWidget(
                height: null,
                id: song.id,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 11.w,
                top: 10.h,
              ),
              child: ValueListenableBuilder(
                valueListenable: _provider.currentDur,
                builder: (context, value, child) => RichTitleText(
                  size: 16,
                  id: song.id,
                  subTitle: song.artist ?? '<unknown>',
                  title: song.title,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
