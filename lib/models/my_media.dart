
import 'package:audio_service/audio_service.dart';

class MyMedia extends MediaItem {
  final String source;

  MyMedia({
    required super.id,
    required super.title,
    required this.source,
    super.album,
    super.artist,
    super.genre,
    super.duration,
    super.artUri,
    super.artHeaders,
    super.playable = true,
    super.displayTitle,
    super.displaySubtitle,
    super.displayDescription,
    super.rating,
    super.extras,
  });
}