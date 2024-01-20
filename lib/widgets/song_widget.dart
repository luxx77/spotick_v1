import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:spoti_player_1_2/Futures/handler_manager.dart';
import 'package:spoti_player_1_2/configs/space.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spoti_player_1_2/screens/current_song_screen.dart';
import 'package:spoti_player_1_2/widgets/build/songs_builder.dart';
import 'package:spoti_player_1_2/widgets/rich_title_text.dart';
import 'package:spoti_player_1_2/widgets/song_image_widget.dart';
import 'package:spoti_player_1_2/widgets/song_options_widget.dart';

class SongWidget extends StatelessWidget {
  const SongWidget({
    super.key,
    required this.song,
    required this.playListId,
    required this.index,
    this.searchTitle,
  });
  final SongModel song;
  final int playListId;
  final int? index;
  final Widget? searchTitle;

  String getDurText(int durr) {
    final duration = Duration(milliseconds: durr);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds;
    if (seconds % 60 < 10) {
      return '$minutes:0${seconds % 60}';
    }
    return '$minutes:${seconds % 60}';
  }

  static final _handler = getIt<HandlerManager>(instanceName: 'handllerManner');
  static final _provider = getIt<MainProvider>(instanceName: providerName);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () async {
        _handler.handler!.newLogs();
      },
      onTap: () async {
        final currentSongId = _provider.currentSong.value.id;
        final songId = song.id;
        try {
          if (songId == currentSongId) {
            if (searchTitle != null) {
              _provider.searchFocus.unfocus();
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CurrentSongScreen(),
                ));

            return;
          }
          if (searchTitle != null &&
              _provider.currentPlayList != SongBuilders.matchSong) {
            log('Match Resetting');
            await _handler.reSetQueue(
                _provider.playLists[playListId]!, playListId);
            _handler.playAtIndex(index!, song.id);

            _provider.currentIndex = index!;
            _provider.currentSong.value = song;
            return;
          }
          if (_provider.playListid != playListId) {
            log('REsetting SongWidget');
            await _handler.reSetQueue(
              _provider.playLists[playListId]!,
              playListId,
            );
          }

          if (songId != currentSongId) {
            _handler.playAtIndex(index!, song.id);
            _provider.currentSong.value = song;
          }
        } catch (e) {
          log(e.toString());
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 23.w, right: 13.w),
        margin: EdgeInsets.symmetric(vertical: 6.h),
        height: 60.h,
        child: Row(
          children: [
            SongImageWidget(
              width: 58.h,
              height: 59.9.h,
              id: song.id,
            ),
            Space.hori(15),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchTitle ??
                        ValueListenableBuilder(
                          valueListenable: _provider.currentDur,
                          builder: (context, value, child) => RichTitleText(
                            id: song.id,
                            size: 15,
                            subTitle: song.artist ?? '<unknown>',
                            title: song.title,
                          ),
                        )
                  ]),
            ),
            Space.hori(2),
            Text(
              getDurText(song.duration!),
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
            const SongOptionsWidget(
              index: 0,
            )
          ],
        ),
      ),
    );
  }
}
