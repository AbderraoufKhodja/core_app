import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/relations/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/relation.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/user_profile_page.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  static Future<dynamic>? show() async {
    final needLogIn = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
    if (needLogIn) {
      return null;
    }

    return Get.to(() => const ContactsPage());
  }

  @override
  ContactsPageState createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin<ContactsPage> {
  @override
  bool get wantKeepAlive => true;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            RCCubit.instance.getText(R.contacts),
            style: GoogleFonts.fredokaOne(color: Colors.grey),
          ),
          elevation: 0,
          leading: const PopButton(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.transparent,
              isScrollable: true,
              padding: const EdgeInsets.all(8),
              labelPadding: const EdgeInsets.all(6.0),
              indicator:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
              labelStyle: const TextStyle(color: Colors.white),
              labelColor: Colors.white,
              tabs: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        RCCubit.instance.getText(R.friends),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        RCCubit.instance.getText(R.following),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        RCCubit.instance.getText(R.followers),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        RCCubit.instance.getText(R.requests),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        RCCubit.instance.getText(R.invitations),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              indent: 8,
              endIndent: 8,
              color: Colors.grey,
            ),
            if (_currentUser == null)
              const LogInWidget()
            else
              const Expanded(
                child: TabBarView(
                  children: [
                    UsersList(relationType: ReTypes.friends),
                    UsersList(relationType: ReTypes.followed),
                    FollowersList(),
                    UsersList(relationType: ReTypes.friendRequested),
                    UsersList(relationType: ReTypes.friendRequestedBy),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class UsersList extends StatefulWidget {
  const UsersList({Key? key, required this.relationType}) : super(key: key);

  final ReTypes relationType;

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> with AutomaticKeepAliveClientMixin<UsersList> {
  @override
  bool get wantKeepAlive => true;

  RelationsCubit get _relationsCubit => BlocProvider.of<RelationsCubit>(context);

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          final typedRelationDocs =
              state.relations?.where((relationDoc) => relationDoc.type == widget.relationType.name);

          if (typedRelationDocs?.isNotEmpty == true) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      typedRelationDocs!.length.toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: typedRelationDocs.length,
                    itemBuilder: (context, index) =>
                        _UserTile(relation: typedRelationDocs.toList()[index]),
                  ),
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

class FollowersList extends StatefulWidget {
  const FollowersList({Key? key}) : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList>
    with AutomaticKeepAliveClientMixin<FollowersList> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return Column(
      children: [
        Align(
            alignment: Alignment.centerRight,
            child: FutureBuilder<AggregateQuerySnapshot>(
                future: Relation.ref(userID: currentUser!.uid)
                    .where(ReLabels.type.name, isEqualTo: ReTypes.followedBy.name)
                    .count()
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.data?.count is int) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        snapshot.data!.count.toString(),
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    );
                  }

                  return const SizedBox();
                })),
        Expanded(
          child: FirestoreListView<Relation>(
            query: Relation.ref(userID: currentUser.uid)
                .where(ReLabels.type.name, isEqualTo: ReTypes.followedBy.name)
                .orderBy(
                  ReLabels.timestamp.name,
                  descending: true,
                ),
            loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
            itemBuilder: (context, snapshot) {
              final relation = snapshot.data();

              if (relation.isValid()) {
                return _UserTile(relation: relation);
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }
}

class _UserTile extends StatefulWidget {
  final Relation relation;

  const _UserTile({required this.relation});

  @override
  State<_UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<_UserTile> with AutomaticKeepAliveClientMixin<_UserTile> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<DocumentSnapshot<AppUser>>(
      future: AppUser.ref.doc(widget.relation.uid).get(),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            dense: true,
            leading: PhotoWidget.network(
              width: 50,
              height: 50,
              photoUrl: user.photoUrl,
              boxShape: BoxShape.circle,
            ),
            subtitle: const Text(''),
            trailing: user.timestamp != null
                ? Text(
                    timeago.format(widget.relation.timestamp!.toDate()),
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
