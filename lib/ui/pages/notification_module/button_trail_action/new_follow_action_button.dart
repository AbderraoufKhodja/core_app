import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/relations/bloc.dart';
import 'package:fibali/fibali_core/models/app_notification.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewFollowActionButton extends StatelessWidget {
  const NewFollowActionButton({
    super.key,
    required this.notification,
  });

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final relationsCubit = BlocProvider.of<RelationsCubit>(context);
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return BlocBuilder<RelationsCubit, RelationsState>(
      buildWhen: (previous, current) => previous is RelationsLoading && current is RelationsLoaded,
      builder: (context, state) {
        if (state is RelationsInitial) {
          relationsCubit.loadRelations(userID: currentUser!.uid);
        }

        if (state is RelationsLoading) {
          return const CircularProgressIndicator();
        }

        if (state is RelationsLoaded) {
          final isFollowed = relationsCubit.isFollowed(
            state.relations,
            notification.senderID,
          );
          final isBlockedBy = relationsCubit.isBlockedBy(
            state.relations,
            notification.senderID,
          );
          final isBlocked = relationsCubit.isBlocked(
            state.relations,
            notification.senderID,
          );

          if (isBlocked != true && isBlockedBy != true && isFollowed != true) {
            return TextButton(
              child: Text(RCCubit.instance.getText(R.followBack)),
              onPressed: () {
                relationsCubit.onFollow(
                  otherUserID: notification.senderID!,
                  currentUser: currentUser!,
                );
              },
            );
          }
        }

        return const SizedBox();
      },
    );
  }
}
