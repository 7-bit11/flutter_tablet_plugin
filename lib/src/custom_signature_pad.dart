// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key});

  @override
  _SignaturePadState createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  // 存储用户绘制的路径
  final List<Path> _paths = [];
  // 存储每个路径的绘制点
  final List<List<Offset>> _points = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        setState(() {
          // 当用户开始触摸屏幕时，创建新的路径和新的点列表

          _paths.add(Path()
            ..moveTo(details.localPosition.dx, details.localPosition.dy));
          _points.add([details.localPosition]);
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          // 获取当前正在绘制的路径和点列表
          final int index = _paths.length - 1;
          final Path path = _paths[index];
          final List<Offset> points = _points[index];
          // 将当前触摸点添加到点列表中
          points.add(details.localPosition);
          // 从上次的点到当前点绘制直线
          if (points.length >= 2) {
            //_paths[index] = path;
            path.quadraticBezierTo(
              points[points.length - 2].dx,
              points[points.length - 2].dy,
              (points[points.length - 2].dx + details.localPosition.dx) / 2,
              (points[points.length - 2].dy + details.localPosition.dy) / 2,
            );
          }
        });
      },
      onPanEnd: (DragEndDetails details) {
        // setState(() {
        //   // 当用户结束触摸时，完成当前路径的绘制
        //   final int index = _paths.length - 1;
        //   final Path path = _paths[index];
        //   final List<Offset> points = _points[index];
        //   // 从最后一个点到当前点绘制直线
        //   if (points.length >= 2) {
        //     path.quadraticBezierTo(
        //       points[points.length - 1].dx,
        //       points[points.length - 1].dy,
        //       points[points.length - 1].dx,
        //       points[points.length - 1].dy,
        //     );
        //   }
        // });
      },
      child: CustomPaint(
        painter: SignaturePainter(_paths),
        size: Size.infinite,
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Path> paths;

  SignaturePainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    // 绘制每个路径
    for (Path path in paths) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
