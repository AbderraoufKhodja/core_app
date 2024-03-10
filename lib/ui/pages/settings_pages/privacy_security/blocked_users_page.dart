import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/bloc/relations/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/relation.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/widgets/shimmer_chat_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class BlockedUsersPage extends StatelessWidget {
  static Future<dynamic>? show() => Get.to(() => const BlockedUsersPage());

  const BlockedUsersPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserID = BlocProvider.of<AuthBloc>(context).currentUser!.uid;
    final relationsCubit = BlocProvider.of<RelationsCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.blockedUsers)),
        leading: const PopButton(),
      ),
      body: StreamBuilder<QuerySnapshot<Relation>?>(
        stream: Relation.ref(userID: currentUserID)
            .where(ReLabels.type.name, isEqualTo: ReTypes.blocked.name)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(RCCubit.instance.getText(R.oopsSomethingWentWrong)),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: const [
                ShimmerChatTile(),
                ShimmerChatTile(),
                ShimmerChatTile(),
              ],
            );
          }

          final blockedUsers =
              snapshot.data?.docs.map((doc) => doc.data()).where((doc) => doc.isValid()).toList() ??
                  [];

          if (blockedUsers.isEmpty) {
            return Center(
              child: Text(RCCubit.instance.getText(R.noBlockedUsers)),
            );
          }

          return ListView.separated(
            itemCount: blockedUsers.length,
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemBuilder: (context, idx) {
              final relation = blockedUsers[idx];

              return FutureBuilder<DocumentSnapshot<AppUser>>(
                future: AppUser.ref.doc(relation.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ShimmerChatTile();
                  }

                  if (snapshot.data?.data()?.isActive == true) {
                    final user = snapshot.data!.data();
                    return ListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      title: Text(user!.name),
                      trailing: TextButton(
                        child: Text(RCCubit.instance.getText(R.unblock)),
                        onPressed: () async {
                          Utils.showBlurredDialog(
                            child: AlertDialog(
                              title: Text(RCCubit.instance.getText(R.unblock)),
                              content: Text(RCCubit.instance.getText(R.unBlockUserDescription)),
                              actions: [
                                TextButton(
                                  child: Text(RCCubit.instance.getText(R.cancel)),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: Text(RCCubit.instance.getText(R.unblock)),
                                  onPressed: () async {
                                    Get.back();
                                    EasyLoading.show(dismissOnTap: true);
                                    await relationsCubit
                                        .onUnblock(
                                            otherUserID: user.uid, currentUserID: currentUserID)
                                        .then((value) {
                                      EasyLoading.dismiss();
                                    }).onError((error, stackTrace) {
                                      EasyLoading.showError(RCCubit.instance.getText(R.failed));
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      subtitle: Text(Utils.timeAgo(relation.timestamp) ?? ''),
                    );
                  }

                  return const SizedBox();
                },
              );
            },
          );
        },
      ),
    );
  }
}
