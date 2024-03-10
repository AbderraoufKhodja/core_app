import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/pages/user_profile_page.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class LikesPage extends StatefulWidget {
  const LikesPage({Key? key, required this.postID}) : super(key: key);

  final String postID;

  static Future<dynamic>? showPage({required String postID}) {
    return Get.to(() => LikesPage(postID: postID));
  }

  @override
  LikesPageState createState() => LikesPageState();
}

class LikesPageState extends State<LikesPage> with AutomaticKeepAliveClientMixin<LikesPage> {
  @override
  bool get wantKeepAlive => true;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.likes)),
        leading: const PopButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            indent: 8,
            endIndent: 8,
          ),
          Expanded(
            child: _buildTiles(chatType: ChatTypes.swapIt),
          ),
        ],
      ),
    );
  }

  Widget _buildTiles({required ChatTypes chatType}) {
    return FirestoreListView<Like>(
      query: Like.ref
          .where(
            LiLabels.type.name,
            isEqualTo: LiTypes.postItem.name,
          )
          .where(
            LiLabels.itemID.name,
            isEqualTo: widget.postID,
          ),
      loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
      itemBuilder: (context, snapshot) {
        final like = snapshot.data();

        if (like.isValid()) {
          return Column(
            children: [
              _UserTile(like: like),
              const PaddedDivider(hight: 0),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _UserTile extends StatefulWidget {
  final Like like;

  const _UserTile({super.key, required this.like});

  @override
  State<_UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<_UserTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<AppUser>>(
      future: AppUser.ref.doc(widget.like.uid).get(),
      builder: (context, snapshot) {
        final user = snapshot.data?.data();
        if (user != null) {
          return ListTile(
            onTap: () async {
              UserProfilePage.showPage(userID: user.uid);
            },
            tileColor: Colors.transparent,
            title: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            dense: true,
            leading: PhotoWidgetNetwork(
              label: Utils.getInitial(user.name),
              width: 50,
              height: 50,
              photoUrl: user.photoUrl,
              boxShape: BoxShape.circle,
            ),
            subtitle: const Text(''),
            trailing: user.timestamp != null
                ? Text(
                    timeago.format(widget.like.timestamp!.toDate()),
                    style: const TextStyle(color: Colors.grey),
                  )
                : const Text(''),
          );
        }
        return const SizedBox();
      },
    );
  }
}
