import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:spoti_player_1_2/enums/looping_mod_enum.dart';

class MainProvider {
  final carouselController = CarouselController();
  bool inCurrentSongScreen = false;
  final searchQuery = ValueNotifier<String>('');
  List<SongModel>? allSongs;
  final searchFocus = FocusNode();

  double navDotMargin = 42.5;
  final loopMod = ValueNotifier(LoopMode.all);
  int currentIndex = 0;
  List<SongModel> currentPlayList = [];

  Map<int, String> songArtworks = {};
  Map<int, List<SongModel>> playLists = {};
  int? playListid;
  final currentSong = ValueNotifier<SongModel>(SongModel({'id': 9999999}));
  final lastSong = ValueNotifier<SongModel>(SongModel({'id': 9999999}));
  final lastSongId = ValueNotifier(0);
  final bodyIndex = ValueNotifier<int>(0);

  int loopIndex = 0;
  void setPlayList(int id, List<SongModel> playList) {
    playLists[id] = playList;
  }

  void maxJump(
    ScrollController controller,
  ) {
    bool added = false;
    controller.addListener(() {
      if (added) {
        return;
      }
      added = true;
      controller.position.addListener(() {
        final maxOffset = controller.position.maxScrollExtent;

        if (controller.offset < -300.h) {
          controller.jumpTo(-300.h);
        }
        if (controller.offset > maxOffset + 300.h) {
          controller.jumpTo(maxOffset - 1.h);
        }
      });
    });
  }

  final currentPos = ValueNotifier<Duration>(Duration.zero);
  final isPlaying = ValueNotifier<bool>(false);
  final currentDur = ValueNotifier<Duration>(Duration(seconds: 99));
}
