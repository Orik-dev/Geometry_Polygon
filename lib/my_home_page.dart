import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_test_app/background_painter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Offset> points = [];
  List<double> lengths = [];
  Offset? currentPoint;
  Offset? fixedPoint;
  Offset backgroundOffset = const Offset(0, 0);

  bool isLineIntersecting() {
    if (points.length < 2) {
      return false;
    }

    Offset p1 = points[points.length - 2];
    Offset q1 = points[points.length - 1];

    for (int i = 0; i < points.length - 3; i += 2) {
      Offset p2 = points[i];
      Offset q2 = points[i + 1];

      if (doIntersect(p1, q1, p2, q2)) {
        return true;
      }
    }

    return false;
  }

  bool doIntersect(Offset p1, Offset q1, Offset p2, Offset q2) {
    int o1 = orientation(p1, q1, p2);
    int o2 = orientation(p1, q1, q2);
    int o3 = orientation(p2, q2, p1);
    int o4 = orientation(p2, q2, q1);

    if (o1 != o2 && o3 != o4) {
      return true;
    }

    if (o1 == 0 && onSegment(p1, p2, q1)) return true;
    if (o2 == 0 && onSegment(p1, q2, q1)) return true;
    if (o3 == 0 && onSegment(p2, p1, q2)) return true;
    if (o4 == 0 && onSegment(p2, q1, q2)) return true;

    return false;
  }

  int orientation(Offset p, Offset q, Offset r) {
    double val = (q.dy - p.dy) * (r.dx - q.dx) - (q.dx - p.dx) * (r.dy - q.dy);

    if (val == 0) return 0;

    return (val > 0) ? 1 : 2;
  }

  bool onSegment(Offset p, Offset q, Offset r) {
    if (q.dx <= math.max(p.dx, r.dx) &&
        q.dx >= math.min(p.dx, r.dx) &&
        q.dy <= math.max(p.dy, r.dy) &&
        q.dy >= math.min(p.dy, r.dy)) {
      return true;
    }
    return false;
  }

  void undoLastAction() {
    setState(() {
      if (points.isNotEmpty) {
        points.removeLast();
        if (points.isNotEmpty) {
          fixedPoint = points.last;
          points.removeLast();
        }
        if (lengths.isNotEmpty) {
          lengths.removeLast();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFE3E3E3),
            child: CustomPaint(
              painter: BackgroundPainter(
                points: points,
                lengths: lengths,
                currentPoint: currentPoint,
                fixedPoint: fixedPoint,
                backgroundOffset: backgroundOffset,
              ),
              child: const Center(),
            ),
          ),
          Positioned(
            left: 20,
            top: 585 + backgroundOffset.dy,
            right: 20,
            child: Container(
              width: 359.0,
              height: 70.0,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13.0),
              ),
              child: GestureDetector(
                onTap: () {
                },
                child: const Text(
                  'Нажмите на любую точку экрана, чтобы построить угол',
                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 667 + backgroundOffset.dy,
            right: 20,
            child: Container(
              width: 360.0,
              height: 76.0,
              padding: const EdgeInsets.all(11.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13.0),
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3E3E3),
                  borderRadius: BorderRadius.circular(13.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24.0,
                        padding: const EdgeInsets.all(3.55),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7D7D7D),
                          borderRadius: BorderRadius.circular(64.29),
                        ),
                        child: GestureDetector(
                          onTap: undoLastAction,
                          child: const Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 17.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            print('Нажатие на кнопку "Отменить действие"');
                            undoLastAction();
                          },
                          child: const Text(
                            'Отменить действие',
                            style: TextStyle(fontSize: 16.0, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                currentPoint = details.globalPosition - backgroundOffset;
              });
            },
            onPanEnd: (details) {
              setState(() {
                if (currentPoint != null) {
                  if (!isLineIntersecting()) {
                    fixedPoint = currentPoint;
                    points.add(currentPoint!);
                    if (points.length > 1) {
                      lengths.add((fixedPoint! - points[points.length - 2]).distance);
                    }
                    currentPoint = null;
                  } else {
                    currentPoint = null;
                  }
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
