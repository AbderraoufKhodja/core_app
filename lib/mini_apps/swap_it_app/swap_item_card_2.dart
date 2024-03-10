import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart' hide Image;

class SwapItemCard2 extends StatefulWidget {
  const SwapItemCard2({
    super.key,
    required this.swapItem,
    required this.heroTag,
  });

  final SwapItem swapItem;
  final String heroTag;

  @override
  State<SwapItemCard2> createState() => _SwapItemCard2State();
}

class _SwapItemCard2State extends State<SwapItemCard2>
    with AutomaticKeepAliveClientMixin<SwapItemCard2> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Hero(
      tag: widget.heroTag,
      child: Card(
        child: PhotoWidgetNetwork(
          label: null,
          photoUrl: widget.swapItem.photoUrls![0],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
