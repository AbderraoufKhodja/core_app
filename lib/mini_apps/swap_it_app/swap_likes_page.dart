import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/appreciation.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/pages/swap_user_profile_page.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class SwapLikesPage extends StatefulWidget {
  const SwapLikesPage({Key? key, required this.postID}) : super(key: key);

  final String postID;

  static Future<dynamic>? showPage({required String postID}) {
    return Get.to(() => SwapLikesPage(postID: postID));
  }

  @override
  SwapLikesPageState createState() => SwapLikesPageState();
}

class SwapLikesPageState extends State<SwapLikesPage>
    with AutomaticKeepAliveClientMixin<SwapLikesPage> {
  @override
  bool get wantKeepAlive => true;
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(RCCubit.instance.getText(R.likes),
            style: GoogleFonts.fredokaOne(color: Colors.grey)),
        elevation: 0,
        leading: const PopButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          if (_currentUser == null)
            const LogInWidget()
          else
            Expanded(
              child: _buildTiles(chatType: ChatTypes.swapIt),
            ),
        ],
      ),
    );
  }

  Widget _buildTiles({required ChatTypes chatType}) {
    return FirestoreListView<Appreciation>(
      query: Appreciation.ref
          .where(ApLabels.state.name, isEqualTo: ApTypes.like.name)
          .where(ApLabels.itemID.name, isEqualTo: widget.postID),
      loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
      itemBuilder: (context, snapshot) {
        final appreciation = snapshot.data();

        if (appreciation.isValid()) {
          return Column(
            children: [
              _UserTile(appreciation: appreciation),
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
  final Appreciation appreciation;

  const _UserTile({super.key, required this.appreciation});

  @override
  State<_UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<_UserTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<AppUser>>(
      future: AppUser.ref.doc(widget.appreciation.uid).get(),
      builder: (context, snapshot) {
        final user = snapshot.data?.data();
        if (user != null) {
          return ListTile(
            onTap: () async {
              SwapUserProfilePage.showPage(userID: user.uid);
            },
            tileColor: Colors.transparent,
            title: Text(
              user.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
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
                    timeago.format(widget.appreciation.timestamp!.toDate()),
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
