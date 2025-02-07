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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.arrow_left), label: "Back"),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_right), label: "Forward"),
        ],
        onTap: (value) {
          if (value == 0) {
            _controller.cancelStep();
          }
        },
      ),
    ));
  }
}
