import 'package:flutter/material.dart';

class LayoutPage extends StatefulWidget {
  final Widget child;
  final bool showBottomBar;
  final String title;

  const LayoutPage(
      {super.key,
      this.showBottomBar = true,
      this.title = "",
      required this.child});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Navigator.canPop(context)
            ? IconButton(
                color: Colors.grey[900],
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey[200])),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back))
            : null,
      ),
      bottomNavigationBar: widget.showBottomBar
          ? BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.adjust), label: "Configuration")
              ],
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              currentIndex: currentIndex,
            )
          : null,
      body: widget.child,
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
    );
  }
}
