import 'package:covoice/entities/note.dart';
import 'package:covoice/model/ffmpeg_model_inteface.dart';

import 'ffmpeg_controller_inteface.dart';

class FFmpegController implements IFFmpegController {
  IFFmpegModel ffmpegModel;

  FFmpegController(this.ffmpegModel);


  @override
  Future<String> transformIntoHarmony(String path, List<Note> notes, String key) {
    return ffmpegModel.transformIntoHarmony(path, notes, key);
  }

  @override
  Future<String> overlayAudios(String path1, String path2){
    return ffmpegModel.overlayAudios(path1, path2);
  }
}

