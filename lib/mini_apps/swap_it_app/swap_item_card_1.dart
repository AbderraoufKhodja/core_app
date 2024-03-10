import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:uuid/uuid.dart';

import '../shopping_app/ui/widgets/post_likes.dart';

class SwapItemCard1 extends StatefulWidget {
  const SwapItemCard1({
    super.key,
    required this.swapItem,
    required this.heroTag,
  });

  final SwapItem swapItem;
  final String heroTag;

  @override
  State<SwapItemCard1> createState() => _SwapItemCard1State();
}

class _SwapItemCard1State extends State<SwapItemCard1>
    with AutomaticKeepAliveClientMixin<SwapItemCard1> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Hero(
            tag: widget.heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: PhotoWidgetNetwork(
                label: null,
                photoUrl: widget.swapItem.photoUrls![0],
                fit: BoxFit.fitWidth,
                loadingHeight: 200,
              ),
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
                      if (widget.swapItem.description != null)
                        Text(
                          widget.swapItem.description!,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              'By ${widget.swapItem.ownerName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(height: 1.7, color: Colors.white70),
                              maxLines: 1,
                            ),
                          ),
                          if (widget.swapItem.numLikes != null)
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: PostLikes(
                                like: widget.swapItem.numLikes!.toInt(),
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
    );
  }
}
