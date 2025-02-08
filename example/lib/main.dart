import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tablet_plugin/flutter_tablet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final SignaturePadController _controller = SignaturePadController();

  void _clear() {
    _controller.cancelStep();
  }

  void _forward() {
    _controller.forwardStep();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: SignaturePad(
          controller: _controller,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: ListenableBuilder(
                builder: (context, clid) {
                  return Icon(
                    Icons.arrow_left,
                    color: _controller.isCancelStep.value
                        ? Colors.red
                        : Colors.blue,
                  );
                },
                listenable: _controller.isCancelStep,
              ),
              label: "Back"),
          BottomNavigationBarItem(
              icon: ListenableBuilder(
                builder: (context, clid) {
                  return Icon(
                    Icons.arrow_right,
                    color: _controller.isForwardStep.value
                        ? Colors.red
                        : Colors.blue,
                  );
                },
                listenable: _controller.isForwardStep,
              ),
              label: "Forward"),
        ],
        onTap: (value) {
          if (value == 0) {
            _clear();
          } else if (value == 1) {
            _forward();
          }
        },
      ),
    ));
  }
}
