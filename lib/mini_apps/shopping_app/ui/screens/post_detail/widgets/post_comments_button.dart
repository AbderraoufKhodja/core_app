import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/mini_apps/shopping_app/models/comment.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/widgets/comment_container.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/widgets/comment_input.dart';
import 'package:firebase_ui_future_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';

class PostCommentsButton extends StatefulWidget {
  const PostCommentsButton({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  State<PostCommentsButton> createState() => _PostCommentsButtonState();
}

class _PostCommentsButtonState extends State<PostCommentsButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.to(() {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: const PopButton(color: Colors.grey),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            body: FirestoreQueryBuilder<Comment>(
              query: Comment.ref(postID: widget.post.postID!)
                  .orderBy(ComLabels.timestamp.name, descending: true),
              pageSize: 10,
              builder: (context, snapshot, _) {
                final widgets = [
                  if (snapshot.docs.isNotEmpty)
                    ...snapshot.docs.where((doc) => doc.data().isValid()).map(
                      (doc) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CommentContainer(
                            comment: doc.data(),
                            documentRef: doc.reference,
                          ),
                        );
                      },
                    ).toList(),
                  if (snapshot.docs.length > 2) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CommentInput(post: widget.post),
                    ),
                  ],
                ];

                if (widgets.isEmpty) {
                  return Center(
                    child: DoubleCirclesWidget(
                      title: RCCubit().getText(R.noComments),
                      description: '',
                      child: const Iconify(
                        Carbon.chat,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemCount: widgets.length,
                  itemBuilder: (context, index) {
                    if (snapshot.hasMore && index + 1 == widgets.length) {
                      snapshot.fetchMore();
                    }
                    return widgets[index];
                  },
                );
              },
            ),
          );
        });
      },
      icon: const Iconify(
        Carbon.chat,
        size: 50,
        color: Colors.white60,
      ),
    );
  }
}
