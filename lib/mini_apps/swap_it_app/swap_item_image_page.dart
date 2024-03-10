import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';

class SwapItemImagePage extends StatelessWidget {
  const SwapItemImagePage({
    super.key,
    required this.swapItemImage,
  });

  final String? swapItemImage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (swapItemImage != null) {
          showPhotoViewPage(context, url: swapItemImage!);
        }
      },
      child: Container(
        constraints: BoxConstraints(minHeight: size.width, maxHeight: size.height * 0.7),
        child: PhotoWidget.network(
          photoUrl: swapItemImage,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class PhotoViewPage extends StatelessWidget {
  // you can handle gesture detail by yourself with key
  final gestureKey = GlobalKey<ExtendedImageGestureState>();
  final String url;

  PhotoViewPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        ExtendedImage.network(
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
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: PopButton(),
          ),
        ),
      ],
    );
  }
}

Future<void> showPhotoViewPage(BuildContext context, {required String url}) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PhotoViewPage(url: url)),
  );
}
