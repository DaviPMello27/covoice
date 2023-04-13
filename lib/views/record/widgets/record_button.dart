import 'package:flutter/material.dart';

import '../../themes.dart';

class RecordButton extends StatefulWidget {
  final void Function() onTap;

  const RecordButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  final iconSize = 100.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: WidthProportion.of(context).oneTenth),
      child: ElevatedButton(
        child: Ink(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                Theme.of(context)
                    .elevatedButtonTheme
                    .style!
                    .backgroundColor!
                    .resolve({})!,
                Theme.of(context).buttonColor,
              ])),
          child: Padding(
            padding: EdgeInsets.all(WidthProportion.of(context).oneSixth),
            child: Icon(
              Icons.mic,
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
