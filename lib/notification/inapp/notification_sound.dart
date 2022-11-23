import 'package:audioplayers/audioplayers.dart';

import '../../resources/assets.dart';

class NotificationSound {
  final _audioPlayer = AudioPlayer()
    ..setReleaseMode(ReleaseMode.loop)
    ..setPlayerMode(PlayerMode.lowLatency);

  void playNewSound() {
    _audioPlayer.play(AssetSource(AppSounds.aNewOrder));
  }

  void playCancelSound() {
    _audioPlayer.play(AssetSource(AppSounds.aCancelOrder));
  }

  void stop() {
    _audioPlayer.stop();
  }
}
