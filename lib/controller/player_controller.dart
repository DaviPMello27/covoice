import 'package:covoice/model/player_model_inteface.dart';

import 'player_controller_inteface.dart';

class PlayerController implements IPlayerController {
  IPlayerModel playerModel;

  PlayerController(this.playerModel);

  @override
  Future playAudio(String path) {
    return playerModel.playAudio(path);
  }

  @override
  Future playAudiosTogether(String path1, String path2) {
    return playerModel.playAudiosTogether(path1, path2);
  }

}

