import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

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

  // bool played = false;
  // Stream<bool> playingStream() {
  //   return player.playingStream;
  // }

  // Stream<Duration> positionStream() {
  //   return player.positionStream;
  // }

  // Stream<Duration?> duraStream() {
  //   return player.durationStream;
  // }
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
}
