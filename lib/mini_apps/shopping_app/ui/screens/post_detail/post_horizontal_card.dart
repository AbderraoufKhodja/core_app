import 'package:badges/badges.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/post/post_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/pages/post_report_page.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/widgets/horizontal_post_header_widget.dart';
import 'package:fibali/ui/pages/post_factory/post_factory_page.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class PostHorizontalCard extends StatefulWidget {
  const PostHorizontalCard({
    super.key,
    required this.post,
    required this.heroTag,
  });

  final Post post;
  final String? heroTag;

  @override
  State<PostHorizontalCard> createState() => _PostHorizontalCardState();

  static Future<dynamic>? show({
    String? postID,
    required Post? post,
    required String? heroTag,
  }) {
    if (post != null) {
      return Get.to(() => PostHorizontalCard(post: post, heroTag: heroTag));
    } else if (postID != null) {
      EasyLoading.show(dismissOnTap: true);
      Post.ref.doc(postID).get().then((postDoc) {
        EasyLoading.dismiss();
        if (postDoc.data() != null) {
          return Get.to(() => PostHorizontalCard(
                post: postDoc.data()!,
                heroTag: heroTag,
              ));
        }
      }).whenComplete(() => EasyLoading.dismiss());
    }

    return null;
  }
}

class _PostHorizontalCardState extends State<PostHorizontalCard> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  PostBloc get _postBloc => BlocProvider.of<PostBloc>(context);

  @override
  void initState() {
    _postBloc.addViewPost(
      photo: widget.post.photoUrls?[0],
      postID: widget.post.postID!,
      uid: _currentUser!.uid,
    );
    super.initState();
  }

  final dropdownMenuEntries = [
    const DropdownMenuEntry(value: 'report', label: 'Report'),
    const DropdownMenuEntry(value: 'share', label: 'Share'),
  ];

  @override
  Widget build(BuildContext context) {
    return Badge(
      badgeStyle: const BadgeStyle(
        padding: EdgeInsets.all(16.0),
        shape: BadgeShape.instagram,
        badgeColor: Colors.transparent,
        elevation: 0,
      ),
      badgeContent: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PopupMenuButton<String>(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.more_horiz,
            color: Colors.grey.shade400,
          ),
          itemBuilder: (context) {
            return [
              if (_currentUser?.uid == widget.post.uid)
                PopupMenuItem<String>(
                  value: null,
                  child: Text(RCCubit.instance.getText(R.edit)),
                  onTap: () {
                    Get.back();
                    showPostFactoryPage(
                      currentUser: _currentUser!,
                      postID: widget.post.postID,
                    );
                  },
                ),
              if (_currentUser?.uid == widget.post.uid)
                PopupMenuItem<String>(
                  value: null,
                  child: Text(RCCubit.instance.getText(R.delete)),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 500));
                    _postBloc.handleRemovePost(postID: widget.post.postID!);
                  },
                ),
              if (_currentUser?.uid != null && widget.post.uid != _currentUser?.uid)
                PopupMenuItem<String>(
                  value: null,
                  child: Text(RCCubit.instance.getText(R.report)),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 500));
                    PostReportPage.showPage(
                      reportedUserName: widget.post.authorName!,
                      reportedUserUID: widget.post.uid!,
                      postID: widget.post.postID!,
                    );
                  },
                ),
            ];
          },
        ),
      ),
      child: HorizontalPostHeaderWidget(
        post: widget.post,
        percent: 0.5,
        heroTag: widget.heroTag,
      ),
    );
  }
}
