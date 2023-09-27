import 'package:flutter/material.dart';

class FlagPainter extends CustomPainter {
  final Color strokeColor;
  final bool flip;

  FlagPainter({this.strokeColor = Colors.black, this.flip = false});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(getTrianglePath(size.width, size.height, flip), paint);
  }

  Path getTrianglePath(double x, double y, bool flip) {
    if(flip){
      return Path()
        ..moveTo(x, 0)
        ..lineTo(0, 0)
        ..lineTo(x*1/3, y/2)
        ..lineTo(0, y)
        ..lineTo(x, y)
        ..lineTo(x, 0);
    } else {
      return Path()
        ..moveTo(0, 0)
        ..lineTo(x, 0)
        ..lineTo(x*2/3, y/2)
        ..lineTo(x, y)
        ..lineTo(0, y)
        ..lineTo(0, 0);
    }
  }

  @override
  bool shouldRepaint(FlagPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor;
  }
}

class PageFlagButton extends StatelessWidget {
  final void Function() onPressed;
  final bool flip;
  final Color color;
  final Color iconColor;
  final IconData icon;

  const PageFlagButton({ Key? key, required this.onPressed, required this.color, required this.iconColor, required this.icon, this.flip = false }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: CustomPaint(
        painter: FlagPainter(strokeColor: color, flip: flip),
        child: SizedBox(
          height: 50,
          width: 100,
          child: Padding(
            padding: EdgeInsets.only(right: !flip ? 30.0 : 0.0, left: flip ? 30.0 : 0.0),
            child: Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}