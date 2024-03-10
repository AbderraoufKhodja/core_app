import 'package:flutter/material.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

class PostImagePage extends StatelessWidget {
  const PostImagePage({
    super.key,
    required this.photoUrl,
    required this.photoUrl100x100,
    required this.photoUrl250x375,
    required this.photoUrl500x500,
  });

  final String? photoUrl;
  final String? photoUrl100x100;
  final String? photoUrl250x375;
  final String? photoUrl500x500;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(minHeight: size.width, maxHeight: size.height * 0.7),
      child: PhotoWidget.network(
        photoUrl: photoUrl,
        imageSize: PhotoCloudSize.medium,
        photoUrl100x100: photoUrl100x100,
        photoUrl250x375: photoUrl250x375,
        photoUrl500x500: photoUrl500x500,
        fit: BoxFit.fitWidth,
        canDisplay: true,
      ),
    );
  }
}
