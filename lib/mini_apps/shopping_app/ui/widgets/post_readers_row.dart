import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikesRow extends StatelessWidget {
  const LikesRow({
    super.key,
    required this.post,
    this.avatarSize = 30,
  });

  final Post post;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return FirestoreQueryBuilder<Like>(
      query: Like.ref.where(LiLabels.friends.name, arrayContains: currentUser!.uid),
      pageSize: 10,
      builder: (context, snapshot, _) {
        if (snapshot.docs.isNotEmpty == true) {
          final likes = snapshot.docs;
          final hasUserExcess = likes.length > 4;

          return Row(
            children: List.generate(
              hasUserExcess ? 4 : likes.length,
              (index) {
                return FutureBuilder<DocumentSnapshot<AppUser>>(
                  future: AppUser.ref.doc(likes[index].data().uid!).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return const SizedBox();

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: avatarSize,
                        color: Colors.black26,
                        width: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      );
                    }

                    if (snapshot.data?.data() != null) {
                      final user = snapshot.data!.data()!;

                      return Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: .7,
                        child: Container(
                          height: avatarSize,
                          width: avatarSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                            image: DecorationImage(
                              image: NetworkImage(user.photoUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: index == 3
                              ? Container(
                                  height: avatarSize,
                                  width: avatarSize,
                                  clipBehavior: Clip.antiAlias,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(avatarSize),
                                  ),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                                    child: Text(
                                      '${post.numLikes!.toInt() - 3}+',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
