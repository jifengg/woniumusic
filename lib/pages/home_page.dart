import 'dart:io';

import 'package:audiotags/audiotags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'package:woniu_music/global.dart';
import 'package:path/path.dart';

import 'package:woniu_music/models/my_media.dart';
import 'package:woniu_music/utils/logger_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () async {
              // // var path = r'C:\Users\xuxiaodong\Music\真的爱你.mp3';
              // var paths = [
              //   r'C:\Users\xuxiaodong\Music\真的爱你.mp3',
              //   r'C:\Users\xuxiaodong\Music\test.mp3',
              //   r'C:\Users\xuxiaodong\Music\mp3\Joanie Madden - Lotus Jones.mp3',
              //   r'C:\Users\xuxiaodong\Music\mp3\Secret Garden - Song From A Secret Garden.mp3'
              // ];
              // var imgs = [
              //   r'https://img1.baidu.com/it/u=522408061,774677196&fm=253&fmt=auto&app=138&f=JPEG?w=200&h=200',
              //   r'https://img0.baidu.com/it/u=1455921778,3639757794&fm=253&fmt=auto&app=138&f=JPEG?w=200&h=200',
              //   r'https://img1.baidu.com/it/u=2692582747,2997136558&fm=253&fmt=auto&app=138&f=JPG?w=200&h=200',
              // ];
              // var list = <AudioSource>[];
              // for (var i = 0; i < paths.length; i++) {
              //   var filepath = paths[i];
              //   var tag = await AudioTags.read(filepath) ??
              //       Tag(
              //         title: basenameWithoutExtension(filepath),
              //         pictures: [],
              //       );
              //   list.add(AudioSource.file(
              //     Uri.file(filepath).toFilePath(windows: true),
              //     tag: MediaItem(
              //       id: filepath,
              //       title: tag.title ?? basenameWithoutExtension(filepath),
              //       artist: tag.trackArtist,
              //       album: tag.album,
              //       artUri: Uri.parse(imgs[i % imgs.length]),
              //     ),
              //   ));
              // }
              // try {
              //   var playlist = ConcatenatingAudioSource(children: list);
              //   await player.setAudioSource(playlist);
              //   // var uri = Uri.parse(path);
              //   // await player.setAudioSource(
              //   //   AudioSource.uri(uri),
              //   // );
              // } catch (e) {
              //   error(e);
              // }
              // // .then((_) => player.play());

              // var path = r'C:\Users\xuxiaodong\Music\真的爱你.mp3';
              var paths = [
                r'C:\Users\xuxiaodong\Music\真的爱你.mp3',
                r'C:\Users\xuxiaodong\Music\test.mp3',
                r'C:\Users\xuxiaodong\Music\mp3\Joanie Madden - Lotus Jones.mp3',
                r'C:\Users\xuxiaodong\Music\mp3\Secret Garden - Song From A Secret Garden.mp3'
              ];
              var ps = await Permission.audio.request();
              debug('Permission:$ps');
              // var dir = '/storage/emulated/0/Music/down/';
              // var dir = '/storage/emulated/0/Music/QQMusic/';
              var dir = await FilePicker.platform.getDirectoryPath();
              debug(dir);
              if (dir == null) {
                return;
              }
              var flist = Directory(dir).listSync(recursive: true);
              paths = flist
                  .where((e) =>
                      FileSystemEntity.isFileSync(e.path) && isAudio(e.path))
                  .map((e) => e.path)
                  .toList();
              debug('目录下的音乐文件：$paths');

              // var fpr = await FilePicker.platform.pickFiles();
              // if (fpr == null) {
              //   return;
              // }
              // paths = fpr.files
              //     .where((element) => (element.path ?? '').endsWith('.mp3'))
              //     .toList()
              //     .map((e) => e.path!)
              //     .toList();
              var imgs = [
                r'https://img1.baidu.com/it/u=522408061,774677196&fm=253&fmt=auto&app=138&f=JPEG?w=200&h=200',
                Uri.file(r'C:\Users\xuxiaodong\Pictures\png2000\png-0028.png')
                    .toString(),
                r'https://img0.baidu.com/it/u=1455921778,3639757794&fm=253&fmt=auto&app=138&f=JPEG?w=200&h=200',
                r'https://img1.baidu.com/it/u=2692582747,2997136558&fm=253&fmt=auto&app=138&f=JPG?w=200&h=200',
              ];
              var list = <MyMedia>[];
              try {
                for (var i = 0; i < paths.length; i++) {
                  var filepath = paths[i];
                  var tag = await tryGetAudioTags(filepath) ??
                      Tag(
                        title: basenameWithoutExtension(filepath),
                        pictures: [],
                      );
                  debug('Tag:title:${tag.title},${tag.duration}');
                  list.add(MyMedia(
                    id: '$i',
                    title: tag.title ?? basenameWithoutExtension(filepath),
                    source: filepath,
                    artist: tag.trackArtist,
                    album: tag.album,
                    artUri: Uri.parse(imgs[i % imgs.length]),
                    // extras: {
                    //   'id': filepath,
                    //   'title': tag.title ?? basenameWithoutExtension(filepath),
                    //   'artist': tag.trackArtist,
                    //   'album': tag.album,
                    //   'artUri': Uri.parse(imgs[i % imgs.length]),
                    // },
                  ));
                }
                await adapter.updateQueue(list);
                // var playlist = Playlist(list);
                // await player.open(playlist);
                // var uri = Uri.parse(path);
                // await player.setAudioSource(
                //   AudioSource.uri(uri),
                // );
              } catch (e) {
                error('添加目录出错', e);
              }
              // .then((_) => player.play());
            },
            child: const Text('Play new'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (adapter.playing) {
                await adapter.pause();
              } else {
                await adapter.play();
              }
            },
            child: const Text('Pause'),
          ),
          ElevatedButton(
            onPressed: () async {
              await adapter.skipToNext();
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Future<Tag?> tryGetAudioTags(String filepath) async =>
      await AudioTags.read(filepath).catchError((e) {
        return null;
      });
}

bool isAudio(String path) {
  // var ext = extension(path);
  // return [
  //   '.mp3',
  //   '.wav',
  //   '.wma',
  //   '.flac',
  //   '.ape',
  //   '.aac',
  // ].contains(ext);
  return true;
}
