import 'package:badges/badges.dart';
import 'package:fibali/fibali_core/models/live_event.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart' hide Image, Badge;
import 'package:get/get.dart';

import '../screens/post_detail/widgets/post_like_button.dart';

class DiscoverTabPostCard extends StatefulWidget {
  const DiscoverTabPostCard({
    super.key,
    required this.post,
    required this.heroTag,
  });

  final Post post;
  final String heroTag;

  @override
  State<DiscoverTabPostCard> createState() => _DiscoverTabPostCardState();
}

class _DiscoverTabPostCardState extends State<DiscoverTabPostCard>
    with AutomaticKeepAliveClientMixin<DiscoverTabPostCard> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: widget.heroTag,
          child: Badge(
            showBadge: widget.post.postType == PostTypes.video.name ||
                widget.post.postType == PostTypes.live.name,
            badgeContent: Icon(
              widget.post.postType == PostTypes.video.name
                  ? Icons.play_arrow_rounded
                  : Icons.live_tv_rounded,
              size: 34,
              color:
                  widget.post.lastLiveEvent?[LELabels.status.name] == LiveEventStatus.onGoing.name
                      ? Colors.amber
                      : Colors.white70,
            ),
            position: BadgePosition.topStart(top: 10, start: 10),
            badgeStyle: const BadgeStyle(
              padding: EdgeInsets.all(0.0),
              badgeColor: Colors.transparent,
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              margin: const EdgeInsets.all(0.0),
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
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.post.description != null)
                    Text(
                      widget.post.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (widget.post.authorName != null)
                    Text(
                      widget.post.authorName!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            height: 1.7,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: PostLikeButton(post: widget.post),
            ),
          ],
        ),
      ],
    );
  }
}
