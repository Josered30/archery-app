import 'dart:ui';

import 'package:archery/domain/value-objects/round_score.dart';
import 'package:archery/domain/value-objects/target.dart';
import 'package:flutter/material.dart';

class TargetPainter extends CustomPainter {
  List<RoundScore> roundScores;
  Target target;

  TargetPainter({this.roundScores = const [], required this.target});

  @override
  void paint(Canvas canvas, Size size) {
    final greyPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.grey[700] as Color;

    Offset centerOffset = Offset(size.width / 2, size.height / 2);

    for (var targetLayer in target.targetLayers) {
      Paint cyanPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = targetLayer.color;

      canvas.drawCircle(
        centerOffset,
        targetLayer.radius,
        cyanPaint,
      );

      canvas.drawCircle(
        centerOffset,
        targetLayer.radius,
        greyPaint,
      );
    }

    canvas.drawLine(Offset((size.width / 2), (size.height / 2) - 10),
        Offset((size.width / 2), (size.height / 2) + 10), greyPaint);

    canvas.drawLine(Offset((size.width / 2) - 10, (size.height / 2)),
        Offset((size.width / 2) + 10, (size.height / 2)), greyPaint);

    final greyPointPaint = Paint()
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey[200] as Color;

    List<RoundScore> normalizedRoundScores = roundScores
        .map((roundScore) => RoundScore(
            scoreValue: roundScore.score.value,
            dx: roundScore.dx * size.width,
            dy: roundScore.dy * size.height))
        .toList();

    List<Offset> scores = normalizedRoundScores
        .map((roundScore) => Offset(roundScore.dx, roundScore.dy))
        .toList(growable: true);

    TextStyle textStyle = TextStyle(
      color: Colors.grey[200],
      fontSize: 16,
    );

    for (var roundScore in normalizedRoundScores) {
      TextSpan textSpan = TextSpan(
        text: roundScore.score.toString(),
        style: textStyle,
      );

      TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      Offset offset = Offset(roundScore.dx + 10, roundScore.dy - 15);
      textPainter.paint(canvas, offset);
    }

    canvas.drawPoints(PointMode.points, scores, greyPointPaint);
  }

  @override
  bool shouldRepaint(TargetPainter oldDelegate) {
    return roundScores != oldDelegate.roundScores;
  }
}
