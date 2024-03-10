import 'package:badges/badges.dart';
import 'package:fibali/fibali_core/models/live_event.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart' hide Image, Badge;
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'post_likes.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.heroTag,
  });

  final Post post;
  final String heroTag;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with AutomaticKeepAliveClientMixin<PostCard> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Badge(
      showBadge: widget.post.postType == PostTypes.video.name ||
          widget.post.postType == PostTypes.live.name,
      badgeContent: Icon(
        widget.post.postType == PostTypes.video.name
            ? Icons.play_arrow_rounded
            : Icons.live_tv_rounded,
        size: 34,
        color: widget.post.lastLiveEvent?[LELabels.status.name] == LiveEventStatus.onGoing.name
            ? Colors.amber
            : Colors.white70,
      ),
      position: BadgePosition.topStart(top: 10, start: 10),
      badgeStyle: const BadgeStyle(
        padding: EdgeInsets.all(0.0),
        badgeColor: Colors.transparent,
      ),
      child: Card(
        margin: const EdgeInsets.all(0.0),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Hero(
              tag: widget.heroTag,
              child: PhotoWidget.network(
                width: Get.width / 2,
                imageSize: PhotoCloudSize.small,
                photoUrl: widget.post.photoUrls?[0],
                photoUrl100x100: widget.post.getThumbnailUrl100x100(0),
                photoUrl250x375: widget.post.getThumbnailUrl250x375(0),
                photoUrl500x500: widget.post.getThumbnailUrl500x500(0),
                fit: BoxFit.fitWidth,
                loadingHeight: 200,
                loadingWidth: Get.width / 2,
              ),
            ),
            Positioned.fill(
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.black26,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.post.description != null)
                          Text(
                            widget.post.description!,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.white,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.post.authorName != null)
                              Expanded(
                                child: Text(
                                  widget.post.authorName!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(height: 1.7, color: Colors.white70),
                                  maxLines: 1,
                                ),
                              ),
                            if (widget.post.numLikes != null)
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: PostLikes(
                                  like: widget.post.numLikes!.toInt(),
                                  heroTag: const Uuid().v4(),
                                  fontSize: 10,
                                  iconSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
