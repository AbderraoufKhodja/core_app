import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedLogInBackground extends StatefulWidget {
  final paths = [
    'assets/items_1.jpg',
    'assets/items_2.jpg',
    'assets/items_3.jpg',
    'assets/items_4.jpg',
    'assets/items_5.jpg',
  ];

  AnimatedLogInBackground({super.key});

  @override
  AnimatedLogInBackgroundState createState() => AnimatedLogInBackgroundState();
}

class AnimatedLogInBackgroundState extends State<AnimatedLogInBackground> {
  late Timer _timer;

  int _currentIndex = 0;

  Size get size => MediaQuery.of(context).size;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (mounted) {
        setState(() {
          if (_currentIndex + 1 == widget.paths.length) {
            _currentIndex = 0;
          } else {
            _currentIndex = _currentIndex + 1;
          }
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 3),
      transitionBuilder: (Widget child, Animation<double> animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Image.asset(
        widget.paths[_currentIndex],
        height: size.height,
        width: size.width,
        fit: BoxFit.cover,
        key: ValueKey<int>(_currentIndex),
      ),
    );
  }
}
