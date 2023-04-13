import 'package:flutter/material.dart';
import 'package:roller_list/roller_list.dart';
import '../../themes.dart';

class KeyRollerList extends StatefulWidget {
  final List<String> keys;

  const KeyRollerList({required this.keys, Key? key}) : super(key: key);

  @override
  _KeyRollerListState createState() => _KeyRollerListState();
}

class _KeyRollerListState extends State<KeyRollerList> {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        colors: [
          Theme.of(context).backgroundColor,
          Theme.of(context).textTheme.subtitle1!.color!,
          Theme.of(context).backgroundColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTRB(
          0,
          0,
          rect.width,
          rect.height,
        ),
      ),
      child: RollerList(
        initialIndex: -1,
        visibilityRadius: 2,
        dividerColor: Colors.white,
        width: WidthProportion.of(context).oneThird,
        onSelectedIndexChanged: print,
        items: widget.keys
            .map<Widget>(
              (note) => Center(
                child: Text(
                  note,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
