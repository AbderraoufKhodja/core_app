import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/relations/relations_cubit.dart';
import 'package:fibali/bloc/relations/relations_state.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/relation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class RelationsButton extends StatefulWidget {
  const RelationsButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  State<RelationsButton> createState() => _RelationsButtonState();
}

class _RelationsButtonState extends State<RelationsButton> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  RelationsCubit get _relationsCubit => BlocProvider.of<RelationsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RelationsCubit, RelationsState>(
      buildWhen: (previous, current) => previous is RelationsLoading && current is RelationsLoaded,
      builder: (context, state) {
        if (state is RelationsInitial) {
          _relationsCubit.loadRelations(userID: _currentUser!.uid);
        }

        if (state is RelationsLoading) {
          return const CircularProgressIndicator();
        }

        if (state is RelationsLoaded) {
          if (state.relations?.isNotEmpty == true) {
            if (state.relations!.any((relation) =>
                relation.type == ReTypes.blockedBy.name && relation.uid == widget.user.uid)) {
              return Text(
                RCCubit.instance.getText(R.blockedBy),
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              );
            }

            if (state.relations!.any((relation) =>
                relation.type == ReTypes.blocked.name && relation.uid == widget.user.uid)) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  child: Text(
                    RCCubit.instance.getText(R.unblock),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    _relationsCubit.onUnblock(
                      currentUserID: _currentUser!.uid,
                      otherUserID: widget.user.uid,
                    );
                  },
                ),
              );
            }

            if (state.relations!.any((relation) =>
                relation.type == ReTypes.friends.name && relation.uid == widget.user.uid)) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      child: Text(
                        RCCubit.instance.getText(R.friends),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.email,
                        size: 28,
                      ),
                      onPressed: () {
                        final chatID = '${ChatTypes.personal.name}_${Utils.getUniqueID(
                          firstID: _currentUser!.uid,
                          secondID: widget.user.uid,
                        )}';

                        showMessagingPage(
                          type: ChatTypes.personal,
                          chatID: chatID,
                          otherUserID: widget.user.uid,
                        );
                      },
                      color: Colors.white70,
                    ),
                  ),
                ],
              );
            }

            if (state.relations!.any((relation) =>
                relation.type == ReTypes.friendRequestedBy.name &&
                relation.uid == widget.user.uid)) {
              return Row(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextButton(
                          child: Text(
                            RCCubit.instance.getText(R.declineFriendRequest),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            _relationsCubit.onDeclineFriendRequest(
                              currentUser: _currentUser!,
                              otherUserID: widget.user.uid,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextButton(
                          child: Text(
                            RCCubit.instance.getText(R.acceptFriend),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            _relationsCubit.onAcceptFriendRequest(
                              currentUser: _currentUser!,
                              otherUserID: widget.user.uid,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.email,
                        size: 28,
                      ),
                      onPressed: () {
                        final chatID = '${ChatTypes.personal.name}_${Utils.getUniqueID(
                          firstID: _currentUser!.uid,
                          secondID: widget.user.uid,
                        )}';

                        showMessagingPage(
                          type: ChatTypes.personal,
                          chatID: chatID,
                          otherUserID: widget.user.uid,
                        );
                      },
                      color: Colors.white70,
                    ),
                  ),
                ],
              );
            }

            if (state.relations!.any((relation) =>
                relation.type == ReTypes.friendRequested.name && relation.uid == widget.user.uid)) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      child: Text(
                        RCCubit.instance.getText(R.cancelFriendRequest),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        _relationsCubit.onCancelFriendRequest(
                          currentUser: _currentUser!,
                          otherUser: widget.user,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.email,
                        size: 28,
                      ),
                      onPressed: () {
                        final chatID = '${ChatTypes.personal.name}_${Utils.getUniqueID(
                          firstID: _currentUser!.uid,
                          secondID: widget.user.uid,
                        )}';
                        showMessagingPage(
                          type: ChatTypes.personal,
                          chatID: chatID,
                          otherUserID: widget.user.uid,
                        );
                      },
                      color: Colors.white70,
                    ),
                  ),
                ],
              );
            }
          }

          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  child: Text(
                    RCCubit.instance.getText(R.requestFriend),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    final controller = TextEditingController();
                    Get.dialog(
                      Builder(builder: (context) {
                        return AlertDialog(
                          //Getx dialog is used, you may use default other dialog based on your requirement
                          title: Text(
                            RCCubit.instance.getText(R.sendFriendRequest),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          content: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade200,
                            ),
                          ),

                          actions: <Widget>[
                            Center(
                              child: TextButton(
                                onPressed: () async {
                                  AppUser? currentUser =
                                      BlocProvider.of<AuthBloc>(context).currentUser;

                                  await _relationsCubit.onSendFriendRequest(
                                    currentUser: currentUser!,
                                    otherUser: widget.user,
                                    text: controller.text,
                                  );
                                  if (mounted) Get.back();
                                },
                                child: Text(RCCubit.instance.getText(R.send)),
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.email,
                    size: 28,
                  ),
                  onPressed: () {
                    final chatID = '${ChatTypes.personal.name}_${Utils.getUniqueID(
                      firstID: _currentUser!.uid,
                      secondID: widget.user.uid,
                    )}';
                    showMessagingPage(
                      type: ChatTypes.personal,
                      chatID: chatID,
                      otherUserID: widget.user.uid,
                    );
                  },
                  color: Colors.white70,
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
