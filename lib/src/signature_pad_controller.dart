import 'package:flutter/material.dart';

class SignaturePadController extends ChangeNotifier {
  SignaturePadController();

  /// 存储用户绘制的路径
  ValueNotifier<List<Path>> paths = ValueNotifier([]);

  /// 存储每个路径的绘制点
  ValueNotifier<List<List<Offset>>> points = ValueNotifier([]);

  /// 当用户开始触摸屏幕时，创建新的路径和新的点列表
  void onPanStart(DragStartDetails details) {
    paths.value.add(
        Path()..moveTo(details.localPosition.dx, details.localPosition.dy));
    points.value.add([details.localPosition]);
    notifyListeners();
  }

  /// 当用户触摸时，完成当前路径的绘制
  void onPanUpdate(DragUpdateDetails details) {
    // 获取当前正在绘制的路径和点列表
    final int index = paths.value.length - 1;
    final Path path = paths.value[index];
    final List<Offset> point = points.value[index];
    // 将当前触摸点添加到点列表中
    point.add(details.localPosition);
    // 从上次的点到当前点绘制直线
    if (point.length >= 2) {
      //_paths[index] = path;
      path.quadraticBezierTo(
        point[point.length - 2].dx,
        point[point.length - 2].dy,
        (point[point.length - 2].dx + details.localPosition.dx) / 2,
        (point[point.length - 2].dy + details.localPosition.dy) / 2,
      );
    }
  }

  /// 取消上一步绘制
  void cancelStep() {
    if (paths.value.isNotEmpty) {
      paths.value.removeLast();
      points.value.removeLast();
      notifyListeners();
    }
  }
}
