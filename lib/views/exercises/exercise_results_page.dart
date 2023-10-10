import 'dart:convert';
import 'dart:math';

import 'package:covoice/controller/recording_controller.dart';
import 'package:covoice/entities/exercise.dart';
import 'package:covoice/entities/game_note.dart';
import 'package:covoice/entities/note.dart';
import 'package:covoice/model/recording_model.dart';
import 'package:covoice/views/exercises/exercises_list_page.dart';
import 'package:covoice/views/exercises/game/exercise_game.dart';
import 'package:covoice/views/exercises/game/exercise_game_state.dart';
import 'package:covoice/views/themes.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseResultsPage extends StatefulWidget {
  final ExerciseGameState state;
  final int number;

  const ExerciseResultsPage ({ required this.state, required this.number, Key? key }) : super(key: key);

  @override
  State<ExerciseResultsPage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExerciseResultsPage> {
  final double maxScoreTolerance = 0.1;
  bool loaded = false;
  int numStars = 0;

  @override
  void initState() {
    widget.state.recording = false;
    widget.state.playing = false;
    
    numStars = (5*widget.state.score / (widget.state.exercise.maxScore * (1-maxScoreTolerance))).floor();

    if(numStars > widget.state.exercise.stars){
      widget.state.exercise.stars = numStars;
    }

    setState(() {
      loaded = true;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
      ),
      body: Builder(
        builder: (context) {
          if(loaded){
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Exercise ${widget.number}',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(
                    width: WidthProportion.of(context).half,
                    child: const Divider(color: Color.fromARGB(255, 178, 215, 232)),
                  ),
                  Text(
                    widget.state.exercise.module[0].toUpperCase() + widget.state.exercise.module.substring(1),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.state.exercise.title,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300, fontSize: 20),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i){
                      double fiveStarsScore = widget.state.exercise.maxScore * (1-maxScoreTolerance);
                      double currentScoreThreshold = fiveStarsScore / 5 * (i+1);

                    

                      return Transform.translate(
                        offset: Offset(
                          (i == 0 || i == 4) ? i == 0 ? 15 : -15 : 0, //most left + 10, most right - 10
                          pow((i * 4) - 8, 2).toDouble()
                        ),
                        child: Transform.rotate(
                          angle: ((i * 30) - 60) * pi / 180,
                          child: Icon(
                            Icons.star,
                            size: 64,
                            color: widget.state.score >= currentScoreThreshold ? Colors.yellow : Theme.of(context).colorScheme.secondaryVariant,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 80),
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.secondary)
                    ),
                    child: Column(
                      children: [
                        PerformanceIndicator(label: 'Pontuação:', value: '${widget.state.score}/${widget.state.exercise.maxScore}'),
                        PerformanceIndicator(value: '${(widget.state.score / widget.state.exercise.maxScore) * 100}%'),
                      ]
                    ),
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: _ExerciseResultsPageButton(
                          'Return', 
                          icon: Icons.arrow_back, 
                          onTap: (){
                            int count = 2;
                            Navigator.of(context).popUntil((route) => count-- == 0);
                          }
                        ),
                      ),
                      Flexible(
                        child: _ExerciseResultsPageButton(
                          'Retry',
                          icon: Icons.replay_rounded,
                          onTap: (){
                            widget.state.reset();
                            Navigator.of(context).pop();
                          }
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}

class PerformanceIndicator extends StatelessWidget {
  final String label;
  final String value;
  const PerformanceIndicator({ this.label = '', required this.value, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}

class _ExerciseResultsPageButton extends StatelessWidget { //TODO: New component
  String text;
  void Function() onTap;
  IconData? icon;

  _ExerciseResultsPageButton(this.text, {required this.onTap, this.icon, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextButton(
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if(icon != null) Text(
              String.fromCharCode(icon!.codePoint),
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
                fontSize: 32.0,
                fontWeight: FontWeight.w900,
                fontFamily: icon!.fontFamily,
                package: icon!.fontPackage,
              ),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.background
              ),
              textAlign: TextAlign.center,
            )
          ],
        )
      ),
    );
  }
}