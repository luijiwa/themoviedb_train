import 'dart:math';

import 'package:flutter/material.dart';

class CustomPaintExample extends StatelessWidget {
  const CustomPaintExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
          width: 100,
          height: 100,
          child: RadialPercentWidget(
            fillColor: Colors.blue,
            freeColor: Colors.yellow,
            lineColor: Colors.red,
            lineWidth: 5,
            percent: 0.72,
            child: Text(
              '72%',
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }
}

class RadialPercentWidget extends StatelessWidget {
  final Widget child;
  final double percent;
  final Color fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;
  const RadialPercentWidget(
      {Key? key,
      required this.child,
      required this.percent,
      required this.fillColor,
      required this.lineColor,
      required this.freeColor,
      required this.lineWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
            painter: MyPainter(
          fillColor: fillColor,
          freeColor: freeColor,
          lineColor: lineColor,
          lineWidth: lineWidth,
          percent: percent,
        )),
        Padding(
          padding: const EdgeInsets.all(11),
          child: Center(child: child),
        ),
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  final double percent;
  final Color fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;

  MyPainter({
    required this.percent,
    required this.fillColor,
    required this.lineColor,
    required this.freeColor,
    required this.lineWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final arcRect = calculateArcsRect(size);

    drawBackground(canvas, size);
    drawFreeArc(canvas, arcRect);
    drawFilledArc(canvas, arcRect);
  }

  void drawFilledArc(Canvas canvas, Rect arcRect) {
    final paint = Paint();
    paint.color = lineColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = lineWidth;
    paint.strokeCap = StrokeCap.round;
    canvas.drawArc(
      arcRect,
      -pi / 2,
      2 * pi * percent,
      false,
      paint,
    );
  }

  void drawFreeArc(Canvas canvas, Rect arcRect) {
    final paint = Paint();
    paint.color = freeColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = lineWidth;
    canvas.drawArc(
      arcRect,
      2 * pi * percent - (pi / 2),
      2 * pi * (1.0 - percent),
      false,
      paint,
    );
  }

  void drawBackground(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = fillColor;
    paint.style = PaintingStyle.fill;
    canvas.drawOval(Offset.zero & size, paint);
  }

  Rect calculateArcsRect(Size size) {
    const linesMargin = 3;
    final offset = lineWidth / 2 + linesMargin;
    final arcRect = Offset(offset, offset) &
        Size(size.width - offset * 2, size.height - offset * 2);
    return arcRect;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
