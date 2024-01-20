import 'dart:developer';
import 'dart:io';

import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoti_player_1_2/Futures/handler_manager.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class Futures {
  Futures() {
    // sihgudsgdijfing
  }
  SharedPreferences? prefs;

  MainProvider? provider;
  final _audioQuery = OnAudioQuery();
  final tagger = Audiotagger();
  final _handlerManager = HandlerManager();
  String? directoryPath;
  Future<void> initAll() async {
    provider = getIt<MainProvider>(instanceName: 'provider');

    await getDirectoryPath();
    await setDefImage();
    await getSongs();

    provider!.setPlayList(666, provider!.allSongs!);
    provider!.setPlayList(
        333, List.generate(10, (index) => provider!.allSongs![index]));
    provider!.setPlayList(555, await getFavors());
    await loadAllArtWork();

    getIt.registerSingleton<HandlerManager>(_handlerManager..initHandlerMann(),
        instanceName: 'handllerManner');
    _handlerManager.setCurrentSong(provider!.allSongs!.first);
    await _handlerManager
        .setQueue(provider!.allSongs!, 666)
        .then((value) => log('INITSetting'));
  }

  Future<void> getDirectoryPath() async {
    directoryPath = await getTemporaryDirectory().then((value) => value.path);
    getIt.registerSingleton(directoryPath!, instanceName: 'cachePath');
  }

  Future<void> getSongs() async {
    await _audioQuery.permissionsRequest();
    log('${DateTime.now().toString()} permission');
    final songs = await _audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      ignoreCase: false,
      uriType: UriType.EXTERNAL,
    );
    for (int i = 0; i < songs.length; i++) {
      await File(songs[i].data).stat().then(
        (value) {
          if (value.accessed.toString()[value.accessed.toString().length - 1] ==
                  'Z' ||
              songs[i].duration! < 9999) {
            // log('${songs[i].duration} ${songs[i].title} removed');
            songs.remove(songs[i]);
            i--;
          }
        },
      );
    }
    log('${songs.length}');
    provider!.allSongs = songs;
  }

  Future<String> loadArtWork(int id, String path) async {
    final imggg = provider!.songArtworks[id];
    if (imggg != null) {
      return imggg;
    }
    final file = File('$directoryPath/$id.png');
    if (await file.exists()) {
      if (file.statSync().size != 0) {
        return file.path;
      }
      return '$directoryPath/defImg.jpg';
    }
    final img = await tagger.readArtwork(path: path);
    if (img != null) {
      file.writeAsBytesSync(img);
      return file.path;
    }
    return '$directoryPath/defImg.jpg';
  }

  Future<void> loadAllArtWork() async {
    for (var i in provider!.allSongs!) {
      final artWorkPath = await loadArtWork(i.id, i.data);
      provider!.songArtworks[i.id] = artWorkPath;
    }
  }

  Future<void> setDefImage() async {
    final file = File('$directoryPath/defImg.jpg');
    if (!await file.exists()) {
      await file.create();
      final img = await rootBundle.load('assets/images/top_girl.jpg');
      await file.writeAsBytes(
        img.buffer.asUint8List(
          img.offsetInBytes,
          img.lengthInBytes,
        ),
      );
      log('${file.path} defPath');
    }
    getIt.registerSingleton<String>(file.path, instanceName: 'defImagePath');
  }

  Future<List<SongModel>> getFavors() async {
    prefs = await SharedPreferences.getInstance();
    final favors = prefs!.getString('favors');
    if (favors == null) {
      return [];
    }
    final favorIds = favors.split(',');
    List<SongModel> list = List.empty();
    final ides = provider!.allSongs!.map((e) => e.id).toList();
    for (var i in favorIds) {
      final theIndex = ides.indexOf(int.parse(i));
      list.add(provider!.allSongs![theIndex]);
    }
    return [];
  }

  Future<void> addOrRemoveFavors() async {
    final song = provider!.currentSong.value;
    bool exists = false;
    final favorSongs = provider!.playLists[555];
    final favorIds = favorSongs!.map((e) => e.id).toList();
    int index = 0;
    for (var i in favorIds) {
      if (i == song.id) {
        exists = true;
        break;
      }
      index++;
    }

    if (exists) {
      favorSongs.removeAt(index);
      if (provider!.playListid == 555) {}
    } else {
      favorSongs.add(song);
    }
    final data = favorSongs.map((e) => e.id).toList().join(',');

    await prefs!.setString('favors', data);
    provider!.favorChanges.value = !provider!.favorChanges.value;
  }

  bool existInFavor() {
    final id = provider!.currentSong.value.id;
    final favorIds = provider!.playLists[555]!.map((e) => e.id).toList();
    for (var i in favorIds) {
      if (i == id) {
        return true;
      }
    }
    return false;
  }
}
