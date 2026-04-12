import 'package:just_audio/just_audio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSound(String? assetPath) async {
    if (assetPath == null || assetPath.isEmpty) return;
    try {
      // For now, we handle placeholders or empty paths gracefully
      // In the future, the user will add real asset paths like 'assets/audio/rain.mp3'
      // await _player.setAsset(assetPath);
      // await _player.setLoopMode(LoopMode.one);
      // await _player.play();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> pauseSound() async {
    await _player.pause();
  }

  Future<void> stopSound() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
