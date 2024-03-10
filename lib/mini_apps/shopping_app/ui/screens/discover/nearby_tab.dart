import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/bloc/nearby/bloc.dart';
import 'package:fibali/bloc/relations/relations_bloc_builder.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/post_page.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/discover_tab_post_card.dart';
import 'package:fibali/ui/pages/post_factory/post_factory_page.dart';
import 'package:fibali/ui/widgets/gps_loader_widget.dart';
import 'package:fibali/ui/widgets/stream_firestore_query_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fluent_emoji_high_contrast.dart';
import 'package:uuid/uuid.dart';

class NearbyTab extends StatefulWidget {
  const NearbyTab({super.key});

  @override
  NearbyTabState createState() => NearbyTabState();
}

class NearbyTabState extends State<NearbyTab> with AutomaticKeepAliveClientMixin<NearbyTab> {
  @override
  bool get wantKeepAlive => true;

  late Future<GeoPoint> deviceGPSLocation =
      _settingsCubit.getSwapPosition(userID: _currentUser?.uid);

  NearbyCubit get _nearbyCubit => BlocProvider.of<NearbyCubit>(context);

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, left: 4.0, right: 4.0),
      child: GPSLoaderWidget(
        builder: (context, geopoint) {
          return Column(
            children: [
              const SizedBox(height: 4),
              Expanded(
                child: BlocBuilder<NearbyCubit, NearbyState>(
                  buildWhen: (previous, current) => true,
                  builder: (context, state) {
                    if (state is NearbyInitial) {
                      _nearbyCubit.initNearbyCubit(
                        center: GeoFirePoint(
                          geopoint.latitude,
                          geopoint.longitude,
                        ),
                        radius: 100,
                      );

                      return LoadingGrid(width: Get.width - 20);
                    }

                    if (state is NearbyRefUpdated) {
                      return RelationsCubitBuilder(
                        onRelationsBuilder: (state) {
                          final blockedRelations = RelationsCubit.getBlockedRelations(
                              state: state, currentUserID: _currentUser!.uid);

                          return StreamFirestoreServerCacheQueryBuilder<Post>(
                            query: _nearbyCubit.searchRef,
                            loader: (context, snapshot) {
                              return LoadingGrid(width: Get.width - 16);
                            },
                            emptyBuilder: (context, snapshot) {
                              return DoubleCirclesWidget(
                                title: RCCubit.instance.getText(R.noPostHere),
                                description: RCCubit.instance.getText(R.whyNotShare),
                                child: const Iconify(
                                  FluentEmojiHighContrast.flower_playing_cards,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              );
                            },
                            builder: (context, snapshot, _) {
                              final widgets = snapshot.docs
                                  .map((doc) => doc.data())
                                  .where(
                                    (post) => !(blockedRelations
                                            ?.any((relation) => relation.uid == post.uid) ??
                                        false),
                                  )
                                  .map(
                                (post) {
                                  final heroTag = const Uuid().v4();
                                  return GestureDetector(
                                    onTap: () => PostPage.show(
                                      post: post,
                                      heroTag: heroTag,
                                    ),
                                    child: DiscoverTabPostCard(post: post, heroTag: heroTag),
                                  );
                                },
                              ).toList();

                              if (widgets.isEmpty) {
                                return MaterialButton(
                                  onPressed: () {
                                    showPostFactoryPage(
                                      currentUser: _currentUser!,
                                      postID: null,
                                    );
                                  },
                                  child: DoubleCirclesWidget(
                                    title: RCCubit.instance.getText(R.noPostHere),
                                    description: RCCubit.instance.getText(R.whyNotShare),
                                    child: const Iconify(
                                      FluentEmojiHighContrast.flower_playing_cards,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              }

                              return MasonryGridView.count(
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                padding:
                                    const EdgeInsets.only(bottom: kBottomNavigationBarHeight * 6),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (snapshot.hasMore && index + 1 == widgets.length) {
                                    snapshot.fetchMore();
                                  }

                                  return widgets[index];
                                },
                                itemCount: widgets.length,
                                crossAxisCount: 2,
                              );
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Hero(
        tag: 'chip-$category',
        child: Material(
          color: Colors.transparent,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
                side: BorderSide(
                  color: Colors.grey[200]!,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
            ),
            child: FittedBox(
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
