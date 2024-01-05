//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audio_service
import audio_session
import audiotags
import media_kit_libs_macos_audio
import path_provider_foundation
import sqflite

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioServicePlugin.register(with: registry.registrar(forPlugin: "AudioServicePlugin"))
  AudioSessionPlugin.register(with: registry.registrar(forPlugin: "AudioSessionPlugin"))
  AudiotagsPlugin.register(with: registry.registrar(forPlugin: "AudiotagsPlugin"))
  MediaKitLibsMacosAudioPlugin.register(with: registry.registrar(forPlugin: "MediaKitLibsMacosAudioPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
}
