import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/relations/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/models/relation.dart';
import 'package:fibali/fibali_core/models/view_item.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/post_page.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/post_likes.dart';
import 'package:fibali/ui/widgets/stream_firestore_query_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fluent_emoji_high_contrast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class PostsHistoryViewTab extends StatefulWidget {
  const PostsHistoryViewTab({super.key});

  @override
  State<PostsHistoryViewTab> createState() => _PostsHistoryViewTabState();
}

class _PostsHistoryViewTabState extends State<PostsHistoryViewTab> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  RelationsCubit get _relationsCubit => BlocProvider.of<RelationsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RelationsCubit, RelationsState>(
      buildWhen: (previous, current) => previous is RelationsLoading && current is RelationsLoaded,
      builder: (context, state) {
        if (state is RelationsInitial) {
          _relationsCubit.loadRelations(userID: _currentUser!.uid);
        }

        if (state is RelationsLoading) {
          return const SizedBox();
        }

        if (state is RelationsLoaded) {
          return StreamFirestoreServerCacheQueryBuilder<ViewItem>(
            query: ViewItem.ref
                .where(VLabels.uid.name, isEqualTo: _currentUser!.uid)
                .where(VLabels.type.name, isEqualTo: VTypes.post.name)
                .orderBy(VLabels.timestamp.name, descending: true),
            loader: (context, snapshot) {
              return LoadingGrid(width: Get.width - 16);
            },
            emptyBuilder: (context, snapshot) {
              return DoubleCirclesWidget(
                title: RCCubit.instance.getText(R.noPostHere),
                description: RCCubit.instance.getText(R.viewedPostsWillAppearHere),
                child: const Iconify(
                  FluentEmojiHighContrast.flower_playing_cards,
                  size: 80,
                  color: Colors.grey,
                ),
              );
            },
            builder: (context, snapshot2, _) {
              if (snapshot2.docs.isNotEmpty == true) {
                final listSizedItems = snapshot2.docs.map((doc) => doc.data()).map(
                  (view) {
                    final isFriend = state.relations
                        ?.any((doc) => doc.uid == view.uid && doc.type == ReTypes.friends.name);

                    return Post.ref
                        .where(PoLabels.postID.name, isEqualTo: view.itemID!)
                        .where(PoLabels.privacy.name, whereIn: [
                          PostPrivacyType.public.name,
                          PostPrivacyType.followers.name,
                          if (isFriend == true) PostPrivacyType.followers.name,
                        ])
                        .limit(1)
                        .get();
                  },
                ).toList();

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight * 6),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (snapshot2.hasMore && index + 1 == snapshot2.docs.length) {
                      snapshot2.fetchMore();
                    }

                    return _PersistentPostWidget(futureItem: listSizedItems[index]);
                  },
                  itemCount: listSizedItems.length,
                );
              }
              return const SizedBox();
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _PersistentPostWidget extends StatefulWidget {
  const _PersistentPostWidget({
    Key? key,
    required this.futureItem,
  }) : super(key: key);

  final Future<QuerySnapshot<Post>> futureItem;

  @override
  State<_PersistentPostWidget> createState() => _PersistentPostWidgetState();
}

class _PersistentPostWidgetState extends State<_PersistentPostWidget>
    with AutomaticKeepAliveClientMixin<_PersistentPostWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<QuerySnapshot<Post>>(
        future: widget.futureItem,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: HorizontalPostCard.shimmer(),
            );
          }

          if (snapshot.data?.docs.isNotEmpty == true) {
            if (snapshot.data?.docs.first.data().isValid() == true) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: HorizontalPostCard(post: snapshot.data!.docs.first.data()),
              );
            }
          }

          return const SizedBox();
        });
  }
}

class HorizontalPostCard extends StatefulWidget {
  const HorizontalPostCard({super.key, required this.post, this.isShimmer});

  final Post? post;
  final bool? isShimmer;

  factory HorizontalPostCard.shimmer() => const HorizontalPostCard(post: null, isShimmer: true);

  @override
  State<HorizontalPostCard> createState() => _HorizontalPostCardState();
}

class _HorizontalPostCardState extends State<HorizontalPostCard> {
  @override
  Widget build(BuildContext context) {
    return widget.isShimmer == true
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: _buildPost(),
          )
        : _buildPost();
  }

  Widget _buildPost() {
    return InkWell(
      onTap: () {
        final heroTag = const Uuid().v4();
        PostPage.show(post: widget.post!, postID: null, heroTag: heroTag);
      },
      child: SizedBox(
        height: 100,
        child: Card(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              if (widget.post?.photoUrls?.isNotEmpty == true)
                PhotoWidget.network(
                  width: Get.width,
                  imageSize: PhotoCloudSize.small,
                  photoUrl: widget.post!.photoUrls?[0],
                  photoUrl100x100: widget.post!.getThumbnailUrl100x100(0),
                  photoUrl250x375: widget.post!.getThumbnailUrl250x375(0),
                  photoUrl500x500: widget.post!.getThumbnailUrl500x500(0),
                  fit: BoxFit.fitWidth,
                  loadingHeight: 100,
                  loadingWidth: Get.width,
                )
              else
                Image.asset(
                  'assets/launcher_icon.jpg',
                  fit: BoxFit.fitWidth,
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.black26,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.post?.description?.isNotEmpty == true)
                          Text(
                            widget.post!.description!,
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
                                'By ${widget.post?.authorName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(height: 1.7, color: Colors.white70),
                                maxLines: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: widget.post?.numLikes != null
                                  ? PostLikes(
                                      like: widget.post!.numLikes!.toInt(),
                                      heroTag: widget.post?.postID,
                                      fontSize: 10,
                                      iconSize: 10,
                                    )
                                  : const Row(
                                      children: [
                                        FaIcon(
                                          FontAwesome.heart,
                                          color: Colors.white70,
                                          size: 10,
                                        ),
                                        Text(
                                          ' 000',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
