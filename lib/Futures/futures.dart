import 'dart:developer';
import 'dart:io';

import 'package:audiotagger/audiotagger.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spoti_player_1_2/Futures/handler_manager.dart';
import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class Futures {
  Futures() {
    // sihgudsgdijfing 
  }

  MainProvider? provider;
  final _audioQuery = OnAudioQuery();
  final tagger = Audiotagger();
  final _handlerManager = HandlerManager();
  String? directoryPath;
  Future<void> initAll() async {
    provider = getIt<MainProvider>(instanceName: 'provider');
    await getDirectoryPath();
    setDefImage();
    await getSongs();

    provider!.setPlayList(666, provider!.allSongs!);
    provider!.setPlayList(
        333, List.generate(10, (index) => provider!.allSongs![index]));
    provider!.setPlayList(
        555, List.generate(30, (index) => provider!.allSongs![index]));
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
    // if (!await file.exists()) {
    await file.create();
    final img = await rootBundle.load('assets/images/top_girl.jpg');
    file.writeAsBytesSync(
      img.buffer.asUint8List(
        img.offsetInBytes,
        img.lengthInBytes,
      ),
    );
    getIt.registerSingleton<String>(file.path, instanceName: 'defImagePath');
    log('${file.path} defPath');
    // }
  }
}
