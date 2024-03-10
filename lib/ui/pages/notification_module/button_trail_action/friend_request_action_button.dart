import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/relations/bloc.dart';
import 'package:fibali/fibali_core/models/app_notification.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendRequestActionButton extends StatelessWidget {
  const FriendRequestActionButton({
    super.key,
    required this.notification,
  });

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final relationsCubit = BlocProvider.of<RelationsCubit>(context);
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    final AppNotTypes? notificationType = Utils.enumFromString<AppNotTypes>(
      AppNotTypes.values,
      notification.notificationType ?? '',
    );
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
          final isFriend = relationsCubit.isFriend(
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

          if (isFriend == true) {
            return TextButton(
              onPressed: null,
              child: Text(RCCubit.instance.getText(R.accepted)),
            );
          }

          if (isBlockedBy != true && isBlocked != true && isFriend != true) {
            return Row(
              children: [
                TextButton(
                  child: Text(RCCubit.instance.getText(R.accept)),
                  onPressed: () {
                    relationsCubit.onAcceptFriendRequest(
                      otherUserID: notification.senderID!,
                      currentUser: currentUser!,
                    );
                  },
                ),
                TextButton(
                  child: Text(RCCubit.instance.getText(R.declined)),
                  onPressed: () {
                    relationsCubit.onDeclineFriendRequest(
                      otherUserID: notification.senderID!,
                      currentUser: currentUser!,
                    );
                  },
                ),
              ],
            );
          }
        }

        return const SizedBox();
      },
    );
  }
}
