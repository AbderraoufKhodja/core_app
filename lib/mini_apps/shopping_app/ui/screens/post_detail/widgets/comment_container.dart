import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/post/post_bloc.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/pages/comment_report_page.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/shopping_app/models/comment.dart';
import 'package:fibali/ui/pages/user_profile_page.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/uim.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentContainer extends StatefulWidget {
  const CommentContainer({
    super.key,
    required this.comment,
    required this.documentRef,
  });

  final Comment comment;
  final DocumentReference documentRef;

  @override
  State<CommentContainer> createState() => _CommentContainerState();
}

class _CommentContainerState extends State<CommentContainer>
    with AutomaticKeepAliveClientMixin<CommentContainer> {
  @override
  bool get wantKeepAlive => true;
  int pageSize = 2;

  Size get size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final String timeAgo =
        widget.comment.timestamp != null ? timeago.format(widget.comment.timestamp!.toDate()) : '';
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Card(
            elevation: 0,
            child: ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              horizontalTitleGap: 4,
              dense: true,
              leading: GestureDetector(
                onTap: () {
                  UserProfilePage.showPage(userID: widget.comment.senderID!);
                },
                child: PhotoWidgetNetwork(
                  label: Utils.getInitial(widget.comment.senderName),
                  photoUrl: widget.comment.senderPhoto ?? '',
                  boxShape: BoxShape.circle,
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                widget.comment.senderName!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.comment.text!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.comment.photoUrls?.isNotEmpty == true)
                    PhotoWidgetNetwork(
                      label: null,
                      photoUrl: widget.comment.photoUrls![0],
                      canDisplay: true,
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PopupMenuButton<String>(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.grey.shade400,
                      ),
                      itemBuilder: (context) {
                        return [
                          // if (currentUser?.uid != null && widget.comment.senderID == currentUser?.uid)
                          //   PopupMenuItem<String>(
                          //     value: null,
                          //     child: Text(RCCubit.instance.getText(R.edit)),
                          //     onTap: () async {
                          //       await Future.delayed(const Duration(milliseconds: 500));
                          //     },
                          //   ),
                          if (currentUser?.uid != null &&
                              widget.comment.senderID == currentUser?.uid)
                            PopupMenuItem<String>(
                              value: null,
                              child: Text(RCCubit.instance.getText(R.delete)),
                              onTap: () async {
                                await Future.delayed(const Duration(milliseconds: 500));
                                await widget.documentRef.delete();
                              },
                            ),
                          if (currentUser?.uid != null &&
                              widget.comment.senderID != currentUser?.uid)
                            PopupMenuItem<String>(
                              value: null,
                              child: Text(RCCubit.instance.getText(R.report)),
                              onTap: () async {
                                await Future.delayed(const Duration(milliseconds: 500));
                                CommentReportPage.show(
                                  reportedUserName: widget.comment.senderName!,
                                  reportedUserUID: widget.comment.senderID!,
                                  commentID: widget.comment.commentID!,
                                  documentRef: widget.documentRef,
                                );
                              },
                            ),
                        ];
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommentLikeButton(
                comment: widget.comment,
                documentRef: widget.documentRef,
              ),
              const SizedBox(width: 2),
              Text(
                '${widget.comment.numLikes}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                RCCubit.instance.getText(R.comments),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '${widget.comment.numComments}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    BottomSheet(
                      onClosing: () {},
                      builder: (context) => ReplyInput(
                        comment: widget.comment,
                        documentRef: widget.documentRef,
                      ),
                    ),
                  );
                },
                child: Text(
                  RCCubit.instance.getText(R.reply),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                timeAgo,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if ((widget.comment.numComments ?? 0) > 0)
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: FirestoreQueryBuilder(
                query: widget.documentRef.collection(commentsCollection).withConverter<Comment>(
                    fromFirestore: (snapshot, options) => Comment.fromFirestore(snapshot.data()!),
                    toFirestore: (value, options) => value.toFirestore()),
                pageSize: pageSize,
                builder: (context, snapshot, child) {
                  if (snapshot.isFetching) {
                    return const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                              strokeWidth: 2,
                            )),
                      ),
                    );
                  }
                  if (snapshot.docs.isNotEmpty) {
                    final comments = snapshot.docs.map((doc) => doc).toList();

                    return SizedBox(
                      child: Column(
                        children: [
                          ...comments.map(
                            (comment) => CommentContainer(
                              comment: comment.data(),
                              documentRef: comment.reference,
                            ),
                          ),
                          if (snapshot.isFetchingMore)
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.grey,
                                      strokeWidth: 2,
                                    )),
                              ),
                            )
                          else if (snapshot.hasMore)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (snapshot.docs.length > 2)
                                  Expanded(
                                    child: ReplyInput(
                                      comment: widget.comment,
                                      documentRef: widget.documentRef,
                                    ),
                                  ),
                                TextButton(
                                  onPressed: () {
                                    if (pageSize == 2) {
                                      setState(() {
                                        pageSize = 10;
                                      });
                                    } else {
                                      snapshot.fetchMore();
                                    }
                                  },
                                  child: Text(RCCubit.instance.getText(R.moreReplies)),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
        ],
      ),
    );
  }
}

