import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/bloc/post/post_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/favorite.dart';
import 'package:fibali/fibali_core/models/post.dart';

class PostFavoriteButton extends StatefulWidget {
  const PostFavoriteButton({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  State<PostFavoriteButton> createState() => _PostFavoriteButtonState();
}

class _PostFavoriteButtonState extends State<PostFavoriteButton> with TickerProviderStateMixin {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  PostBloc get _postBloc => BlocProvider.of<PostBloc>(context);
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRef = Favorite.ref.doc(_currentUser!.uid + widget.post.postID!);

    return StreamBuilder<DocumentSnapshot<Favorite>>(
      stream: favoriteRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.exists) {
            return IconButton(
              onPressed: () => _postBloc.handleRemoveFavoritePost(
                context,
                post: widget.post,
                currentUserID: _currentUser!.uid,
              ),
              icon: const Iconify(Ph.star_fill, size: 25, color: Colors.amber),
            );
          } else {
            return IconButton(
              onPressed: () => _postBloc.handleAddFavoritePost(
                context,
                post: widget.post,
                currentUserID: _currentUser!.uid,
                photo: widget.post.photoUrls![0],
              ),
              icon: const Iconify(Ph.star_light, size: 25),
            );
          }
        }

        return const Iconify(Ph.star_fill, size: 25);
      },
    );
  }
}
