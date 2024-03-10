import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerItemCard extends StatelessWidget {
  const ShimmerItemCard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: Container(
        width: size.width * 0.5,
        height: size.height * 0.3,
        color: Colors.grey,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size.height * 0.008),
        ),
      ),
    );
  }
}
