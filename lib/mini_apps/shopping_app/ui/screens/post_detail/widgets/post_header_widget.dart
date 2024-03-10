import 'package:badges/badges.dart' as bd;
import 'package:fibali/bloc/post/post_bloc.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/widgets.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/live/live_cubit.dart';
import 'package:fibali/ui/calls_module/presentation/screens/receiver_live_call_screen.dart';
import 'package:fibali/ui/widgets/chewie_video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PostHeaderWidget extends StatelessWidget {
  PostHeaderWidget({super.key, this.percent, required this.post, required this.heroTag});

  final double? percent;
  final Post post;
  final String? heroTag;

  // [enableOpenBookAnimation]
  // Validation to not apply the custom hero when going to the feed screen
  final ValueNotifier<bool> enableOpenBookAnimation = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final postBloc = BlocProvider.of<PostBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (post.postType == PostTypes.live.name)
          BlocProvider(
            create: (context) => LiveCubit(),
            child: ReceiverLiveScreen(post: post),
          )
        else if (post.videoUrl is String)
          ChewieVideoWidget(video: post.firebaseVideoUrl)
        else if (post.photoUrls?.isNotEmpty == true)
          DefaultTabController(
            length: post.photoUrls!.length,
            child: Container(
              color: Colors.black,
              height: Get.height,
              child: bd.Badge(
                position: bd.BadgePosition.custom(bottom: 10),
                badgeStyle: const bd.BadgeStyle(
                  shape: bd.BadgeShape.instagram,
                  badgeColor: Colors.transparent,
                  elevation: 0,
                ),
                showBadge: true,
                badgeContent: const TabPageSelector(
                  selectedColor: Colors.white70,
                  indicatorSize: 10,
                ),
                child: TabBarView(
                  children: post.photoUrls!.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final value = entry.value;
                    if (idx == 0) {
                      if (heroTag != null) {
                        return Hero(
                          tag: heroTag!,
                          child: PostImagePage(
                            photoUrl: value,
                            photoUrl100x100: post.getThumbnailUrl100x100(idx),
                            photoUrl250x375: post.getThumbnailUrl250x375(idx),
                            photoUrl500x500: post.getThumbnailUrl500x500(idx),
                          ),
                        );
                      } else {
                        return PostImagePage(
                          photoUrl: value,
                          photoUrl100x100: post.getThumbnailUrl100x100(idx),
                          photoUrl250x375: post.getThumbnailUrl250x375(idx),
                          photoUrl500x500: post.getThumbnailUrl500x500(idx),
                        );
                      }
                    }
                    return PostImagePage(
                      photoUrl: value,
                      photoUrl100x100: post.getThumbnailUrl100x100(idx),
                      photoUrl250x375: post.getThumbnailUrl250x375(idx),
                      photoUrl500x500: post.getThumbnailUrl500x500(idx),
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        else
          const SizedBox(height: 8),
      ],
    );
  }
}

class CategoryAndRate extends StatelessWidget {
  const CategoryAndRate({
    super.key,
    required this.post,
    required this.heroTag,
  });

  final Post post;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.tags?.join('/').toString() ?? '',
          style: const TextStyle(
            color: Colors.white70,
            height: 1.7,
          ),
          maxLines: 1,
        ),
        if (post.numLikes != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: PostLikes(
              like: post.numLikes!.toInt(),
              heroTag: const Uuid().v4(),
            ),
          ),
      ],
    );
  }
}
