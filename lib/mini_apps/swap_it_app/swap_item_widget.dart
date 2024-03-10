import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';

class SwapItemWidget extends StatelessWidget {
  final double padding;
  final double photoHeight;
  final double photoWidth;
  final double clipRadius;
  final double containerHeight;
  final double containerWidth;
  final String photoUrl;
  final Widget? child;

  const SwapItemWidget({
    super.key,
    this.padding = 0,
    required this.photoHeight,
    required this.photoWidth,
    required this.clipRadius,
    required this.containerHeight,
    required this.containerWidth,
    required this.photoUrl,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SizedBox(
            width: photoWidth,
            height: photoHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(clipRadius),
              child: PhotoWidget.network(photoUrl: photoUrl),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Colors.transparent, Colors.black54, Colors.black87, Colors.black],
                  stops: [0.1, 0.2, 0.4, 0.9],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              color: Colors.black45,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(clipRadius),
                bottomRight: Radius.circular(clipRadius),
              ),
            ),
            width: containerWidth,
            height: containerHeight,
            child: child,
          ),
        ],
      ),
    );
  }
}
