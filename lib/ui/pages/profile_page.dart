import 'dart:ui' as ui;
import 'dart:ui';

import 'package:circle_flags/circle_flags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/curved_button.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/pages/post_factory/post_factory_page.dart';
import 'package:fibali/ui/pages/profile_screen/admin_drawer.dart';
import 'package:fibali/ui/pages/profile_screen/commented_posts_tab.dart';
import 'package:fibali/ui/pages/profile_screen/edit_profile_page.dart';
import 'package:fibali/ui/pages/profile_screen/liked_posts_tab.dart';
import 'package:fibali/ui/pages/profile_screen/my_posts_tab.dart';
import 'package:fibali/ui/pages/profile_screen/settings_page.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/jam.dart';
import 'package:iconify_flutter/icons/mi.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final statusBarHeight = MediaQueryData.fromWindow(ui.window).padding.top;
    final sliverAppBarDelegate = SliverAppBarDelegate(
      TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        isScrollable: true,
        physics: const NeverScrollableScrollPhysics(),
        tabs: [
          Text(RCCubit.instance.getText(R.posts)),
          Text(RCCubit.instance.getText(R.comments)),
          Text(RCCubit.instance.getText(R.likes)),
        ],
      ),
    );
    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          if (_currentUser?.photoUrl != null)
            PhotoWidgetNetwork(
              photoUrl: _currentUser?.photoUrl!,
              label: Utils.getInitial(_currentUser?.name),
              fit: BoxFit.cover,
              width: Get.width,
              height: Get.height,
            ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.scaffoldBackgroundColor.withOpacity(0.8),
              ),
            ),
          ),
          Scaffold(
            key: _key,
            drawer: const Drawer(child: AdminDrawer()),
            backgroundColor: Colors.transparent,
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  leading: IconButton(
                    icon: Iconify(Mi.three_rows, color: Colors.grey.shade500),
                    onPressed: () => _key.currentState!.openDrawer(),
                  ),
                  backgroundColor: Colors.transparent,
                  titleSpacing: 0,
                  title: Text(RCCubit.instance.getText(R.profile)),
                  pinned: true,
                  snap: true,
                  floating: true,
                  elevation: 0,
                  expandedHeight: 290.0,
                  collapsedHeight: 100.0,
                  toolbarHeight: 60.0,
                  leadingWidth: 60.0,
                  actions: [
                    IconButton(
                      onPressed: () => SettingsPage.show(),
                      icon: Iconify(Jam.settings_alt, size: 30, color: Colors.grey.shade500),
                    ),
                  ],
                  flexibleSpace: StreamBuilder<DocumentSnapshot<AppUser>>(
                      stream: BlocProvider.of<AuthBloc>(context).currentUserStream,
                      builder: (context, snapshot) {
                        return FlexibleSpaceBar(
                          expandedTitleScale: 1,
                          titlePadding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  MaterialButton(
                                    visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                                    padding: const EdgeInsets.all(0.0),
                                    onPressed: () => showPostFactoryPage(
                                      currentUser: _currentUser!,
                                      postID: null,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          RCCubit.instance.getText(R.newPost),
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade500),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Iconify(Ic.sharp_camera,
                                            size: 16, color: Colors.grey.shade500),
                                        const SizedBox(width: 4)
                                      ],
                                    ),
                                  )
                                  // const Expanded(child: ProfileLocationBadge()),
                                ],
                              ),
                            ],
                          ),
                          background: Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                              top: 100.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildHeader(),
                                const Divider(),
                                Expanded(
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        buildBio(),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            CurvedButton(
                                              color: Colors.grey,
                                              onTap: () => EditProfilePage.show()?.then((value) {
                                                setState(() {});
                                              }),
                                              padding: const EdgeInsets.symmetric(horizontal: 4),
                                              child: Text(
                                                RCCubit.instance.getText(R.editProfile),
                                                style: Theme.of(context).textTheme.labelSmall,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                SliverToBoxAdapter(
                  child: Card(
                    elevation: 0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: SizedBox(
                            height: 4,
                            child: Divider(
                              thickness: 4,
                              height: 0,
                              endIndent: Get.width * 0.435,
                              indent: Get.width * 0.435,
                            ),
                          ),
                        ),
                        TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 3,
                          isScrollable: true,
                          physics: const NeverScrollableScrollPhysics(),
                          tabs: [
                            Text(RCCubit.instance.getText(R.posts).toUpperCase()),
                            Text(RCCubit.instance.getText(R.comments).toUpperCase()),
                            Text(RCCubit.instance.getText(R.likes).toUpperCase()),
                          ],
                        ),
                        Container(
                          height: Get.height -
                              100 -
                              sliverAppBarDelegate.maxExtent -
                              45 -
                              statusBarHeight,
                          width: Get.width,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: const TabBarView(
                            children: [
                              MyPostsTab(),
                              CommentedPostsTab(),
                              LikedPostsTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text buildBio() {
    return Text(
      _currentUser?.bio ?? RCCubit.instance.getText(R.someDayWriteBio),
      style: _currentUser?.bio != null
          ? Theme.of(context).textTheme.bodyMedium
          : Theme.of(context).textTheme.bodySmall,
      maxLines: 2,
    );
  }

  Row buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PhotoWidgetNetwork(
          label: Utils.getInitial(_currentUser?.name),
          photoUrl: _currentUser?.photoUrl,
          boxShape: BoxShape.circle,
          height: 80,
          width: 80,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  _currentUser?.name ?? '',
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.fade,
                ),
                Text('FibaliID: ${_currentUser?.uid.codeUnits.join().substring(0, 8) ?? ''}',
                    style: Theme.of(context).textTheme.bodySmall),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '${RCCubit.instance.getText(R.followers)} ${_currentUser!.numFollower?.toString() ?? 0.toString()}',
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 12, child: VerticalDivider()),
                      Text(
                        '${RCCubit.instance.getText(R.following)} ${_currentUser!.numFollowing?.toString() ?? 0.toString()}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}

class ProfileLocationBadge extends StatefulWidget {
  const ProfileLocationBadge({super.key});

  @override
  State<ProfileLocationBadge> createState() => _ProfileLocationBadgeState();
}

class _ProfileLocationBadgeState extends State<ProfileLocationBadge> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (_currentUser?.location?.containsKey('geopoint') == true)
        LocationBadge(
          geopoint: _currentUser?.location!['geopoint'] as GeoPoint,
        )
      else
        CurvedButton(
          height: 30,
          onTap: () {
            _settingsCubit.changeUserLocation(userID: _currentUser!.uid);
          },
          child: Row(
            children: [
              const Icon(FluentIcons.location_16_regular, size: 15),
              Text(RCCubit.instance.getText(R.addLocation),
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
    ]);
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
    return Container(
      // margin: EdgeInsets.only(top: 20.0),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      // padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: SizedBox(
              height: 4,
              child: Divider(
                thickness: 4,
                height: 0,
                endIndent: size.width * 0.435,
                indent: size.width * 0.435,
              ),
            ),
          ),
          _tabBar,
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class LocationBadge extends StatefulWidget {
  final GeoPoint geopoint;

  const LocationBadge({super.key, required this.geopoint});

  @override
  State<LocationBadge> createState() => _LocationBadgeState();
}

class _LocationBadgeState extends State<LocationBadge> {
  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Placemark>?>(
      future: SettingsCubit.getAddressFromLatLong(
        latitude: widget.geopoint.latitude,
        longitude: widget.geopoint.longitude,
        appLanguage: _settingsCubit.state.appLanguage,
      ),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
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
                const SizedBox(height: 8.0),
                if (placeMarks[0].isoCountryCode != null)
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
                        child: CircleFlag(placeMarks[0].isoCountryCode ?? ''),
                      ),
                    ),
                  ),
                const SizedBox(width: 8.0),
                if (placeMarks[0].administrativeArea?.isNotEmpty == true)
                  CurvedButton(
                    height: 30,
                    onTap: () {
                      _settingsCubit.changeUserLocation(userID: _currentUser!.uid);
                    },
                    child: Row(
                      children: [
                        const Icon(FluentIcons.location_16_regular, size: 15),
                        Text(placeMarks[0].administrativeArea ?? '',
                            style: Theme.of(context).textTheme.labelMedium),
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

  Text buildLocationText(List<Placemark> placeMarks) {
    return Text(
      checkAddressField(str: placeMarks[0].administrativeArea) +
          checkAddressField(str: placeMarks[0].country, isLast: true),
    );
  }

  String checkAddressField({String? str, bool isLast = false}) => str != null
      ? str.isNotEmpty
          ? isLast
              ? str
              : "$str, "
          : ""
      : "";
}
