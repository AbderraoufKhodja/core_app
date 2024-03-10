import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/relations/relations_bloc_builder.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/post_page.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fluent_emoji_high_contrast.dart';
import 'package:uuid/uuid.dart';

class LikedPostsTab extends StatefulWidget {
  const LikedPostsTab({super.key});

  @override
  State<LikedPostsTab> createState() => _LikedPostsTabState();
}

class _LikedPostsTabState extends State<LikedPostsTab>
    with AutomaticKeepAliveClientMixin<LikedPostsTab> {
  @override
  bool get wantKeepAlive => true;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RelationsCubitBuilder(onRelationsBuilder: (state) {
      final blockedRelations =
          RelationsCubit.getBlockedRelations(state: state, currentUserID: _currentUser!.uid);

      return FirestoreQueryBuilder<Like>(
        query: Like.ref
            .where(LiLabels.uid.name, isEqualTo: _currentUser!.uid)
            .where(LiLabels.type.name, isEqualTo: LiTypes.postItem.name)
            .orderBy(LiLabels.timestamp.name, descending: true),
        pageSize: 10,
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return LoadingGrid(width: Get.width - 24);
          }

          if (snapshot.hasError) {
            return Center(child: Text(RCCubit.instance.getText(R.oopsSomethingWentWrong)));
          }

          final filteredLikes = snapshot.docs
              .map((doc) => doc.data())
              .where(
                (like) => !(blockedRelations?.any((relation) => relation.uid == like.itemOwnerID) ??
                    false),
              )
              .where((like) => like.isValid());

          final widgets = filteredLikes.map(
            (like) {
              return FutureBuilder<DocumentSnapshot<Post>>(
                  future: Post.ref.doc(like.itemID).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return const SizedBox();

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }

                    if (snapshot.data?.data() != null) {
                      final isBlocked =
                          blockedRelations?.any((relation) => relation.uid == like.uid) ?? false;

                      if (isBlocked) {
                        return const SizedBox();
                      }

                      final post = snapshot.data!.data()!;
                      final heroTag = const Uuid().v4();
                      return GestureDetector(
                        onTap: () => PostPage.show(
                          post: post,
                          heroTag: heroTag,
                        ),
                        child: PostCard(
                          post: post,
                          heroTag: heroTag,
                        ),
                      );
                    }

                    return const SizedBox();
                  });
            },
          ).toList();

          if (widgets.isEmpty) {
            return DoubleCirclesWidget(
              title: RCCubit.instance.getText(R.noPostHere),
              description: RCCubit.instance.getText(R.likedPostsWillAppearHere),
              child: const Iconify(
                FluentEmojiHighContrast.flower_playing_cards,
                size: 80,
                color: Colors.grey,
              ),
            );
          }

          return MasonryGridView.count(
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight * 6),
            itemBuilder: (context, index) {
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                snapshot.fetchMore();
              }

              return widgets[index];
            },
            itemCount: widgets.length,
            crossAxisCount: 2,
          );
        },
      );
    });
  }
}
