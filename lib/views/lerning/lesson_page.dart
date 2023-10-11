import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:covoice/entities/lesson.dart';
import 'package:covoice/views/record/widgets/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class _LessonAudio {
  PlayerController controller;
  File tempFile;

  _LessonAudio({required this.controller, required this.tempFile});
}

class LessonPage extends StatefulWidget {
  final Lesson module;
  final Lesson lesson;

  const LessonPage({required this.module, required this.lesson, Key? key }) : super(key: key);

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  bool loaded = false;
  final List<_LessonAudio> audios = [];
  final List<Widget> content = [];

  void loadImage(String lessonPath, String imageContent){
    List<String> separatedImageContent = imageContent.split('|');
    if(separatedImageContent.length > 2){
      throw Exception('Bad formatting on image statement: $imageContent');
    }

    bool hasCaption = separatedImageContent.length == 2;

    String imagePath = '$lessonPath/${hasCaption ? separatedImageContent.last : separatedImageContent.first}';

    content.add(
      Padding(
        padding: hasCaption ? const EdgeInsets.only(top: 20, bottom: 5) : const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondaryVariant,
              width: 2
            ),
          ),
          child: Image.asset(imagePath),
        )
      )
    );

    if(hasCaption){
      content.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(
            separatedImageContent.first,
            style: Theme.of(context).textTheme.caption,
          )
        )
      );
    }
  }

  void loadText(String textType, String textContent){
    String textStyle = textType.substring(textType.indexOf('|') + 1, textType.length);
    switch(textStyle){
      case "bodyText2":
        content.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              textContent,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.justify,
            ),
          )
        );
        break;
      case "headline3":
        content.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              textContent,
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.justify,
            ),
          )
        );
        break;
    }
  }

  Future loadAudio(String path) async {
    ByteData audioData = await rootBundle.load(path);
    
    Directory tempPath = await getTemporaryDirectory();
    
    File tempFile = await File('${tempPath.path}/tempAudio${audios.length}').writeAsBytes(audioData.buffer.asUint8List(audioData.offsetInBytes, audioData.lengthInBytes));


    PlayerController controller = PlayerController();
    await controller.preparePlayer(
      path: tempFile.path,
      shouldExtractWaveform: true,
      noOfSamples: 25,
      volume: 1.0,
    );
    audios.add(_LessonAudio(controller: controller, tempFile: tempFile));

    content.add(
      Player(
        controller: controller,
        shareablePath: tempFile.path,
      )
    );
  }

  Future loadContent() async {
    String lessonPath = 'assets/lessons${widget.module.folderName}${widget.lesson.folderName}';
    String fileString = await rootBundle.loadString('$lessonPath/lesson');

    for(String line in LineSplitter.split(fileString).toList()){
      String textType = line.substring(1, line.indexOf(']'));
      String textContent = line.substring(line.indexOf(']') + 1, line.length);

      switch(textType){
        case "image":
          loadImage(lessonPath, textContent);
          break;
        case "audio":
          await loadAudio('$lessonPath/$textContent');
          break;
        case "text|bodyText2":
        case "text|headline3":
          loadText(textType, textContent);
          break;
      }
    }

    content.add(
      TextButton( //TODO: New component
        onPressed: (){
          //TODO: Mark as finished
          Navigator.pop(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              String.fromCharCode(Icons.check.codePoint),
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
                fontSize: 32.0,
                fontWeight: FontWeight.w900,
                fontFamily: Icons.check.fontFamily,
                package: Icons.check.fontPackage,
              ),
            ),
            const Text('Marcar como finalizado')
          ],
        )
      )
    );

    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    loadContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title)),
      body: loaded ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: content,
          ),
        ),
      ) : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    for (_LessonAudio audio in audios) {
      audio.tempFile.delete();
      audio.controller.dispose();
    }
    super.dispose();
  }
}