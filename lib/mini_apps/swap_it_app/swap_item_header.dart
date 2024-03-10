import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/swap_item/swap_item_bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_image_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_like_button.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_likes.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_likes_page.dart';
import 'package:fibali/ui/pages/swap_user_profile_page.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa_solid.dart';
import 'package:iconify_flutter/icons/fluent_emoji_high_contrast.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class SwapItemHeader extends StatelessWidget {
  SwapItemHeader({
    super.key,
    this.percent,
    required this.swapItem,
    required this.heroTag,
  });

  final double? percent;
  final SwapItem swapItem;
  final String? heroTag;

  // [enableOpenBookAnimation]
  // Validation to not apply the custom hero when going to the feed screen
  final ValueNotifier<bool> enableOpenBookAnimation = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final swapItemBloc = BlocProvider.of<SwapItemBloc>(context);
    final size = MediaQuery.of(context).size;

    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return Column(
      children: [
        if (swapItem.photoUrls?.isNotEmpty == true)
          DefaultTabController(
            length: swapItem.photoUrls!.length,
            child: Container(
              color: Colors.black87,
              height: size.height / 2,
              child: bd.Badge(
                position: bd.BadgePosition.custom(bottom: 10),
                badgeStyle: const bd.BadgeStyle(
                    shape: bd.BadgeShape.instagram, badgeColor: Colors.transparent, elevation: 0),
                showBadge: swapItem.photoUrls!.length > 1,
                badgeContent: const TabPageSelector(
                  selectedColor: Colors.white70,
                  indicatorSize: 10,
                ),
                child: bd.Badge(
                  position: bd.BadgePosition.bottomEnd(bottom: -5, end: 10),
                  badgeStyle: const bd.BadgeStyle(
                      shape: bd.BadgeShape.instagram, badgeColor: Colors.transparent, elevation: 0),
                  showBadge: true,
                  badgeContent: Row(
                    children: [
                      if ((swapItem.numLikes ?? 0) > 0)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 0,
                              )),
                          onPressed: () => SwapLikesPage.showPage(postID: swapItem.itemID!),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: FutureBuilder<QuerySnapshot<Like>>(
                                    future: Like.ref
                                        .where(
                                          LiLabels.type.name,
                                          isEqualTo: LiTypes.postItem.name,
                                        )
                                        .where(
                                          LiLabels.itemID.name,
                                          isEqualTo: swapItem.itemID,
                                        )
                                        .limit(3)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data?.docs.isNotEmpty == true) {
                                        return Stack(
                                          children: [
                                            ...snapshot.data!.docs.asMap().entries.map((entry) {
                                              final idx = entry.key;
                                              final doc = entry.value;
                                              return FutureBuilder<DocumentSnapshot<AppUser>>(
                                                future: AppUser.ref.doc(doc.data().uid).get(),
                                                builder: (context, snapshot) {
                                                  final user = snapshot.data?.data();
                                                  if (user?.photoUrl?.isNotEmpty == true) {
                                                    return Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 8.0 * idx,
                                                        ),
                                                        PhotoWidget.network(
                                                          photoUrl: user!.photoUrl!,
                                                          height: 20,
                                                          width: 20,
                                                          boxShape: BoxShape.circle,
                                                          border: Border.all(color: Colors.white70),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  return const SizedBox();
                                                },
                                              );
                                            })
                                          ],
                                        );
                                      }

                                      return const SizedBox();
                                    }),
                              ),

                              const Iconify(
                                Mdi.heart_multiple,
                                color: Colors.grey,
                                size: 16,
                              ), // widget
                              const SizedBox(width: 4),
                              Text(
                                '${swapItem.numLikes}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  child: TabBarView(
                    children: swapItem.photoUrls!.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final value = entry.value;
                      if (idx == 0) {
                        if (heroTag != null) {
                          return Hero(
                            tag: heroTag!,
                            child: SwapItemImagePage(swapItemImage: value),
                          );
                        } else {
                          return SwapItemImagePage(swapItemImage: value);
                        }
                      }
                      return SwapItemImagePage(swapItemImage: value);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                      onTap: () {
                        SwapUserProfilePage.showPage(userID: swapItem.uid!);
                      },
                      contentPadding: const EdgeInsets.only(left: 8.0),
                      leading: PhotoWidgetNetwork(
                        label: Utils.getInitial(swapItem.ownerName),
                        photoUrl: swapItem.ownerPhoto,
                        boxShape: BoxShape.circle,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                      title: Text(
                        swapItem.ownerName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                      subtitle: Text(swapItem.timestamp != null
                          ? timeago.format(swapItem.timestamp!.toDate())
                          : ''),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          if (!kIsWeb)
                            IconButton(
                              onPressed: () {
                                swapItemBloc.handleShareSwapItem(context, swapItem: swapItem);
                              },
                              icon: const Iconify(
                                Ph.share_network_light,
                                size: 25,
                                color: Colors.grey,
                              ),
                            ),
                          if (currentUser?.uid != null && currentUser?.uid != swapItem.uid)
                            SwapItemLikeButton(swapItem: swapItem),
                        ],
                      ),
                      Row(
                        children: [
                          if ((swapItem.numComments ?? 0) > 0)
                            Row(
                              children: [
                                Text(
                                  RCCubit.instance.getText(R.comments),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${swapItem.numComments}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          if ((swapItem.numViews ?? 0) > 0)
                            Row(
                              children: [
                                const Text(
                                  ' | ',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  RCCubit.instance.getText(R.views),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${swapItem.numViews}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              if (kDebugMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Iconify(
                                FaSolid.coins,
                                color: Colors.amberAccent,
                                size: 40,
                              ),
                              Text(
                                "",
                                // '${swapItem.price!.toStringAsFixed(2)} ${swapItem.currency ?? ''}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red.shade400,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Iconify(
                                FluentEmojiHighContrast.counterclockwise_arrows_button,
                                color: Colors.grey,
                                size: 40,
                              ),
                              Text(
                                "",
                                // '${swapItem.price!.toStringAsFixed(2)} ${swapItem.currency ?? ''}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red.shade400,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Iconify(
                                FluentEmojiHighContrast.delivery_truck,
                                color: Colors.grey,
                                size: 40,
                              ),
                              Text(
                                "",
                                // '${swapItem.price!.toStringAsFixed(2)} ${swapItem.currency ?? ''}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red.shade400,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Iconify(
                                FluentEmojiHighContrast.delivery_truck,
                                color: Colors.grey,
                                size: 40,
                              ),
                              Text(
                                "",
                                // '${swapItem.price!.toStringAsFixed(2)} ${swapItem.currency ?? ''}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red.shade400,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              if (swapItem.description != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      swapItem.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Divider()
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryAndRate extends StatelessWidget {
  const CategoryAndRate({
    super.key,
    required this.swapItem,
    required this.heroTag,
  });

  final SwapItem swapItem;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          swapItem.tags?.join('/').toString() ?? '',
          style: const TextStyle(
            color: Colors.white70,
            height: 1.7,
          ),
          maxLines: 1,
        ),
        if (swapItem.numLikes != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SwapItemLikes(
              like: swapItem.numLikes!.toInt(),
              heroTag: const Uuid().v4(),
            ),
          ),
      ],
    );
  }
}
