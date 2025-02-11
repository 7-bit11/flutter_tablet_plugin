// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_tablet_plugin/src/signature_pad_controller.dart';

class SignaturePad extends StatefulWidget {
  SignaturePad({
    super.key,
    required this.controller,
    this.textColor = Colors.black,
    this.strokeCap = StrokeCap.round,
  });
  final SignaturePadController controller;

  ///  文本颜色
  Color textColor;

  /// 画笔样式
  StrokeCap strokeCap;
  @override
  _SignaturePadState createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  late SignaturePadController _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        _controller.onPanStart(details, widget.textColor);
      },
      onPanUpdate: (DragUpdateDetails details) {
        _controller.onPanUpdate(details);
        setState(() {});
      },
      child: ListenableBuilder(
        listenable: _controller.paths,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: SignaturePainter(_controller.paths.value,
                pathColor: _controller.pathColor,
                penSize: _controller.penSize,
                strokeCap: widget.strokeCap),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Path> paths;
  final List<Color> pathColor;
  final List<double> penSize;

  ///  文本颜色

  /// 画笔大小

  /// 画笔样式
  StrokeCap strokeCap;
  SignaturePainter(this.paths,
      {required this.penSize,
      required this.pathColor,
      required this.strokeCap});

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < pathColor.length; i++) {
      final Paint paint = Paint()
        ..color = pathColor[i]
        ..strokeWidth = penSize[i]
        ..strokeCap = strokeCap
        ..style = PaintingStyle.stroke;
      canvas.drawPath(paths[i], paint);
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
