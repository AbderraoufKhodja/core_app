import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/post/post_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:fibali/fibali_core/models/live_event.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/widgets.dart';
import 'package:fibali/ui/likes_page.dart';
import 'package:fibali/ui/pages/user_profile_page.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:uuid/uuid.dart';

class HorizontalPostHeaderWidget extends StatelessWidget {
  HorizontalPostHeaderWidget({super.key, this.percent, required this.post, required this.heroTag});

  final double? percent;
  final Post post;
  final String? heroTag;

  // [enableOpenBookAnimation]
  // Validation to not apply the custom hero when going to the feed screen
  final ValueNotifier<bool> enableOpenBookAnimation = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final postBloc = BlocProvider.of<PostBloc>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          if (post.photoUrls?.isNotEmpty == true)
            Badge(
              showBadge:
                  post.postType == PostTypes.video.name || post.postType == PostTypes.live.name,
              badgeContent: Icon(
                post.postType == PostTypes.video.name
                    ? Icons.play_arrow_rounded
                    : Icons.live_tv_rounded,
                size: 34,
                color: post.lastLiveEvent?[LELabels.status.name] == LiveEventStatus.onGoing.name
                    ? Colors.amber
                    : Colors.white70,
              ),
              position: BadgePosition.topStart(top: 10, start: 10),
              badgeStyle: const BadgeStyle(
                padding: EdgeInsets.all(0.0),
                badgeColor: Colors.transparent,
              ),
              child: SizedBox(
                height: Get.height / 3,
                child: Badge(
                  position: BadgePosition.custom(bottom: 10),
                  badgeStyle: const BadgeStyle(
                    shape: BadgeShape.instagram,
                    badgeColor: Colors.transparent,
                    elevation: 0,
                  ),
                  showBadge: (post.photoUrls?.length ?? 0) > 1,
                  badgeContent: Icon(
                    FluentIcons.image_multiple_48_filled,
                    color: Colors.grey.shade300,
                  ),
                  child: Badge(
                    position: BadgePosition.bottomEnd(bottom: -5, end: 10),
                    badgeStyle: const BadgeStyle(
                      shape: BadgeShape.instagram,
                      badgeColor: Colors.transparent,
                      elevation: 0,
                    ),
                    showBadge: true,
                    badgeContent: Row(
                      children: [
                        if ((post.numLikes ?? 0) > 0)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 0,
                                )),
                            onPressed: () => LikesPage.showPage(postID: post.postID!),
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
                                            isEqualTo: post.postID,
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
                                                            border:
                                                                Border.all(color: Colors.white70),
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
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                // widget
                                const SizedBox(width: 4),
                                Text(
                                  '${post.numLikes}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    child: post.photoUrls!.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final value = entry.value;
                      if (idx == 0) {
                        if (heroTag != null) {
                          return Hero(
                            tag: heroTag!,
                            child: PhotoWidget.network(
                              photoUrl: value,
                              imageSize: PhotoCloudSize.medium,
                              photoUrl100x100: post.getThumbnailUrl100x100(idx),
                              photoUrl250x375: post.getThumbnailUrl250x375(idx),
                              photoUrl500x500: post.getThumbnailUrl500x500(idx),
                              fit: BoxFit.cover,
                              width: Get.width,
                            ),
                          );
                        } else {
                          return PhotoWidget.network(
                            photoUrl: value,
                            imageSize: PhotoCloudSize.medium,
                            photoUrl100x100: post.getThumbnailUrl100x100(idx),
                            photoUrl250x375: post.getThumbnailUrl250x375(idx),
                            photoUrl500x500: post.getThumbnailUrl500x500(idx),
                            fit: BoxFit.cover,
                            width: Get.width,
                          );
                        }
                      }

                      return PhotoWidget.network(
                        photoUrl: value,
                        fit: BoxFit.cover,
                        width: Get.width,
                      );
                    }).toList()[0],
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                      onTap: () {
                        UserProfilePage.showPage(userID: post.uid!);
                      },
                      contentPadding: const EdgeInsets.only(left: 8.0),
                      leading: PhotoWidgetNetwork(
                        label: Utils.getInitial(post.authorName),
                        photoUrl: post.authorPhoto,
                        boxShape: BoxShape.circle,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
                      title: Text(
                        post.authorName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: Get.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          children: [
                            if ((post.numComments ?? 0) > 0)
                              Row(
                                children: [
                                  Text(
                                    RCCubit.instance.getText(R.comments),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${post.numComments}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            if ((post.numViews ?? 0) > 0 && (post.numComments ?? 0) > 0)
                              const Text(
                                ' | ',
                                style: TextStyle(
                                  // fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            if ((post.numViews ?? 0) > 0)
                              Row(
                                children: [
                                  Text(
                                    RCCubit.instance.getText(R.views),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${post.numViews}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),

                      //  Text(
                      //     post.timestamp != null ? timeago.format(post.timestamp!.toDate()) : ''),
                    ),
                  ),
                ],
              ),
              if (post.description != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    post.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
            ],
          ),
        ],
      ),
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
