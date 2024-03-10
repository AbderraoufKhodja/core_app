import 'dart:io';
import 'dart:ui';

import 'package:circle_flags/circle_flags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/relations/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/models/relation.dart';
import 'package:fibali/fibali_core/ui/pages/profile_report_page.dart';
import 'package:fibali/fibali_core/ui/widgets/curved_button.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/post_page.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/post_card.dart';
import 'package:fibali/ui/pages/settings_pages/privacy_security/blocked_users_page.dart';
import 'package:fibali/ui/widgets/relations_button.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

class UserProfilePage extends StatefulWidget {
  final String userID;

  static Future<dynamic>? showPage({required String userID}) {
    return Get.to(() => UserProfilePage(userID: userID));
  }

  const UserProfilePage({super.key, required this.userID});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  AppUser? get currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  RelationsCubit get _relationsCubit => BlocProvider.of<RelationsCubit>(context);

  RelationsLoaded? previousRelationsLoaded;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RelationsCubit, RelationsState>(
      buildWhen: (previous, current) {
        if (previous is RelationsLoading && current is RelationsLoaded) {
          if (previousRelationsLoaded == null) {
            return true;
          }
          // check if the changes in relationsLoaded are related to the current user
          if (previousRelationsLoaded!.relations?.where(
                (relation) {
                  if (relation.uid == widget.userID) {
                    return relation.type == ReTypes.blocked.name ||
                        relation.type == ReTypes.blockedBy.name ||
                        relation.type == ReTypes.followed.name;
                  }

                  return false;
                },
              ).length !=
              current.relations?.where(
                (relation) {
                  if (relation.uid == widget.userID) {
                    return relation.type == ReTypes.blocked.name ||
                        relation.type == ReTypes.blockedBy.name ||
                        relation.type == ReTypes.followed.name;
                  }

                  return false;
                },
              ).length) {
            return true;
          }
        }

        return false;
      },
      builder: (context, state) {
        if (state is RelationsInitial) {
          _relationsCubit.loadRelations(userID: currentUser!.uid);
        }

        if (state is RelationsLoading) {
          return const CircularProgressIndicator();
        }

        if (state is RelationsLoaded) {
          previousRelationsLoaded = state;
          final isBlockedBy = state.relations
                  ?.any((doc) => doc.uid == widget.userID && doc.type == ReTypes.blockedBy.name) ==
              true;
          final isBlocked = state.relations
                  ?.any((doc) => doc.uid == widget.userID && doc.type == ReTypes.blocked.name) ==
              true;

          if (isBlocked) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Text(RCCubit.instance.getText(R.profile),
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
                  Expanded(
                    child: ListView(
                      children: [
                        Lottie.asset('assets/91603-blocked-account-gray.json'),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                RCCubit.instance.getText(R.youHaveBlockedThisUser),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  BlockedUsersPage.show();
                                },
                                child: Text(RCCubit.instance.getText(R.unblock)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }

          if (isBlockedBy) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Text(RCCubit.instance.getText(R.profile),
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
                  Expanded(
                    child: ListView(
                      children: [
                        Lottie.asset('assets/91603-blocked-account-gray.json'),
                        Center(
                          child: Text(
                            RCCubit.instance.getText(R.youHaveBeenBlockedByThisUser),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }

          return _UserProfileWidget(
            userID: widget.userID,
            relations: state.relations,
          );
        }

        return const SizedBox();
      },
    );
  }
}

class LocationBadge extends StatefulWidget {
  final GeoPoint geopoint;

  const LocationBadge({super.key, required this.geopoint});

  @override
  State<LocationBadge> createState() => _LocationBadgeState();
}

class _LocationBadgeState extends State<LocationBadge> {
  @override
  Widget build(BuildContext context) {
    final settingsCubit = BlocProvider.of<SettingsCubit>(context);

    return FutureBuilder<List<Placemark>?>(
      future: SettingsCubit.getAddressFromLatLong(
        latitude: widget.geopoint.latitude,
        longitude: widget.geopoint.longitude,
        appLanguage: settingsCubit.state.appLanguage,
      ),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const SizedBox();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        if (snapshot.hasData) {
          final placeMarks = snapshot.data!;

          if (placeMarks.isNotEmpty == true) {
            return Row(
              children: [
                if (placeMarks.first.isoCountryCode?.isNotEmpty == true)
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.saturation,
                          ),
                          child: CircleFlag(placeMarks.first.isoCountryCode!)),
                    ),
                  ),
                const SizedBox(width: 8.0),
                if (placeMarks.first.administrativeArea?.isNotEmpty == true)
                  CurvedButton(
                    height: 30,
                    child: Row(
                      children: [
                        const Icon(
                          FluentIcons.location_16_regular,
                          size: 15,
                          color: Colors.white,
                        ),
                        Text(placeMarks.first.administrativeArea!,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: Colors.white)),
                      ],
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

class _UserProfileWidget extends StatefulWidget {
  const _UserProfileWidget({
    required this.userID,
    required this.relations,
  });

  final String userID;
  final List<Relation>? relations;

  @override
  State<_UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<_UserProfileWidget> {
  late final futureUser = AppUser.ref.doc(widget.userID).get();

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  RelationsCubit get _relationsCubit => BlocProvider.of<RelationsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<AppUser>>(
      future: futureUser,
      builder: (context, snapshot2) {
        if (snapshot2.hasError) return const SizedBox();

        if (snapshot2.connectionState == ConnectionState.waiting) {
          return LoadingGrid(width: Get.width);
        }

        if (snapshot2.data?.exists == false) {
          return Scaffold(
            appBar: AppBar(
              title: Text(RCCubit.instance.getText(R.profile)),
              leading: const PopButton(),
            ),
            body: Center(
              child: Text(RCCubit.instance.getText(R.userNotFound)),
            ),
          );
        }

        if (snapshot2.data?.data()?.isActive == true) {
          final user = snapshot2.data!.data()!;

          final isFriend = widget.relations?.any(
              (relation) => relation.uid == widget.userID && relation.type == ReTypes.friends.name);

          final isFollowed = widget.relations?.any((relation) =>
              relation.uid == widget.userID && relation.type == ReTypes.followed.name);

          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  leading: const PopButton(color: Colors.white70),
                  pinned: true,
                  snap: true,
                  floating: true,
                  elevation: 0,
                  backgroundColor: Colors.black54,
                  expandedHeight: 290.0,
                  collapsedHeight: 100.0,
                  toolbarHeight: 60.0,
                  leadingWidth: 60.0,
                  actions: [
                    if (widget.userID != _currentUser?.uid) RelationsButton(user: user),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PopupMenuButton<String>(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.grey,
                        ),
                        itemBuilder: (context) {
                          return [
                            if (_currentUser?.uid != null && _currentUser?.uid != user.uid)
                              PopupMenuItem<String>(
                                value: null,
                                child: Text(RCCubit.instance.getText(R.report)),
                                onTap: () async {
                                  await Future.delayed(const Duration(milliseconds: 500));
                                  ProfileReportPage.show(reportedUser: user);
                                },
                              ),
                            if (_currentUser?.uid != null && _currentUser?.uid != user.uid)
                              PopupMenuItem<String>(
                                value: null,
                                child: Text(RCCubit.instance.getText(R.block)),
                                onTap: () async {
                                  await Future.delayed(const Duration(milliseconds: 500));
                                  // show dialog to confirm
                                  Utils.showBlurredDialog(
                                      child: AlertDialog(
                                    title: Text(RCCubit.instance.getText(R.block)),
                                    content: Text(RCCubit.instance.getText(R.blockUserDescription)),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(RCCubit.instance.getText(R.cancel)),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          Get.back();
                                          BlocProvider.of<RelationsCubit>(Get.context!).onBlock(
                                            currentUser: _currentUser!,
                                            otherUser: user,
                                          );
                                          Get.back();
                                        },
                                        child: Text(RCCubit.instance.getText(R.block)),
                                      ),
                                    ],
                                  ));
                                },
                              )
                          ];
                        },
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    titlePadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.userID != _currentUser?.uid)
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      '${RCCubit.instance.getText(R.followers)} ${user.numFollower?.toString() ?? 0.toString()}',
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(
                                        height: 12,
                                        child: VerticalDivider(
                                          color: Colors.white70,
                                        )),
                                    Text(
                                      '${RCCubit.instance.getText(R.following)} ${user.numFollowing?.toString() ?? 0.toString()}',
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isFollowed == true)
                                CurvedButton(
                                  onTap: () => _relationsCubit.onUnfollow(
                                    currentUser: _currentUser!,
                                    otherUser: user,
                                  ),
                                  child: Text(
                                    RCCubit.instance.getText(R.unfollow),
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                )
                              else
                                CurvedButton(
                                  onTap: () => _relationsCubit.onFollow(
                                    currentUser: _currentUser!,
                                    otherUserID: user.uid,
                                  ),
                                  child: Text(
                                    RCCubit.instance.getText(R.follow),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                    background: Stack(
                      children: [
                        if (user.photoUrl != null)
                          PhotoWidgetNetwork(
                            photoUrl: user.photoUrl!,
                            label: Utils.getInitial(user.name),
                            fit: BoxFit.cover,
                            width: Get.width,
                            height: Get.height / 2,
                          )
                        else
                          PhotoWidget.asset(
                            path: 'assets/album_photos_compressed.jpeg',
                            fit: BoxFit.cover,
                            width: Get.width,
                            height: Get.height / 2,
                          ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            top: Platform.isIOS ? 120.0 : 90.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderTile(profileUser: user),
                              const Divider(color: Colors.white),
                              if (user.bio != null)
                                Expanded(
                                  child: Text(
                                    (user.bio ?? RCCubit.instance.getText(R.someDayWriteBio)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white70),
                                    maxLines: 3,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FirestoreQueryBuilder<Post>(
                  query: Post.ref
                      .where(PoLabels.uid.name, isEqualTo: user.uid)
                      .where(PoLabels.privacy.name, whereIn: [
                    PostPrivacyType.public.name,
                    if (isFollowed == true) PostPrivacyType.followers.name,
                    if (isFriend == true) PostPrivacyType.friends.name,
                  ]).orderBy(PoLabels.timestamp.name, descending: true),
                  builder: (context, snapshot, _) {
                    if (snapshot.isFetching) {
                      return SliverFillRemaining(
                        child: LoadingGrid(width: Get.width - 16),
                      );
                    }

                    if (snapshot.hasError) {
                      return SliverToBoxAdapter(child: Text('error ${snapshot.error}'));
                    }

                    final widgets =
                        snapshot.docs.map((doc) => doc.data()).where((post) => post.isValid()).map(
                      (post) {
                        final heroTag = const Uuid().v4();
                        return GestureDetector(
                          onTap: () => PostPage.show(
                            post: post,
                            heroTag: heroTag,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: PostCard(post: post, heroTag: heroTag),
                          ),
                        );
                      },
                    ).toList();

                    return SliverMasonryGrid.count(
                      itemBuilder: (context, index) {
                        if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                          snapshot.fetchMore();
                        }

                        return widgets[index];
                      },
                      childCount: widgets.length,
                      crossAxisCount: 2,
                    );
                  },
                ),
              ],
            ),
          );
        } else if (snapshot2.data?.data()?.isActive == false) {
          return Scaffold(
            appBar: AppBar(
              title: Text(RCCubit.instance.getText(R.profile)),
              leading: const PopButton(),
            ),
            body: Center(
              child: Text(RCCubit.instance.getText(R.userProfileTempBlocked)),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(RCCubit.instance.getText(R.profile)),
            leading: const PopButton(),
          ),
          body: Center(child: Text(RCCubit.instance.getText(R.oopsSomethingWentWrong))),
        );
      },
    );
  }
}

class HeaderTile extends StatelessWidget {
  const HeaderTile({
    Key? key,
    required this.profileUser,
  }) : super(key: key);

  final AppUser profileUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PhotoWidget.network(
          photoUrl: profileUser.photoUrl,
          boxShape: BoxShape.circle,
          height: 80,
          width: 80,
          canDisplay: true,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  profileUser.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                ),
                if (profileUser.location?.containsKey('geopoint') == true)
                  LocationBadge(
                    geopoint: profileUser.location!['geopoint'] as GeoPoint,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
