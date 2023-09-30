import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  final PlayerController controller; 

  const Player({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  PlayerState createState() => PlayerState();
}

class PlayerState extends State<Player> {
  bool isPlaying = false;
  bool shouldRestart = false;

  @override
  void initState(){
    super.initState();
    
    widget.controller.onCompletion.listen((event) {
      setState(() {
        isPlaying = false;
        shouldRestart = true;
      });
    });
  }

  Future togglePlayPause() async {
    if(isPlaying){
      await widget.controller.pausePlayer();
    } else {
      if(shouldRestart){
        await widget.controller.seekTo(0);
        await widget.controller.startPlayer(finishMode: FinishMode.pause);
      } else {
        await widget.controller.startPlayer(finishMode: FinishMode.pause);
      }
    }
    if(shouldRestart){
      setState(() {
        shouldRestart = false;
      });
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(500)), //TODO: 500? fix! get computed value or something
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Transform.scale(
            scale: 2,
            child: IconButton(
              onPressed: togglePlayPause,
              padding: const EdgeInsets.all(0),
              icon: Icon(
                isPlaying 
                  ? Icons.pause
                  : shouldRestart 
                    ? Icons.replay 
                    : Icons.play_arrow_rounded,
                size: 28,
                color: Theme.of(context).colorScheme.secondary,
              )
            ),
          ),
          AudioFileWaveforms(
            size: Size(MediaQuery.of(context).size.width / 2.5, 80.0),
            playerController: widget.controller,
            enableSeekGesture: true,
            waveformType: WaveformType.fitWidth,
            playerWaveStyle: PlayerWaveStyle(
              fixedWaveColor: Theme.of(context).backgroundColor,
              liveWaveColor: Theme.of(context).colorScheme.secondaryVariant,
              spacing: 8,
            ),
          ),
          Transform.scale(
            scale: 2,
            child: IconButton(
              onPressed: (){},
              padding: const EdgeInsets.all(0),
              icon: Icon(
                Icons.share,
                size: 20,
                color: Theme.of(context).colorScheme.secondaryVariant,
              )
            ),
          ),
        ],
      )
    );
  }
}