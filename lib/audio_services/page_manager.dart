import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:podcato/models/response_episode_model.dart';

import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';
import 'services/playlist_repository.dart';
import 'services/service_locator.dart';

class PageManager {
  // Listeners: Updates going to the UI
  final currentSongNotifier =
      ValueNotifier<MediaItem>(const MediaItem(id: "", title: ""));
  final currentSongIndex = ValueNotifier<int>(-1);
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  final _audioHandler = getIt<AudioHandler>();
  List<Items> bunchOfListItems = [];


  // Events: Calls coming from the UI
  void init(List<Items> episodes, int index, String id) async {
    print("angga : $index");
    print("angga : $id");
    await loadPlaylist(episodes, index, id);
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
  }

  Future<void> loadPlaylist(List<Items> episodes, int index, String id) async {
    print(index);
    Items tempEpisodes = episodes[index];
    bunchOfListItems = episodes;

    currentSongIndex.value = index;
    print(tempEpisodes.title);

    final currentMediaItem = MediaItem(
      id: tempEpisodes.enclosureUrl ?? id,
      album: tempEpisodes.title ?? '',
      title: tempEpisodes.title ?? '',
      extras: {
        'url': tempEpisodes.enclosureUrl,
        'image': tempEpisodes.feedImage,
        'index': index,
        'uuid': id
      },
    );

    currentSongNotifier.value = currentMediaItem;

    await _audioHandler.addQueueItems([currentMediaItem]);
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (processingState == AudioProcessingState.completed) {
        print("CIMPLEYEEEE");
        print(currentSongIndex.value);
        print(currentSongNotifier.value.extras!['uuid']);
        print(currentSongNotifier.value.extras!['index']);
        print(currentSongNotifier.value.title);

        // next(currentSongIndex.value, currentSongNotifier.value.extras!['uuid']);
        next();
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  Future<void> previous() async {
    _audioHandler.pause();
    _audioHandler.skipToPrevious();
  }

  Future<void> next() async {
    _audioHandler.pause();
    _audioHandler.skipToNext();
  }

  // Future<void> next(int index, String id) async {
  //   _audioHandler.pause();
  //   if (index > 0) {

  //   await loadPlaylist(bunchOfListItems, index - 1, id);
  //   currentSongIndex.value = index - 1;
  //   }
  // }

  // Future<void> previous(int index, String id) async {
  //   _audioHandler.pause();
  //   if (index < bunchOfListItems.length - 1) {

  //   await loadPlaylist(bunchOfListItems, index + 1, id);
  //   currentSongIndex.value = index + 1;
  //   }
  // }

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  Future<void> add() async {
    final songRepository = getIt<PlaylistRepository>();
    final song = await songRepository.fetchAnotherSong();
    final mediaItem = MediaItem(
      id: song['id'] ?? '',
      album: song['album'] ?? '',
      title: song['title'] ?? '',
      extras: {'url': song['url']},
    );
    _audioHandler.addQueueItem(mediaItem);
  }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
  }

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  Future<void> stop() async {
    await _audioHandler.stop();
  }
}
