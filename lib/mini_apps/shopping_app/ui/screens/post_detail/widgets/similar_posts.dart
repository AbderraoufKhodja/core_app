import 'package:flutter/material.dart';
import 'package:fibali/fibali_core/models/post.dart';

class SimilarOtherPostsCard extends StatelessWidget {
  const SimilarOtherPostsCard({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(5, 5),
                  )
                ],
                image: DecorationImage(
                  image: NetworkImage(post.photoUrls![0]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 36,
            child: Text(
              post.description!,
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
