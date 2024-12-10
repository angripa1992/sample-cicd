// import 'package:audioplayers/audioplayers.dart';

import '../../resources/assets.dart';

class NotificationSound {
  // final _newOrderAudioPlayer = AudioPlayer()
  //   ..setReleaseMode(ReleaseMode.loop)
  //   ..setPlayerMode(PlayerMode.lowLatency);
  //
  // final _cancelOrderAudioPlayer = AudioPlayer()
  //   ..setReleaseMode(ReleaseMode.stop)
  //   ..setPlayerMode(PlayerMode.lowLatency);

  void playNewSound() {
    // _newOrderAudioPlayer.play(AssetSource(AppSounds.aNewOrder));
  }

  void playCancelSound() {
    // _cancelOrderAudioPlayer.play(AssetSource(AppSounds.aCancelOrder));
  }

  void stop() {
    // _newOrderAudioPlayer.stop();
    // _cancelOrderAudioPlayer.stop();
  }
}
