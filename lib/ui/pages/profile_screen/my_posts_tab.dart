import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/post_page.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/post_card.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/ui/pages/post_factory/post_factory_page.dart';
import 'package:fibali/ui/widgets/stream_firestore_query_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fluent_emoji_high_contrast.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

class MyPostsTab extends StatefulWidget {
  const MyPostsTab({super.key});

  @override
  State<MyPostsTab> createState() => _MyPostsTabState();
}

class _MyPostsTabState extends State<MyPostsTab> with AutomaticKeepAliveClientMixin<MyPostsTab> {
  @override
  bool get wantKeepAlive => true;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamFirestoreServerCacheQueryBuilder<Post>(
      query: Post.ref
          .where(PoLabels.uid.name, isEqualTo: _currentUser!.uid)
          .orderBy(PoLabels.timestamp.name, descending: true),
      loader: (context, snapshot) {
        return LoadingGrid(width: Get.width - 16);
      },
      emptyBuilder: (context, snapshot) {
        return MaterialButton(
          onPressed: () {
            showPostFactoryPage(
              currentUser: _currentUser!,
              postID: null,
            );
          },
          child: DoubleCirclesWidget(
            title: RCCubit.instance.getText(R.noPostHere),
            description: RCCubit.instance.getText(R.addFirstPost),
            child: const Iconify(
              FluentEmojiHighContrast.flower_playing_cards,
              size: 80,
              color: Colors.grey,
            ),
          ),
        );
      },
      builder: (context, snapshot, _) {
        final widgets = snapshot.docs.map((doc) => doc.data()).where((post) => post.isValid()).map(
          (post) {
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
          },
        ).toList();

        if (widgets.isEmpty) {
          return MaterialButton(
            onPressed: () {
              showPostFactoryPage(
                currentUser: _currentUser!,
                postID: null,
              );
            },
            child: DoubleCirclesWidget(
              title: RCCubit.instance.getText(R.noPostHere),
              description: RCCubit.instance.getText(R.addFirstPost),
              child: const Iconify(
                FluentEmojiHighContrast.flower_playing_cards,
                size: 80,
                color: Colors.grey,
              ),
            ),
          );
        }

        return MasonryGridView.count(
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight * 6),
          itemBuilder: (context, index) {
            if (snapshot.hasMore && index + 1 == widgets.length) {
              snapshot.fetchMore();
            }

            return widgets[index];
          },
          itemCount: widgets.length,
          crossAxisCount: 2,
        );
      },
    );
  }
}
