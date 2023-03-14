import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';
import 'package:spoti_player_1_2/widgets/search_title.dart';
import 'package:spoti_player_1_2/widgets/song_widget.dart';

class SongBuilders {
  final _provider = getIt<MainProvider>(instanceName: providerName);
  static List<SongModel> matchSong = [];
  List<Widget> songsBuilder(playListId) {
    final songs = _provider.playLists[playListId];
    return List.generate(songs!.length, (index) {
      return SongWidget(
        index: index,
        song: songs[index],
        playListId: playListId,
      );
    });
  }

  List<Widget> searchSongBuilder() {
    matchSong = searchTitleSongs();
    _provider.setPlayList(900, matchSong);

    return List.generate(matchSong.length, (index) {
      final song = matchSong[index];
      return SongWidget(
        index: index,
        song: song,
        playListId: 900,
        searchTitle: SearchTTitle(
            id: song.id,
            subTitle: song.artist,
            title: colorContain(song.title)),
      );
    });
  }

  int founContainIndex(String title) {
    final query = _provider.searchQuery.value;
    if (query.isEmpty) {
      return 0;
    }
    for (int i = 0; i < title.length; i++) {
      bool notSame = true;
      if (query[0].toLowerCase() == title[i].toLowerCase()) {
        for (int a = 0; a < query.length; a++) {
          if (title[i + a].toLowerCase() != query[a].toLowerCase()) {
            notSame = false;
          }
          if (a == query.length - 1 && notSame) {
            return i;
          }
        }
      }
    }
    return 666;
  }

  List<SongModel> searchTitleSongs() {
    if (_provider.searchQuery.value == '') {
      return _provider.allSongs!;
    }
    List<SongModel> matchSongs = [];
    for (var i in _provider.allSongs!) {
      if (i.title
          .toLowerCase()
          .contains(_provider.searchQuery.value.toLowerCase())) {
        matchSongs.add(i);
      }
    }
    return matchSongs;
  }

  List<String> colorContain(String list) {
    final containedIndex = founContainIndex(list);
    final query = _provider.searchQuery.value;
    if (query.isEmpty) {
      return [list, '', ''];
    }
    String fritText = '';
    String secondText = '';
    String containText = '';
    bool stop = false;
    if (query.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        if (i < containedIndex) {
          fritText = fritText + list[i];
        }
        if (i >= containedIndex && !stop) {
          if (i == containedIndex + query.length - 1) {
            stop = true;
          }
          containText = containText + list[i];
        }
        if (stop && i > containedIndex + query.length - 1) {
          secondText = secondText + list[i];
        }
      }
    }
    return [fritText, containText, secondText];
  }
}
