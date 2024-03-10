import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/post/post_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/pages/post_report_page.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/widgets/post_bottom_bar.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/widgets/post_header_widget.dart';
import 'package:fibali/ui/pages/post_factory/post_factory_page.dart';
import 'package:fibali/ui/pages/user_profile_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class PostPage extends StatefulWidget {
  const PostPage({
    super.key,
    required this.post,
    required this.heroTag,
  });

  final Post post;
  final String? heroTag;

  @override
  State<PostPage> createState() => _PostPageState();

  static Future<dynamic>? show({
    String? postID,
    required Post? post,
    required String? heroTag,
  }) {
    if (post != null) {
      return Get.to(() => PostPage(post: post, heroTag: heroTag));
    } else if (postID != null) {
      EasyLoading.show(dismissOnTap: true);
      Post.ref.doc(postID).get().then((postDoc) {
        if (!postDoc.exists) {
          EasyLoading.dismiss();
          return Get.snackbar(
            RCCubit().getText(R.cantOpen),
            RCCubit().getText(R.postNotFound),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          EasyLoading.dismiss();
          return Get.to(() => PostPage(
                post: postDoc.data()!,
                heroTag: heroTag,
              ));
        }
      }).whenComplete(() => EasyLoading.dismiss());
    }

    return null;
  }
}

class _PostPageState extends State<PostPage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  PostBloc get postBloc => BlocProvider.of<PostBloc>(context);

  @override
  void initState() {
    postBloc.addViewPost(
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
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: PostBottomBar(post: widget.post),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: PopButton(color: Colors.grey.shade300),
        title: ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          onTap: () {
            UserProfilePage.showPage(userID: widget.post.uid!);
          },
          contentPadding: const EdgeInsets.only(left: 8.0),
          leading: PhotoWidgetNetwork(
            label: Utils.getInitial(widget.post.authorName),
            photoUrl: widget.post.authorPhoto,
            boxShape: BoxShape.circle,
            fit: BoxFit.cover,
            height: 40,
            width: 40,
          ),
          title: Text(
            widget.post.authorName ?? '',
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade300,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<String>(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.more_vert,
                color: Colors.grey.shade300,
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
                        postBloc.handleRemovePost(postID: widget.post.postID!);
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
                  if (!kIsWeb)
                    PopupMenuItem<String>(
                      value: null,
                      child: Text(RCCubit.instance.getText(R.share)),
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        postBloc.handleSharePost(post: widget.post);
                      },
                    ),
                ];
              },
            ),
          ),
        ],
      ),
      body: PostHeaderWidget(
        post: widget.post,
        percent: 0.5,
        heroTag: widget.heroTag,
      ),
    );
  }
}
