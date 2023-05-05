import 'dart:developer';

import 'package:covoice/entities/note.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

import 'ffmpeg_model_inteface.dart';
import 'music_model_inteface.dart';

class FFmpegModel implements IFFmpegModel {
  IMusicModel musicModel;

  FFmpegModel({required this.musicModel});

  @override
  Future<String> transformIntoHarmony(String path, List<Note> notes, String key) async {
    int ffmpegVariable = 0;
    int currentTime = 0;
    String resultPath = path.substring(0, path.lastIndexOf('.')) + '-transformed.m4a';
    String ffmpegQuery = '-i $path -filter_complex "';
    notes.asMap().forEach((index, note) {
      if(index == 0){
        ffmpegQuery += '[0:a]atrim=start=0:duration=${notes[index + 1].getTime},asetpts=PTS-STARTPTS[${++ffmpegVariable}];';
      } else if(index == notes.length - 1) {
        print(note.getNote! + ": " + musicModel.isMajor(note.getNote!, key).toString());
        ffmpegQuery = ffmpegQuery.substring(0, ffmpegQuery.length - 1); //remove last ;
        ffmpegQuery += '" -map [$ffmpegVariable] $resultPath';
      } else {
        print(note.getNote! + ": " + musicModel.isMajor(note.getNote!, key).toString());
        String thirdRatioQuery = 'asetrate=44100*6/5,atempo=5/6'; //minor ratio 6:5
        if(musicModel.isMajor(note.getNote!, key)){
          thirdRatioQuery = 'asetrate=44100*5/4,atempo=4/5'; //major ratio 5:4
        }
        ffmpegQuery += '[0:a]atrim=start=${note.getTime}:duration=${notes[index + 1].getTime - note.getTime},asetpts=PTS-STARTPTS[${++ffmpegVariable}];';
        ffmpegQuery += '[$ffmpegVariable]$thirdRatioQuery[${++ffmpegVariable}];';
        ffmpegQuery += '[${ffmpegVariable - 2}][$ffmpegVariable]concat=n=2:v=0:a=1[${++ffmpegVariable}];';
      }
    });
    
    log(ffmpegQuery);
    await FFmpegKit.execute(ffmpegQuery).then(
      (value) => value.getAllLogsAsString().then((logs) => log(logs ?? 'no logs!'))
    );
    log(resultPath);
    return resultPath;
  }
}
