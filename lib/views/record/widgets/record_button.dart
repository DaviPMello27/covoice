import 'package:flutter/material.dart';

import '../../themes.dart';

class RecordButton extends StatefulWidget {
  final void Function() onTap;
  final bool isRecording;

  const RecordButton({
    required this.onTap,
    required this.isRecording,
    Key? key,
  }) : super(key: key);

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  final iconSize = 100.0;

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Theme.of(context).elevatedButtonTheme.style!.backgroundColor!.resolve({})!;

    Color darkerButtonColor = buttonColor
      .withRed((buttonColor.red * 0.9).round())
      .withGreen((buttonColor.green * 0.9).round())
      .withBlue((buttonColor.blue * 0.9).round());

    return Padding(
      padding: EdgeInsets.only(top: WidthProportion.of(context).oneTenth),
      child: ElevatedButton(
        child: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [buttonColor,darkerButtonColor])
          ),
          child: Padding(
            padding: EdgeInsets.all(WidthProportion.of(context).oneSixth),
            child: Icon(
              widget.isRecording ? Icons.stop : Icons.mic,
              size: iconSize,
              color: Theme.of(context).backgroundColor,
            ),
          ),
        ),
        onPressed: widget.onTap,
      ),
    );
  }
}
