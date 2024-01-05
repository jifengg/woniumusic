import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:media_kit/media_kit.dart';
import 'package:woniu_music/global.dart';
import 'package:woniu_music/packages/audio_adapter.dart';
import 'package:woniu_music/pages/home_page.dart';
import 'package:woniu_music/utils/logger_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  LoggerUtils.init(const LoggerOption(maxDay: kDebugMode ? 3 : 30));
  // AudioAdapter adapter = AudioAdapter();
  adapter = await AudioService.init(
    builder: () => AudioAdapter(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.woniufun.player',
      androidNotificationChannelName: 'com.woniufun.player',
    ),
  );
  await adapter.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Woniu Music',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: getTheme(),
      darkTheme: getTheme(brightness: Brightness.dark),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 添加指定支持的locale，在windows平台显示中文时，可以避免字体回落造成的cjk字符显示效果与预期不一致。
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      home: const HomePage(),
    );
  }

  ThemeData getTheme({
    Color seedColor = Colors.blue,
    Brightness brightness = Brightness.light,
  }) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
      useMaterial3: true,
    );
  }
}
