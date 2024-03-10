import 'package:extended_image/extended_image.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';

class PhotoViewPage extends StatelessWidget {
  // you can handle gesture detail by yourself with key
  final gestureKey = GlobalKey<ExtendedImageGestureState>();
  final String url;

  PhotoViewPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: PopButton(),
        backgroundColor: Colors.white70,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      backgroundColor: const Color(0xFF142526),
      body: Center(
        child: ExtendedImage.network(
          url,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.gesture,
          extendedImageGestureKey: gestureKey,
          initGestureConfigHandler: (ExtendedImageState state) {
            return GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 4.0,
              animationMaxScale: 4.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: false,
              initialAlignment: InitialAlignment.center,
              reverseMousePointerScrollDirection: true,
            );
          },
        ),
      ),
    );
  }
}

Future<void> showPhotoViewPage(BuildContext context, {required String url}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PhotoViewPage(url: url)),
  );
}
