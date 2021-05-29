import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Animator(),
    );
  }
}

class Animator extends StatefulWidget {
  @override
  _AnimatorState createState() => _AnimatorState();
}

class _AnimatorState extends State<Animator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  var _sides = 3.0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));

    Tween<double> tween = Tween(begin: 0.0, end: 1.0);
    _animation = tween.animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.completed:
            _controller.repeat();
            break;
          case AnimationStatus.dismissed:
            _controller.forward();
            break;
          default:
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: TestPaint(_animation.value, _sides),
                    child: Container(),
                  );
                })),
        Slider(
          value: _sides,
          min: 3.0,
          max: 10.0,
          label: _sides.toInt().toString(),
          divisions: 7,
          onChanged: (value) {
            setState(() {
              _sides = value;
            });
          },
        )
      ],
    )));
  }
}

class TestPaint extends CustomPainter {
  double _width;
  double _sides;
  TestPaint(this._width, this._sides);
  @override
  void paint(Canvas canvas, Size size) {
    var middle = size.center(Offset.zero);

    var paint = Paint()
      ..style = PaintingStyle.fill
      // ..style = PaintingStyle.stroke
      // ..strokeWidth = 20
      ..color = Colors.blue
      ..isAntiAlias = true;

    var radius = size.height / 3 ?? 0; //size.width / 20;
    var sides = _sides; //10 * _width;

    var startAngle = (math.pi * 2) * _width;
    var angle = (math.pi * 2) / sides;

    Offset center = Offset(size.width / 2, size.height / 2);

    // startPoint => (100.0, 0.0)
    Offset startPoint =
        Offset(radius * math.cos(startAngle), radius * math.sin(startAngle));

    var path = Path();
    path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);

    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(startAngle + angle * i) + center.dx;
      double y = radius * math.sin(startAngle + angle * i) + center.dy;
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);

    // canvas.save();
    // canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