class CommentLikeButton extends StatefulWidget {
  const CommentLikeButton({
    Key? key,
    required this.comment,
    required this.documentRef,
  }) : super(key: key);

  final Comment comment;
  final DocumentReference documentRef;

  @override
  State<CommentLikeButton> createState() => _CommentLikeButtonState();
}

class _CommentLikeButtonState extends State<CommentLikeButton> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  PostBloc get _postBloc => BlocProvider.of<PostBloc>(context);

  @override
  Widget build(BuildContext context) {
    final likesRef = _postBloc.likesRef.doc(_currentUser!.uid + widget.comment.commentID!);

    return StreamBuilder<DocumentSnapshot<Like>>(
      stream: likesRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.exists) {
            return GestureDetector(
              onTap: () => _postBloc.handleRemoveLikeComment(
                context,
                comment: widget.comment,
                documentRef: widget.documentRef,
                currentUserID: _currentUser!.uid,
              ),
              child: Iconify(
                Ph.heart_fill,
                color: Colors.red.shade400,
                size: 15,
              ),
            );
          } else {
            return GestureDetector(
              onTap: () => _postBloc.handleLikeComment(
                context,
                comment: widget.comment,
                documentRef: widget.documentRef,
                currentUser: _currentUser!,
              ),
              child: const Iconify(
                Ph.heart_bold,
                size: 15,
                color: Colors.grey,
              ),
            );
          }
        }

        return Iconify(
          Ph.heart_fill,
          color: Colors.grey.shade200,
          size: 20,
        );
      },
    );
  }
}

class ReplyInput extends StatefulWidget {
  const ReplyInput({
    super.key,
    required this.comment,
    required this.documentRef,
  });

  final Comment comment;
  final DocumentReference documentRef;

  @override
  State<ReplyInput> createState() => _ReplyInputState();
}

class _ReplyInputState extends State<ReplyInput> {
  final _textController = TextEditingController();

  List<XFile>? imageFiles;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  PostBloc get _postBloc => BlocProvider.of<PostBloc>(context);

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (imageFiles?.isNotEmpty == true)
            SizedBox(
              height: kBottomNavigationBarHeight * 1.5,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 8),
                      children: imageFiles!.map(
                        (image) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: kIsWeb
                                  ? PhotoWidgetNetwork(
                                      label: null,
                                      photoUrl: image.path,
                                      fit: BoxFit.fitWidth,
                                      height: 50,
                                      width: 50,
                                    )
                                  : PhotoWidget.file(
                                      file: File(image.path),
                                      fit: BoxFit.fitWidth,
                                      height: 50,
                                      width: 50,
                                    ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        imageFiles = null;
                      });
                    },
                    child: Text(RCCubit.instance.getText(R.cancel)),
                  ),
                ],
              ),
            ),
          TextField(
            controller: _textController,
            autofocus: false,
            maxLength: 500,
            decoration: InputDecoration(
              counterStyle: const TextStyle(
                height: double.minPositive,
              ),
              counterText: "",
              suffixIcon: IconButton(
                onPressed: () {
                  SettingsCubit.handlePickMultiGalleryCamera(
                    maxNumWarning: RCCubit().getText(R.sixImagesMax),
                    onImagesSelected: (images) {
                      setState(() {
                        imageFiles = images;
                      });
                    },
                  );
                },
                icon: const Iconify(
                  Uim.image_v,
                  color: Colors.black54,
                  size: 30,
                ),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: RCCubit.instance.getText(R.addComment),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
            keyboardType: TextInputType.text,
            onSubmitted: (commentText) async {
              if (commentText.trim().isNotEmpty) {
                await _postBloc.handleAddCommentReply(
                  context,
                  currentUser: _currentUser!,
                  documentRef: widget.documentRef,
                  comment: widget.comment,
                  photos: imageFiles,
                  commentText: commentText.trim(),
                );
                _textController.clear();
                if (imageFiles != null) {
                  setState(() {
                    imageFiles = null;
                  });
                }
              }
            },
            maxLines: 4,
            minLines: 1,
          ),
        ],
      ),
    );
  }
}
