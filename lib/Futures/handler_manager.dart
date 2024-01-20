import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:spoti_player_1_2/Futures/futures.dart';

import 'package:spoti_player_1_2/providers/audio_service.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

class HandlerManager {
  MainProvider? provider;
  MyAudioHandler? handler;
  String? _defPath;
  Futures? _futures;
  LoopMode looping = LoopMode.all;
  bool isShuffled = false;
  void initHandlerMann() async {
    provider = getIt<MainProvider>(instanceName: 'provider');
    _defPath = getIt<String>(instanceName: 'defImagePath');
    _futures = getIt<Futures>(instanceName: 'futures');
    handler = getIt<MyAudioHandler>(instanceName: 'handler');
    addAllListeners();
    handler!.initProvider();
  }

  void addAllListeners() {
    log('ListenersAdded');
    listenPlaing();
  }

  Future<void> newLogs() async {
    handler!.changeMode();
    //   log(handler!.player.shuffleModeEnabled.toString());
    //   handler!.player.setShuffleModeEnabled(false);
  }

  void thisLogs() {}
  void setCurrentSong(SongModel song) {
    provider!.currentSong.value = song;
    provider!.currentDur.value = Duration(
      milliseconds: song.duration!,
    );
  }

  Future seek(Duration duration) async {
    handler!.seek(duration);
  }

  Future reSetQueue(List<SongModel> songs, int playListId) async {
    if (handler!.shuffleOn.value) {
      songs.shuffle();
    }
    await handler!.clearQueue();

    await setQueue(songs, playListId);
    provider!.playListid = playListId;
  }

  // Future<void> loggs() async {
  //   await handler!.setShuffleMode(AudioServiceShuffleMode.all);
  // }

  Future setQueue(List<SongModel> songs, int playListId) async {
    provider!.currentPlayList = songs;
    log('Re Setting');
    await handler!.addQueueItems(songs.map((e) {
      return MediaItem(
        id: '${e.id}',
        title: e.title,
        duration: Duration(milliseconds: e.duration!),
        artUri: Uri.file(provider!.songArtworks[e.id] ?? _defPath!),
        displayTitle: e.title,
        displaySubtitle: e.artist,
        album: e.album,
        artist: e.artist != '<unknown>' ? e.artist : 'SubNull',
        extras: {'uri': e.data},
      );
    }).toList());
  }

  Future playAtIndex(int index, int id) async {
    if (handler!.shuffleOn.value) {
      playAtShuffledIndex(id);
      return;
    }
    await handler!.skipToQueueItem(index);
    provider!.currentIndex = index;
    await handler!.play();
  }

  void playAtShuffledIndex(int id) async {
    int index = 0;
    for (var i in handler!.queue.value) {
      if (int.parse(i.id) == id) {
        break;
      }
      index++;
    }
    await handler!.skipToQueueItem(index);
    provider!.currentIndex = index;
    await handler!.play();
  }

  void listenPlaing() {
    handler!.player.shuffleModeEnabledStream.listen((event) {
      isShuffled = event;
    });
    handler!.player.loopModeStream.listen((event) {
      looping = event;
    });
    handler!.player.playingStream.listen((event) {
      log('$event isPLaying');
      provider!.isPlaying.value = event;
    });
    handler!.player.positionStream.listen((event) {
      provider!.currentPos.value = event;
    });
    handler!.player.durationStream.listen((event) {
      provider!.currentDur.value = event ?? Duration.zero;
    });
    handler!.player.currentIndexStream.listen((event) {
      log('$event NewIndex');
      provider!.lastSong.value = provider!.currentSong.value;
      provider!.currentIndex = event ?? 0;
      if (provider!.carouselController.ready && provider!.inCurrentSongScreen) {
        provider!.carouselController
            .animateToPage(event ?? 0, duration: const Duration(milliseconds: 200));
      }
      provider!.currentSong.value = provider!.currentPlayList[event ?? 0];
      log(provider!.currentSong.value.title);
    });
  }

  Future next() async {
    await handler!.skipToNext();
  }

  Future prev() async {
    await handler!.skipToPrevious();
  }

  Future play() async => await handler!.play();

  Future pause() async => await handler!.pause();
}
