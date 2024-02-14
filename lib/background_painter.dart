import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  final List<Offset> points;
  final List<double> lengths;
  final Offset? currentPoint;
  final Offset? fixedPoint;
  final Offset backgroundOffset;

  BackgroundPainter({
    required this.points,
    required this.lengths,
    required this.currentPoint,
    required this.fixedPoint,
    required this.backgroundOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double dotSize = 2.0;
    const double gap = 21.71;



    final Paint dotPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0;


    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (double i = -31 + backgroundOffset.dx; i < size.width + backgroundOffset.dx; i += gap) {
      for (double j = 4 + backgroundOffset.dy; j < size.height + backgroundOffset.dy; j += gap) {
        canvas.drawCircle(Offset(i, j), dotSize, dotPaint);
      }
    }

    if (points.isNotEmpty) {
      // Рисование иконочки первой точки
      drawIcon(canvas, points.first + backgroundOffset);
    }

    const double textOffset = 10.0; // Устанавливаем ваш желаемый отступ

    for (int i = 0; i < points.length; i++) {
      if (i > 0) {
        final startPoint = points[i - 1] + backgroundOffset;
        final endPoint = points[i] + backgroundOffset;

        canvas.drawLine(startPoint, endPoint, linePaint);

        // Отображение длины линии
        textPainter.text = TextSpan(
          text: lengths[i - 1].toStringAsFixed(2),
          style: const TextStyle(color: Colors.blue, fontSize: 20.0),
        );

        textPainter.layout();

        // Добавляем отступ к координатам середины линии
        final textCenter = (startPoint + endPoint) / 2 + const Offset(0, textOffset);

        textPainter.paint(canvas, textCenter);
      }
    }

    if (points.length == 5) {
      // Если соединены 4 точки, закрасить фон белым
      Path path = Path();
      path.moveTo(points[0].dx + backgroundOffset.dx, points[0].dy + backgroundOffset.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx + backgroundOffset.dx, points[i].dy + backgroundOffset.dy);
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()..color = Colors.white,
      );
    }

    if (currentPoint != null) {
      canvas.drawCircle(currentPoint! + backgroundOffset, dotSize, dotPaint);
      if (points.isNotEmpty) {
        canvas.drawLine(points.last + backgroundOffset, currentPoint! + backgroundOffset, linePaint);

        // Отображение длины линии
        textPainter.text = TextSpan(
          text: (currentPoint! - points.last).distance.toStringAsFixed(2),
          style: const TextStyle(color: Colors.blue, fontSize: 20.0),
        );

        textPainter.layout();
        textPainter.paint(canvas, (points.last + currentPoint!) / 2);
      }
    }

    if (fixedPoint != null) {
      canvas.drawCircle(fixedPoint! + backgroundOffset, dotSize, dotPaint);
      if (points.isNotEmpty) {
        canvas.drawLine(points.last + backgroundOffset, fixedPoint! + backgroundOffset, linePaint);

        // Отображение длины линии
        textPainter.text = TextSpan(
          text: (fixedPoint! - points.last).distance.toStringAsFixed(2),
          style: const TextStyle(color: Colors.blue, fontSize: 20.0),
        );

        textPainter.layout();
        textPainter.paint(canvas, (points.last + fixedPoint!) / 2);
      }
    }
  }

  void drawIcon(Canvas canvas, Offset center) {
    const double iconSize = 55.0;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final iconPaint = Paint();

    // Устанавливаем цвет иконки
    iconPaint.color = Colors.red; // Замените Colors.red на ваш цвет

    const icon = Icons.add;
    final iconData = icon.codePoint;

    final textStyle = TextStyle(
      fontFamily: icon.fontFamily,
      fontSize: iconSize,
      color: iconPaint.color,
    );

    final textSpan = TextSpan(
      text: String.fromCharCode(iconData),
      style: textStyle,
    );

    textPainter.text = textSpan;
    textPainter.layout();

    final offset = center - const Offset(iconSize / 2, iconSize / 2);
    textPainter.paint(canvas, offset);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}