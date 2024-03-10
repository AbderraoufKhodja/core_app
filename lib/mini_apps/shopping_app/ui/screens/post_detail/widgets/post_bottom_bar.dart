import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/widgets/comment_input.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/widgets/post_comments_button.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/widgets/post_like_button.dart';
import 'package:fibali/ui/likes_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostBottomBar extends StatefulWidget {
  const PostBottomBar({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  State<PostBottomBar> createState() => _PostBottomBarState();
}

class _PostBottomBarState extends State<PostBottomBar> {
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        onExpansionChanged: (value) {
          setState(() {
            isCollapsed = !value;
          });
        },
        trailing: SizedBox.square(
          dimension: 40,
          child: Stack(
            fit: StackFit.loose,
            children: [
              Positioned(
                top: -8,
                child: isCollapsed
                    ? Icon(
                        Icons.expand_less,
                        color: Colors.grey.shade300,
                        size: 36,
                      )
                    : Icon(
                        Icons.expand_more,
                        color: Colors.grey.shade300,
                        size: 36,
                      ),
              ),
            ],
          ),
        ),
        title: isCollapsed
            ? Padding(
                padding: const EdgeInsets.only(bottom: 64.0),
                child: CommentInput(
                  post: widget.post,
                  fillColor: Colors.white38,
                ),
              )
            : const SizedBox(),
        children: [
          BottomAppBar(
            padding: const EdgeInsets.all(16.0),
            color: Colors.transparent,
            child: _buildBottomBarChild(),
          ),
        ],
      ),
    );
  }

  Column _buildBottomBarChild() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.white70),
        if (widget.post.description != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height * 0.5),
              child: SingleChildScrollView(
                child: ReadMoreText(
                  widget.post.description!,
                  trimLines: 3,
                  colorClickableText: Colors.grey,
                  trimMode: TrimMode.Line,
                  textAlign: TextAlign.start,
                  trimCollapsedText: " ${RCCubit().getText(R.readMore)}",
                  trimExpandedText: " ${RCCubit().getText(R.showLess)}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (widget.post.timestamp != null)
                  Row(
                    children: [
                      Text(
                        timeago.format(widget.post.timestamp!.toDate()),
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        " | ",
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                Text(
                  RCCubit.instance.getText(R.views),
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.post.numViews}',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // if (!kIsWeb)
                //   IconButton(
                //     onPressed: () {
                //       postBloc.handleSharePost(context, post: post);
                //     },
                //     icon: const Iconify(
                //       Ph.share_network_light,
                //       size: 25,
                //       color: Colors.white,
                //     ),
                //   ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                  ),
                  onPressed: () => LikesPage.showPage(postID: widget.post.postID!),
                  child: FutureBuilder<QuerySnapshot<Like>>(
                      future: Like.ref
                          .where(
                            LiLabels.type.name,
                            isEqualTo: LiTypes.postItem.name,
                          )
                          .where(
                            LiLabels.itemID.name,
                            isEqualTo: widget.post.postID,
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
                                          SizedBox(width: 8.0 * idx),
                                          PhotoWidget.network(
                                            photoUrl: user!.photoUrl!,
                                            height: 22,
                                            width: 22,
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
                if ((widget.post.numLikes ?? 0) > 0)
                  Text(
                    '${widget.post.numLikes}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                PostLikeButton(post: widget.post),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Flexible(
                child: CommentInput(
              post: widget.post,
              fillColor: Colors.white54,
            )),
            SizedBox(
              height: 58,
              width: 58,
              child: PostCommentsButton(post: widget.post),
            ),
            if ((widget.post.numComments ?? 0) > 0)
              Text(
                '${widget.post.numComments}',
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
