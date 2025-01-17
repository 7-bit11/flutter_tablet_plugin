import 'package:flutter/material.dart';

class SignaturePadController extends ChangeNotifier {
  SignaturePadController();

  // 存储用户绘制的路径
  ValueNotifier<List<Path>> paths = ValueNotifier([]);

  // 存储每个路径的绘制点
  ValueNotifier<List<List<Offset>>> points = ValueNotifier([]);
}
