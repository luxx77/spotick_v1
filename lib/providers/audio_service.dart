import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:spoti_player_1_2/constants/pathes.dart';
import 'package:spoti_player_1_2/providers/main_provider.dart';

GetIt getIt = GetIt.instance;
Future initServices() async {
  getIt.registerSingleton<MyAudioHandler>(await initAudioService(),
      instanceName: 'handler');
}

Future<MyAudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidNotificationClickStartsActivity: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final player = AudioPlayer()..setLoopMode(LoopMode.all);
  final _playlist = ConcatenatingAudioSource(children: []);
  MainProvider? provider;
  void initProvider() {
    provider = getIt<MainProvider>(instanceName: providerName);
    _defPath = getIt<String>(instanceName: 'defImagePath');
  }

  MyAudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await player.setAudioSource(_playlist);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> clearQueue() async {
    queue.value.clear();
    await _playlist.clear();
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    player.playbackEventStream.listen((PlaybackEvent event) {
      // if (closed) {
      //   log('$closed');
      //   return;
      // }
      final playing = player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: AudioProcessingState.ready,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[player.loopMode]!,
        shuffleMode: (player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        speed: player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    player.durationStream.listen((duration) {
      var index = player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (player.shuffleModeEnabled) {
        index = player.shuffleIndices![index];
        //  player.shuffleIndices!
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (player.shuffleModeEnabled) {
        index = player.shuffleIndices![index];
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage Just Audio
    final audioSource = List.generate(
      mediaItems.length,
      (index) => _createAudioSource(
        mediaItems[index],
      ),
    );
    _playlist.addAll(audioSource);

    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // manage Just Audio
    final audioSource = _createAudioSource(mediaItem);
    _playlist.add(audioSource);

    // notify system
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['uri']),
      tag: mediaItem,
    );
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    log('removing');
    _playlist.removeAt(index);
    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> play() async {
    try {
      log('PlayITIT');
      player.play();
    } catch (e) {}
  }

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    log('${player.shuffleModeEnabled} isSHUFLINingi');
    if (player.shuffleModeEnabled) {
      index = player.shuffleIndices![index];
    }
    await player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() async {
    if (!player.hasNext) {
      await skipToQueueItem(0).then((value) => play);
      return;
    }
    player.seekToNext().then((value) => play());
  }

  @override
  Future<void> skipToPrevious() async {
    if (player.currentIndex == 0) {
      await skipToQueueItem(_playlist.length - 1).then((value) => play);
      return;
    }
    await player.seekToPrevious().then((value) => play());
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        player.setLoopMode(LoopMode.all);
        break;
    }
  }

  void some() {
    for (var i in queue.value) {
      if (player.sequence![player.currentIndex!].tag != i) {
        queue.value.removeAt(0);
      }
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      player.setShuffleModeEnabled(false);
    } else {
      await player.shuffle();
      player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await player.dispose();
      super.stop();
    }
  }

  @override
  Future updateQueue(List<MediaItem> mediaItems) async {
    final audioSource = List.generate(
        mediaItems.length, (index) => _createAudioSource(mediaItems[index]));
    _playlist.addAll(audioSource);
    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> stop() async {
    await player.dispose();
    await playbackState.close();

    super.stop();
    exit(0);
  }

  final shuffleOn = ValueNotifier(false);
  Future<void> shuffleClear() async {
    final theItem = fromSongModel(provider!.currentSong.value);
    queue.add([theItem]);
    log('${queue.value.length} queue length afterClear');
    log('${queue.value.first.title} queue First Title');
  }

  int findShuffledIndex(List<SongModel> songs) {
    int index = 0;
    for (var i in songs) {
      if (i.id == provider!.currentSong.value.id) {
        return index;
      }
      index++;
    }
    return 999999999;
  }

  // Future<void> addShuffledQueueItems() async {
  //   randomInts.remove(findShuffledIndex());
  //   List<MediaItem> items = [];
  //   for (int i = 0; i < provider!.currentPlayList.length - 1; i++) {
  //     final addItem = fromSongModel(provider!.currentPlayList[randomInts[i]]);
  //     items.add(addItem);
  //   }
  //   await addQueueItems(items);
  //   log('${queue.value.length}  queueLength afterAdd Second');
  // }

  void clearPlayList() {
    int removeIndex = 0;
    final theTag =
        _createAudioSource(fromSongModel(provider!.currentSong.value)).tag;
    while (_playlist.length != 1) {
      if (_playlist.sequence[removeIndex].tag == theTag) {
        log('_playList Changes Removeindex');
        removeIndex++;
      }
      _playlist.removeAt(removeIndex);
    }
    log('${player.sequence!.length}  _playList afterClear');
    log('${player.sequence!.first.tag.title}  _playListFirst title');
  }

  bool first = false;
  Future setLoop() async {
    log('Looop Settting');
    final List<SongModel> thePlayList =
        List.from(provider!.playLists[provider!.playListid]!);
    final place = findShuffledIndex(thePlayList);
    final List<SongModel> start = List.generate(place, (index) {
      return thePlayList[index];
    });
    final List<SongModel> end =
        List.generate(thePlayList.length - (place + 1), (index) {
      return thePlayList[thePlayList.length - (index + 1)];
    });
    queue.add(List.generate(
        thePlayList.length, (index) => fromSongModel(thePlayList[index])));
    _playlist.insertAll(
        0,
        List.generate(start.length, (index) {
          return _createAudioSource(fromSongModel(start[index]));
        }));
    _playlist.addAll(
        List.generate(
            end.length,
            (index) => _createAudioSource(
                fromSongModel(end[end.length - (index + 1)]))));
    provider!.currentPlayList = List.from([
      ...start,
      ...List.generate(end.length, (index) => end[end.length - (index + 1)])
    ]);
    provider!.currentPlayList.insert(start.length, provider!.currentSong.value);

    log('${findShuffledIndex(thePlayList)} insertIndex');
    log(queue.value.length.toString());
    log(provider!.currentPlayList.length.toString());
    log(_playlist.length.toString());

    log(queue.value.map((e) => e.title).toList().toString());
    log(provider!.currentPlayList.map((e) => e.title).toList().toString());
    log(_playlist.children
        .map((e) => e.sequence.map((e) => e.tag.title))
        .toList()
        .toString());
    log('${player.currentIndex} playerCurrentIndex');
    log('${provider!.currentIndex} providerCurrentIndex');
    shuffleOn.value = false;
  }

  void newLogs() async {
    log(_playlist.children
        .map((e) => e.sequence.map((e) => e.tag.title))
        .toList()
        .toString());
    log(player.sequence!.map((e) => e.tag.title).toList().toString());
    log('${player.currentIndex} playerCurrentIndex');
    log('${player.sequence!.length} length');

    log('${provider!.currentIndex} providerCurrentIndex');
    log('${player.sequence!.last.tag.title} lasyTitle');
    // await player.seek(Duration.zero, index: 9);
    // player.play();
  }

  Future<void> changeMode() async {
    shuffleClear();
    clearPlayList();
    if (shuffleOn.value) {
      await setLoop();
      return;
    }
    setShuffle();
  }

  Future<void> setShuffle() async {
    List<SongModel> songs = List.from(provider!.currentPlayList);
    songs.shuffle();
    songs.remove(provider!.currentSong.value);
    provider!.currentPlayList = List.from(songs);
    provider!.currentPlayList.insert(0, provider!.currentSong.value);
    // log('${songs.length} ${songs.first.title} songsService');
    // log('${provider!.currentPlayList}');
    shuffleOn.value = !shuffleOn.value;
    await addQueueItems(songs
        .map((e) => MediaItem(
              id: '${e.id}',
              title: e.title,
              duration: Duration(milliseconds: e.duration!),
              artUri: Uri.file(provider!.songArtworks[e.id] ?? _defPath!),
              displayTitle: e.title,
              displaySubtitle: e.artist,
              album: e.album,
              artist: e.artist != '<unknown>' ? e.artist : 'SubNull',
              extras: {'uri': e.data},
            ))
        .toList());
    shuffleOn.value = true;
    // addShuffledQueueItems();
    // final thisIndex = findShuffledIndex();
    // log('$thisIndex thisIndex');
    // for (int i = 0; i < player.sequence!.length; i++) {
    //   if (player.sequence![i].tag.id !=
    //       player.sequence![player.shuffleIndices![player.currentIndex!]]) {
    //     final thisSongIndex = player.shuffleIndices![i];
    //     if (thisSongIndex < player.shuffleIndices![player.currentIndex!]) {
    //       queue.value.add(player.sequence![i].tag);
    //     }
    //     if (thisSongIndex > player.shuffleIndices![player.currentIndex!]) {
    //       queue.value.insert(0, player.sequence![i].tag);
    //     }
    //   }
    // }
    // await player.setShuffleModeEnabled(true);
  }

  String? _defPath;
  MediaItem fromSongModel(SongModel e) {
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
  }
}
