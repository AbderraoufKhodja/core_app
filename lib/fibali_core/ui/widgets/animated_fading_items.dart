import 'dart:async';

import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';

class AnimatedFadingItems extends StatefulWidget {
  const AnimatedFadingItems({
    required this.urls,
    this.shape = BoxShape.circle,
    this.height,
    this.width,
  });

  final List<dynamic> urls;
  final shape;
  final double? height;
  final double? width;

  @override
  _AnimatedFadingItemsState createState() => _AnimatedFadingItemsState();
}

class _AnimatedFadingItemsState extends State<AnimatedFadingItems> {
  late Timer _timer;

  int _currentIndex = 0;

  Size get size => MediaQuery.of(context).size;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (mounted) {
        setState(() {
          if (_currentIndex + 1 == widget.urls.length) {
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
      duration: const Duration(seconds: 1),
      transitionBuilder: (Widget child, Animation<double> animation) =>
          FadeTransition(opacity: animation, child: child),
      child: PhotoWidget.network(
        boxShape: widget.shape,
        photoUrl: widget.urls[_currentIndex],
        fit: BoxFit.fill,
        key: ValueKey<int>(_currentIndex),
        height: widget.height,
        width: widget.width,
      ),
    );
  }
}
