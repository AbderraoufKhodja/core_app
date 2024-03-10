import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerChatTile extends StatelessWidget {
  const ShimmerChatTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.height * 0.02),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipOval(
                    child: SizedBox(
                      height: size.height * 0.06,
                      width: size.height * 0.06,
                      child: const CircleAvatar(),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: size.width / 10,
                        height: size.width / 30,
                        color: Colors.grey[300]!,
                      ),
                      SizedBox(height: size.width / 60),
                      Container(
                        width: size.width / 5,
                        height: size.width / 35,
                        color: Colors.grey[300]!,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: size.width / 4,
                height: size.width / 30,
                color: Colors.grey[300]!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
