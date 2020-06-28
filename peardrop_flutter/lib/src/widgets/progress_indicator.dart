import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PercentageProgressIndicator extends StatefulWidget {
  PercentageProgressIndicator({this.centerIcon});
  final IconData centerIcon;

  @override
  _PercentageProgressIndicatorState createState() =>
      _PercentageProgressIndicatorState(centerIcon: centerIcon);
}

class _PercentageProgressIndicatorState
    extends State<PercentageProgressIndicator> with TickerProviderStateMixin {
  double percentage = 0.0, newPercentage = 0.0;
  AnimationController percentageAnimationController;
  _PercentageProgressIndicatorState({this.centerIcon});
  IconData centerIcon;

  @override
  void initState() {
    super.initState();
    setState(() {
      percentage = 0.0;
    });
    percentageAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000))
      ..addListener(() {
        setState(() {
          percentage = lerpDouble(
              percentage, newPercentage, percentageAnimationController.value);
        });
      });
  }

  void startTimer() {
    percentage = 0.0;
    newPercentage = 0.0;
    if (!mounted) return;
    new Timer.periodic(
      Duration(seconds: 2),
      (Timer timer) => setState(() {
        if (newPercentage == 100.0) {
          timer.cancel();
        } else {
          percentage = newPercentage;
          newPercentage += 10;
          percentageAnimationController.forward(from: 0.0);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    centerIcon = widget.centerIcon;
    return Center(
      child: Container(
        child: CustomPaint(
          foregroundPainter: new MyPainter(
              lineColor: Colors.grey,
              completeColor: Color(0xff91c27d),
              completePercent: percentage,
              width: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: RaisedButton(
                elevation: 0,
                color: Colors.white,
                splashColor: Colors.white,
                shape: CircleBorder(),
                child: Text(
                  percentage.toInt().toString() + '%',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                ),
                // child: Icon(
                //   centerIcon,
                //   color: Colors.white,
                //   size: 45,
                // ),
                onPressed: () {
                  startTimer();
                }),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  MyPainter(
      {this.lineColor, this.completeColor, this.completePercent, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * (completePercent / 100);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
