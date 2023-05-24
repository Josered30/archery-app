import 'package:flutter/material.dart';

class LayoutPage extends StatefulWidget {
  final bool animate;
  final bool showBottomBar;
  final String title;

  final List<Widget> children;
  final List<BottomNavigationBarItem> bottomNavigationBarItems;

  const LayoutPage(
      {super.key,
      this.animate = false,
      this.showBottomBar = true,
      this.title = "",
      this.bottomNavigationBarItems = const [],
      required this.children});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage>
    with SingleTickerProviderStateMixin {
  late int currentIndex;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    currentIndex = 0;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut));

    if (widget.animate) {
      _controller.forward();
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey[200])),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back))
            : null,
      ),
      bottomNavigationBar: widget.showBottomBar
          ? BottomNavigationBar(
              items: widget.bottomNavigationBarItems,
              onTap: (index) {
                if (currentIndex == index) {
                  return;
                }

                if (!widget.animate) {
                  currentIndex = index;
                  return;
                }

                setState(() {
                  if (currentIndex < index) {
                    _offsetAnimation = Tween<Offset>(
                      begin: const Offset(1.5, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeInOut,
                    ));
                  } else {
                    _offsetAnimation = Tween<Offset>(
                      begin: const Offset(-1.5, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeInOut,
                    ));
                  }

                  _controller.reset();
                  _controller.forward();
                  currentIndex = index;
                });
              },
              currentIndex: currentIndex,
            )
          : null,
      body: widget.animate
          ? SlideTransition(
              position: _offsetAnimation, child: widget.children[currentIndex])
          : widget.children[currentIndex],
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
    );
  }
}
