import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/post/post_bloc.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

class PostLikeButton extends StatefulWidget {
  const PostLikeButton({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  State<PostLikeButton> createState() => _PostLikeButtonState();
}

class _PostLikeButtonState extends State<PostLikeButton> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  PostBloc get _postBloc => BlocProvider.of<PostBloc>(context);

  @override
  Widget build(BuildContext context) {
    if (BlocProvider.of<AuthBloc>(context).auth.currentUser?.isAnonymous ?? true) {
      return IconButton(
        icon: const Iconify(
          Ph.heart_light,
          size: 25,
          color: Colors.grey,
        ),
        onPressed: () {
          BlocProvider.of<AuthBloc>(context).needLogIn();
        },
      );
    }

    final likesRef = _postBloc.likesRef.doc(_currentUser!.uid + widget.post.postID!);
    return StreamBuilder<DocumentSnapshot<Like>>(
      stream: likesRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.exists) {
            return IconButton(
              onPressed: () => _postBloc.handleRemoveLikePost(
                context,
                post: widget.post,
                currentUserID: _currentUser!.uid,
              ),
              icon: Iconify(
                Ph.heart_fill,
                color: Colors.red.shade400,
                size: 25,
              ),
            );
          } else {
            return IconButton(
              onPressed: () => _postBloc.handleLikePost(
                context,
                post: widget.post,
                currentUser: _currentUser!,
              ),
              icon: const Iconify(
                Ph.heart_light,
                size: 25,
                color: Colors.grey,
              ),
            );
          }
        }

        return IconButton(
          icon: Iconify(
            Ph.heart_fill,
            color: Colors.grey.shade200,
            size: 25,
          ),
          onPressed: null,
        );
      },
    );
  }
}
