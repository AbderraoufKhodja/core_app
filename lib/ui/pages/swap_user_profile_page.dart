import 'package:carousel_slider/carousel_slider.dart';
import 'package:circle_flags/circle_flags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/relations/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_card_1.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_reviews_page.dart';
import 'package:fibali/fibali_core/models/swap_review.dart';
import 'package:fibali/ui/pages/settings_pages/privacy_security/blocked_users_page.dart';
import 'package:fibali/ui/pages/user_profile_page.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/models/relation.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/curved_button.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

import '../widgets/animated_fading_items.dart';

class SwapUserProfilePage extends StatefulWidget {
  final String userID;

  static Future<dynamic>? showPage({required String userID}) {
    return Get.to(() => SwapUserProfilePage(userID: userID));
  }

  const SwapUserProfilePage({super.key, required this.userID});

  @override
  SwapUserProfilePageState createState() => SwapUserProfilePageState();
}

class SwapUserProfilePageState extends State<SwapUserProfilePage> {
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
          final isBlocked = state.relations
              ?.any((doc) => doc.uid == widget.userID && doc.type == ReTypes.blockedBy.name);
          if (isBlocked == true) {
            return Scaffold(
              appBar: AppBar(
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
          if (state.relations?.any((relation) => relation.isBlocked) == true) {
            return Scaffold(
              appBar: AppBar(
                leading: const PopButton(),
                title: Text(RCCubit.instance.getText(R.profile)),
                centerTitle: false,
              ),
              body: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/91603-blocked-account-gray.json",
                      height: 200,
                      width: 200,
                      repeat: false,
                    ),
                    Text(
                      RCCubit.instance.getText(R.youHaveBlockedThisUser),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        BlockedUsersPage.show();
                      },
                      child: Text(RCCubit.instance.getText(R.unblock)),
                    ),
                  ],
                ),
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
  SettingsCubit get settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<AppUser>>(
      future: AppUser.ref.doc(widget.userID).get(),
      builder: (context, snapshot2) {
        if (snapshot2.connectionState == ConnectionState.waiting) {
          return LoadingGrid(width: Get.width);
        }

        if (snapshot2.hasError) return const SizedBox();

        if (snapshot2.data?.data()?.isActive == true) {
          final user = snapshot2.data!.data()!;

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  snap: true,
                  floating: true,
                  elevation: 0,
                  backgroundColor: Colors.black87,
                  expandedHeight: 210.0,
                  collapsedHeight: 80.0,
                  toolbarHeight: 60.0,
                  leadingWidth: 0.0,
                  automaticallyImplyLeading: false,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const PopButton(color: Colors.white70),
                      Expanded(child: HeaderTile(profileUser: user)),
                    ],
                  ),
                  actions: const [],
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    titlePadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    background: ColoredBox(
                      color: Colors.black87,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 80,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(color: Colors.white),
                            SwapReviewsCarousel(user: user)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                FirestoreQueryBuilder<SwapItem>(
                  query: SwapItem.ref
                      .where(PoLabels.uid.name, isEqualTo: user.uid)
                      .orderBy(PoLabels.timestamp.name, descending: true),
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
                      (swapItem) {
                        final heroTag = const Uuid().v4();
                        return GestureDetector(
                          onTap: () => SwapItemPage.showPage(
                            swapItem: swapItem,
                            heroTag: heroTag,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SwapItemCard1(
                              swapItem: swapItem,
                              heroTag: heroTag,
                            ),
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
          return Center(
            child: Text(RCCubit.instance.getText(R.userProfileTempBlocked)),
          );
        }

        return Center(child: Text(RCCubit.instance.getText(R.userNotFound)));
      },
    );
  }
}

class SwapReviewsCarousel extends StatelessWidget {
  const SwapReviewsCarousel({
    super.key,
    required this.user,
  });

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<SwapReview>(
      query: SwapReview.ref(userID: user.uid).where('reviewText', isGreaterThan: ''),
      pageSize: 4,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.white70,
                )
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }

        if (snapshot.docs.isEmpty) {
          return const SizedBox();
        }

        final reviews =
            snapshot.docs.map((query) => query.data()).where((review) => review.isValid()).toList();

        if (reviews.isEmpty) return const SizedBox();

        return Column(
          children: [
            ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              onTap: () {
                SwapReviewsPage.showPage(userID: user.uid);
              },
              leading: Text(
                RCCubit.instance.getText(R.reviews),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              dense: true,
              title: Row(
                children: [
                  if (user.avgSwapRating != null)
                    RatingBarIndicator(
                      rating: user.avgSwapRating!.toDouble(),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 25.0,
                    ),
                  if (user.avgSwapRating != null)
                    Chip(
                      backgroundColor: Colors.white30,
                      label: Text(
                        (user.avgSwapRating!.toStringAsFixed(1)),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  const Spacer(),
                  Row(
                    children: [
                      if (user.numSwapRating != null)
                        Text(
                          '(${user.numSwapRating!})',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      Text(RCCubit.instance.getText(R.seeMore),
                          style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(height: 0),
            ),
            CarouselSlider.builder(
              itemCount: reviews.length,
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                // if we reached the end of the currently obtained items, we try to
                // obtain more items
                if (snapshot.hasMore && itemIndex + 1 == reviews.length) {
                  // Tell FirestoreQueryBuilder to try to obtain more items.
                  // It is safe to call this function from within the build method.
                  snapshot.fetchMore();
                }
                return IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                          trailing: reviews[itemIndex].photoUrls != null
                              ? SizedBox.square(
                                  dimension: 50,
                                  child: AnimatedFadingItems(
                                    shape: BoxShape.rectangle,
                                    urls: reviews[itemIndex].photoUrls!,
                                  ),
                                )
                              : null,
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  reviews[itemIndex].userName!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              RatingBarIndicator(
                                rating: reviews[itemIndex].rating!.toDouble(),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 18.0,
                              )
                            ],
                          ),
                          subtitle: Text(
                            reviews[itemIndex].reviewText!,
                            style: const TextStyle(color: Colors.white70),
                            maxLines: 3,
                          ),
                          horizontalTitleGap: 0,
                          dense: true,
                        ),
                      ),
                      const SizedBox(height: 60, child: VerticalDivider(color: Colors.white70)),
                    ],
                  ),
                );
              },
              options: CarouselOptions(
                height: 80.0,
                viewportFraction: reviews.length == 1 ? 1 : 0.9,
                scrollDirection: Axis.horizontal,
                autoPlay: false,
                enlargeCenterPage: false,
                padEnds: false,
                scrollPhysics: reviews.length == 1 ? const NeverScrollableScrollPhysics() : null,
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
              ),
            ),
          ],
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          child: PhotoWidget.network(
            photoUrl: profileUser.photoUrl,
            height: 35,
            width: 35,
            canDisplay: true,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            profileUser.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
        ),
        Column(
          children: [
            CurvedButton(
              onTap: () => UserProfilePage.showPage(userID: profileUser.uid),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                RCCubit.instance.getText(R.profile),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
