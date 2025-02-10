import 'package:flutter/material.dart';

class SignaturePadController extends ChangeNotifier {
  SignaturePadController();

  /// 存储用户绘制的路径
  ValueNotifier<List<Path>> paths = ValueNotifier([]);

  /// 存储每个路径的绘制点
  ValueNotifier<List<List<Offset>>> points = ValueNotifier([]);

  /// 存储用户绘制的路径历史记录
  ValueNotifier<List<Path>> pathsHistory = ValueNotifier([]);

  /// 存储每个路径的绘制点历史记录
  ValueNotifier<List<List<Offset>>> pointsHistory = ValueNotifier([]);

  /// 存储每个路径的颜色历史记录
  ValueNotifier<List<Color>> pathColorHistory = ValueNotifier([]);

  ValueNotifier<bool> isCancelStep = ValueNotifier(false);
  ValueNotifier<bool> isForwardStep = ValueNotifier(false);

  List<Color> pathColor = [];
  int index = 0;

  /// 当用户开始触摸屏幕时，创建新的路径和新的点列表
  void onPanStart(DragStartDetails details, Color color) {
    // 如果当前不是最新的历史记录，清除之后的历史记录
    if (index < pathsHistory.value.length) {
      pathsHistory.value = pathsHistory.value.sublist(0, index);
      pointsHistory.value = pointsHistory.value.sublist(0, index);
      pathColorHistory.value =
          pathColorHistory.value.sublist(0, index); // 同步清除颜色历史记录
    }

    // 创建新的路径和点列表
    paths.value.add(
        Path()..moveTo(details.localPosition.dx, details.localPosition.dy));
    points.value.add([details.localPosition]);

    // 更新历史记录
    pathsHistory.value.add(paths.value.last);
    pointsHistory.value.add(points.value.last);
    pathColorHistory.value.add(color); // 同步记录颜色历史记录
    pathColor.add(color);

    // 更新索引
    index = pathsHistory.value.length;

    // 更新状态
    isCancelStep.value = true;
    isForwardStep.value = false;

    notifyListeners();
  }

  /// 当用户触摸时，完成当前路径的绘制
  void onPanUpdate(DragUpdateDetails details) {
    // 获取当前正在绘制的路径和点列表
    final int currentIndex = paths.value.length - 1;
    final Path path = paths.value[currentIndex];
    final List<Offset> point = points.value[currentIndex];

    // 将当前触摸点添加到点列表中
    point.add(details.localPosition);

    // 从上次的点到当前点绘制直线
    if (point.length >= 2) {
      path.quadraticBezierTo(
        point[point.length - 2].dx,
        point[point.length - 2].dy,
        (point[point.length - 2].dx + details.localPosition.dx) / 2,
        (point[point.length - 2].dy + details.localPosition.dy) / 2,
      );
    }

    notifyListeners();
  }

  /// 取消上一步绘制
  void cancelStep() {
    if (paths.value.isNotEmpty) {
      // 移除路径、点和颜色
      paths.value.removeLast();
      points.value.removeLast();
      pathColor.removeLast();
      index--;

      // 更新状态
      isForwardStep.value = true;
      if (paths.value.isEmpty) {
        isCancelStep.value = false;
      }

      notifyListeners();
    }
  }

  /// 上一步绘制
  void forwardStep() {
    if (index < pathsHistory.value.length) {
      // 添加路径、点和颜色
      paths.value.add(pathsHistory.value[index]);
      points.value.add(pointsHistory.value[index]);
      pathColor.add(pathColorHistory.value[index]); // 同步添加颜色
      index++;

      // 更新状态
      isCancelStep.value = true;
      if (index == pathsHistory.value.length) {
        isForwardStep.value = false;
      }

      notifyListeners();
    }
  }
}
