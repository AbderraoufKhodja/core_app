import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/widgets/comment_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CommentPostButton extends StatelessWidget {
  const CommentPostButton({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (BlocProvider.of<AuthBloc>(context).auth.currentUser?.isAnonymous ?? true) {
          BlocProvider.of<AuthBloc>(context).needLogIn();
          return;
        }

        Get.bottomSheet(
          BottomSheet(
            onClosing: () {},
            builder: ((context) => CommentInput(post: post)),
          ),
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      child: Text(RCCubit.instance.getText(R.comment)),
    );
  }
}
