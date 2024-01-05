import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:woniu_music/models/my_media.dart';
import 'package:woniu_music/utils/logger_utils.dart';

import '/global.dart';

String keyMyMedia = 'mymedia';

class AudioAdapter extends BaseAudioHandler {
// AudioPlayer player = AudioPlayer();
  Player player = Player();

  Future<void> init() async {
    initPlayer();
    win(() => initSmtc());
  }

  initPlayer() async {
    await player.setPlaylistMode(PlaylistMode.loop);
    player.stream.playing.listen((isPlaying) async {
      debug('playingStream:$isPlaying');
      playbackState.add(playbackState.value.copyWith(
        playing: isPlaying,
        updatePosition: playbackState.value.position,
      ));
      if (isPlaying) {
        var mi = currentMediaItem;
        if (mi != null) {
          mediaItem.add(mi);
        }
      }
      await win(() async {
        await smtc.setPlaybackStatus(
          isPlaying ? PlaybackStatus.Playing : PlaybackStatus.Paused,
        );
        if (isPlaying) {
          await updateSmtcMeta();
        }
      });
    });
    player.stream.position.listen((position) {
      // 触发频率较高
      // debug('position:$position');
    });
    player.stream.log.listen((log) {
      debug(log);
    });
    player.stream.playlist.listen((event) async {
      debug('playlist:$event');
      var mi = currentMediaItem;
      if (mi != null) {
        mediaItem.add(mi);
      }
      await win(() => updateSmtcMeta());
    });
  }

  late SMTCWindows smtc;

  initSmtc() {
    smtc = SMTCWindows(
      config: const SMTCConfig(
        playEnabled: true,
        pauseEnabled: true,
        stopEnabled: true,
        nextEnabled: true,
        prevEnabled: true,
        fastForwardEnabled: true,
        rewindEnabled: true,
      ),
    );
    smtc.buttonPressStream.listen((event) async {
      debug('buttonPressStream: $event');
      switch (event) {
        case PressedButton.play:
          await play();
          break;
        case PressedButton.pause:
          await pause();
          break;
        case PressedButton.stop:
          await stop();
          break;
        case PressedButton.previous:
          // await player.seekToPrevious();
          await skipToPrevious();
          break;
        case PressedButton.next:
          // await player.seekToNext();
          await skipToNext();
          break;
        default:
      }
    });
  }

  updateSmtcMeta() async {
    var mi = mediaItem.value;
    if (mi != null) {
      // 更新标题等信息
      await smtc.updateMetadata(MusicMetadata(
        title: mi.title,
        artist: mi.artist ?? '',
        album: mi.album ?? '',
        thumbnail: mi.artUri?.toString(),
      ));
    }
  }

  bool get playing => playbackState.value.playing;
  Media get currentMedia =>
      player.state.playlist.medias[player.state.playlist.index];
  MediaItem? get currentMediaItem =>
      currentMedia.extras?[keyMyMedia] as MediaItem?;

  @override
  Future<void> play() async {
    // playbackState.add(playbackState.value.copyWith(
    //   playing: true,
    //   updatePosition: playbackState.value.position,
    // ));
    await player.play();
  }

  @override
  Future<void> pause() async {
    // playbackState.add(playbackState.value.copyWith(
    //   playing: false,
    //   updatePosition: playbackState.value.position,
    // ));
    await player.pause();
  }

  @override
  Future<void> skipToNext() async {
    await player.next();
  }

  @override
  Future<void> skipToPrevious() async {
    await player.previous();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    await player.jump(index);
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    var list = <Media>[];
    for (var i = 0; i < queue.length; i++) {
      var media = queue[i];
      if (media is MyMedia) {
        var filepath = media.source;
        list.add(Media(filepath, extras: {keyMyMedia: media}));
      }
    }
    var playlist = Playlist(list);
    await player.open(playlist, play: false);
  }
}


// class Handle extends handle