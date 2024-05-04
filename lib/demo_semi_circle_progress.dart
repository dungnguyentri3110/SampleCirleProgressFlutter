import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DemoSemiCircleProgress extends StatefulWidget {
  const DemoSemiCircleProgress(
      {super.key,
        this.size = 200,
        this.percent = 0.0,
        this.trackColor = Colors.blue,
        this.hintTrackColor = Colors.pink,
        this.trackWidth = 20,
        this.hintTrackWidth = 10});

  final double percent; // Percent between 0.0 to 1.0
  final double size;
  final Color? trackColor;
  final Color? hintTrackColor;
  final double? trackWidth, hintTrackWidth;

  @override
  State<DemoSemiCircleProgress> createState() => _DemoSemiCircleProgressState();
}

class _DemoSemiCircleProgressState extends State<DemoSemiCircleProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    CurvedAnimation curves =
    CurvedAnimation(parent: controller, curve: Curves.linear);
    animation = Tween(begin: 0.0, end: widget.percent).animate(curves);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 500), () {
        controller.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("This is Progress bar"),
        ),
        body: AnimatedBuilder(
            animation: animation,
            builder: (_, w) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    color: Colors.yellow,
                    width: widget.size + (widget.trackWidth! * 2),
                    height: (widget.size + (widget.trackWidth! * 2)) / 2,
                    child: CustomPaint(
                      painter: CustomCircleProgress(
                        percent: animation.value,
                        size: widget.size,
                        trackColor: widget.trackColor,
                        hintTrackColor: widget.hintTrackColor,
                        hintTrackWidth: widget.hintTrackWidth,
                        trackWidth: widget.trackWidth,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: (((widget.size + (widget.trackWidth! * 2)) / 2) -
                          (widget.trackWidth! * 2)) /
                          3,
                      child: Text(
                        "${(animation.value * 100).round()}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ))
                ],
              );
            }));
  }
}

class CustomCircleProgress extends CustomPainter {
  final double percent, size;
  final Color? trackColor;
  final Color? hintTrackColor;
  final double? trackWidth, hintTrackWidth;

  const CustomCircleProgress(
      {this.size = 200,
        this.percent = 0.0,
        this.trackColor = Colors.blue,
        this.hintTrackColor = Colors.pink,
        this.trackWidth = 20,
        this.hintTrackWidth = 10});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = hintTrackColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = hintTrackWidth!;
    Paint paint2 = Paint()
      ..color = trackColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackWidth!;

    Rect rect = Rect.fromLTWH(trackWidth!, trackWidth!, this.size, this.size);

    canvas.drawArc(rect, pi, pi, false, paint);
    canvas.drawArc(rect, pi, percent * pi, false, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomCircleProgress oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.size != size ||
        oldDelegate.trackWidth != trackWidth ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.hintTrackWidth != hintTrackWidth ||
        oldDelegate.hintTrackColor != trackColor;
  }
}
