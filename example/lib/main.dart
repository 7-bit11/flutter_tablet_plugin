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

  Color _textColor = Colors.black;
  _changeColor(BuildContext context) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.brown,
      Colors.grey,
      Colors.black,
      Colors.white,
    ];
    showModalBottomSheet(
      context: context,
      //enableDrag: true,
      showDragHandle: true,
      elevation: 0,

      builder: (context) {
        return SizedBox(
          height: 300,
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: colors[index],
                ),
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _textColor = colors[index];
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  _changeSizeAdd() {
    _controller.size.value++;
  }

  _changeSizeReduce() {
    _controller.size.value--;
  }

  int _currentIndex = 0;

  double size = 5;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('手写板Demo'),
      ),
      body: Center(
        child: SignaturePad(
          controller: _controller,
          textColor: _textColor,
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () => _changeColor(context),
              child: const Icon(Icons.color_lens),
            );
          }),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => _changeSizeAdd(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => _changeSizeReduce(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: ListenableBuilder(
                builder: (context, clid) {
                  return Image.asset(
                    width: 20,
                    height: 20,
                    "assets/icons/arrow_left.png",
                    color: _controller.isCancelStep.value
                        ? Colors.blue
                        : Colors.black,
                  );
                },
                listenable: _controller.isCancelStep,
              ),
              label: "Back"),
          BottomNavigationBarItem(
              icon: ListenableBuilder(
                builder: (context, clid) {
                  return Image.asset(
                    width: 20,
                    height: 20,
                    "assets/icons/arrow_right.png",
                    color: _controller.isForwardStep.value
                        ? Colors.blue
                        : Colors.black,
                  );
                },
                listenable: _controller.isForwardStep,
              ),
              label: "Forward"),
        ],
        onTap: (value) async {
          if (value == 0) {
            _clear();
          } else if (value == 1) {
            _forward();
          }
          _currentIndex = value;
          setState(() {});
        },
      ),
    ));
  }
}
