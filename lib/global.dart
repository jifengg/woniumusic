import 'dart:io';

import 'package:flutter/foundation.dart';

import 'packages/audio_adapter.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:smtc_windows/smtc_windows.dart';

late AudioAdapter adapter;

T? win<T>(T Function() fun, {T? noWinValue}) {
  if (!kIsWeb && Platform.isWindows) {
    return fun.call();
  } else {
    return noWinValue;
  }
}
