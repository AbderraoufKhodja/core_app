import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/relations/relations_bloc_builder.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/post_horizontal_card.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/post_page.dart';
import 'package:fibali/ui/widgets/stream_firestore_query_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fluent_emoji_high_contrast.dart';
import 'package:uuid/uuid.dart';

class FollowTab extends StatefulWidget {
  const FollowTab({Key? key}) : super(key: key);

  @override
  State<FollowTab> createState() => _FollowTabState();
}

class _FollowTabState extends State<FollowTab> with AutomaticKeepAliveClientMixin<FollowTab> {
  @override
  bool get wantKeepAlive => true;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 4.0, top: 16),
      child: RelationsCubitBuilder(onRelationsBuilder: (state) {
        final blockedRelations =
            RelationsCubit.getBlockedRelations(state: state, currentUserID: _currentUser!.uid);

        return StreamFirestoreServerCacheQueryBuilder<Post>(
          query: Post.followingRef(userID: _currentUser!.uid)
              .orderBy(PoLabels.timestamp.name, descending: true),
          loader: (context, snapshot) {
            return LoadingGrid(width: Get.width - 16);
          },
          emptyBuilder: (context, snapshot) {
            return DoubleCirclesWidget(
              title: RCCubit.instance.getText(R.noPostHere),
              description: RCCubit.instance.getText(R.followOtherUsersAndGetUpdated),
              child: const Iconify(
                FluentEmojiHighContrast.flower_playing_cards,
                size: 80,
                color: Colors.grey,
              ),
            );
          },
          builder: (context, snapshot, _) {
            if (snapshot.docs.isNotEmpty == true) {
              final widgets = snapshot.docs
                  .map((doc) => doc.data())
                  .where(
                    (post) =>
                        !(blockedRelations?.any((relation) => relation.uid == post.uid) ?? false),
                  )
                  .map(
                (postRecord) {
                  final thisPost = postRecord;

                  final heroTag = const Uuid().v4();
                  return GestureDetector(
                    onTap: () => PostPage.show(
                      post: thisPost,
                      heroTag: heroTag,
                    ),
                    child: PostHorizontalCard(
                      post: thisPost,
                      heroTag: heroTag,
                    ),
                  );
                },
              ).toList();

              if (widgets.isEmpty) {
                return DoubleCirclesWidget(
                  title: RCCubit.instance.getText(R.noPostHere),
                  description: RCCubit.instance.getText(R.followOtherUsersAndGetUpdated),
                  child: const Iconify(
                    FluentEmojiHighContrast.flower_playing_cards,
                    size: 80,
                    color: Colors.grey,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight * 6),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (snapshot.hasMore && index + 1 == widgets.length) {
                    snapshot.fetchMore();
                  }

                  return widgets[index];
                },
                itemCount: widgets.length,
              );
            }

            return const SizedBox();
          },
        );
      }),
    );
  }
}
