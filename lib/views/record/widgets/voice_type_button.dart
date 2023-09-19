import 'package:covoice/enums/voice_type.dart';
import 'package:flutter/material.dart';

class VoiceTypeButton extends StatelessWidget {
  final VoiceType voiceType;
  final bool selected;
  final void Function() onTap;

  const VoiceTypeButton({ required this.voiceType, required this.selected, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = selected ? Theme.of(context).textTheme.subtitle2!.color! : Theme.of(context).textTheme.subtitle1!.color!;
    Color foregroundColor = selected ? Theme.of(context).textTheme.subtitle1!.color! : Theme.of(context).primaryColor;
    
    
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _VoiceButtonLine(color: [VoiceType.both, VoiceType.primary].contains(voiceType) ? foregroundColor : backgroundColor),
                _VoiceButtonLine(color: [VoiceType.both, VoiceType.secondary].contains(voiceType) ? foregroundColor : backgroundColor),
              ],
            )
          ),
        ),
      ),
    );
  }
}

class _VoiceButtonLine extends StatelessWidget {
  final Color color;

  const _VoiceButtonLine({ required this.color, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Container(
          height: 6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(20))
          ),
        ),
      ),
    );
  }
}