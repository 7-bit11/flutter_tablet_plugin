// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_tablet_plugin/src/signature_pad_controller.dart';

class SignaturePad extends StatefulWidget {
  SignaturePad({
    super.key,
    required this.controller,
    this.textColor = Colors.black,
    this.penSize = 5.0,
    this.strokeCap = StrokeCap.round,
  });
  final SignaturePadController controller;

  ///  文本颜色
  Color textColor;

  /// 画笔大小
  double penSize;

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
        _controller.onPanStart(details);
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
                textColor: widget.textColor,
                penSize: widget.penSize,
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

  ///  文本颜色
  Color textColor;

  /// 画笔大小
  double penSize;

  /// 画笔样式
  StrokeCap strokeCap;
  SignaturePainter(this.paths,
      {required this.textColor,
      required this.penSize,
      required this.strokeCap});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = penSize
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;
    // 绘制每个路径
    for (Path path in paths) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
