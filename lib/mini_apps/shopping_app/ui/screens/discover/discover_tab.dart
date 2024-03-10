import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/discover/bloc.dart';
import 'package:fibali/bloc/relations/relations_bloc_builder.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/discover/nearby_tab.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/post_detail/post_page.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/discover_tab_post_card.dart';
import 'package:fibali/ui/pages/post_factory/post_factory_page.dart';
import 'package:fibali/ui/widgets/categories_list_view_item.dart';
import 'package:fibali/ui/widgets/future_firestore_query_builder.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fluent_emoji_high_contrast.dart';
import 'package:uuid/uuid.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  DiscoverTabState createState() => DiscoverTabState();
}

class DiscoverTabState extends State<DiscoverTab> with AutomaticKeepAliveClientMixin<DiscoverTab> {
  @override
  bool get wantKeepAlive => true;

  DiscoverCubit get _discoverCubit => BlocProvider.of<DiscoverCubit>(context);

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      padding: const EdgeInsets.only(
        bottom: 4.0,
        left: 4.0,
        right: 4.0,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                // ----------------------------------
                // Post Categories List View
                // ----------------------------------
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: _discoverCubit.categories.length,
                //     scrollDirection: Axis.horizontal,
                //     padding: const EdgeInsets.only(left: 10),
                //     itemBuilder: (context, index) {
                //       final category = _discoverCubit.categories[index];
                //       return CategoryChip(category: category);
                //     },
                //   ),
                // ),
                BlocBuilder<DiscoverCubit, DiscoverState>(
                  builder: (context, state) {
                    if (_discoverCubit.selectedCategory != 'nearby') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: GestureDetector(
                          onTap: () {
                            _discoverCubit.selectedCategory = 'nearby';
                            _discoverCubit.refreshSearchRef();
                          },
                          // padding: EdgeInsets.all(0),
                          // backgroundColor: Colors.white70,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.lightBlue, width: 2),
                            ),
                            child: Text(
                              RCCubit.instance.getText(R.nearby).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        // initialValue: PhoneNumber(isoCode: _discoverCubit.countryCode ?? 'US'),
                        // onInputChanged: (PhoneNumber phoneNumber) {
                        //   if (phoneNumber.isoCode != null) {
                        //     _discoverCubit.selectedCategory = 'nearby';
                        //     _discoverCubit.refreshSearchRef();
                        //   }
                        // },
                        // searchBoxDecoration: InputDecoration(
                        //     fillColor: Colors.grey.shade200,
                        //     hintText: RCCubit.instance.getText(R.search),
                        //     hintStyle: const TextStyle(
                        //       color: Colors.grey,
                        //     )),
                        // hasField: false,
                        // selectorConfig: const SelectorConfig(
                        //   selectorType: PhoneInputSelectorType.DIALOG,
                        // ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: GestureDetector(
                            onTap: () {
                              _discoverCubit.selectedCategory = null;
                              _discoverCubit.refreshSearchRef();
                            },
                            child: Chip(
                              padding: const EdgeInsets.all(0),
                              backgroundColor: Colors.lightBlue,
                              label: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(RCCubit.instance.getText(R.nearby).toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                BlocBuilder<DiscoverCubit, DiscoverState>(
                    // buildWhen: (previous, current) => current is DiscoverRefUpdated,
                    builder: (context, state) {
                  return Expanded(
                    child: CategoriesListViewItem(
                      items: _discoverCubit.categories,
                      // choiceStyle: C2ChoiceStyle(
                      //   color: Colors.black,
                      //   backgroundColor: Colors.black38,
                      //   borderColor: Colors.white30,
                      //   labelStyle: Theme.of(context)
                      //       .textTheme
                      //       .labelSmall
                      //       ?.copyWith(color: Colors.white),
                      //   padding: const EdgeInsets.all(0),
                      //   margin: const EdgeInsets.symmetric(horizontal: 1),
                      // ),
                      // choiceActiveStyle: C2ChoiceStyle(
                      //   color: Colors.white,
                      //   backgroundColor: Colors.orangeAccent,
                      //   showCheckmark: false,
                      //   labelStyle: Theme.of(context)
                      //       .textTheme
                      //       .labelMedium
                      //       ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      //   padding: const EdgeInsets.all(0),
                      //   margin: const EdgeInsets.symmetric(horizontal: 1),
                      // ),
                      labels: _discoverCubit.categories
                          .map((category) => RCCubit.instance.getCloudText(context, category))
                          .toList(),
                      hint: RCCubit.instance.getText(R.addSubCategory),
                      value: _discoverCubit.selectedCategory,
                      onChanged: (value) {
                        if (value != null) {
                          if (value != _discoverCubit.selectedCategory) {
                            _discoverCubit.selectedCategory = value;

                            _discoverCubit.showRail = true;
                            _discoverCubit.selectedIndex = null;
                            _discoverCubit.updateCategoriesWidget();
                            _discoverCubit.refreshSearchRef();
                          } else {
                            _discoverCubit.selectedCategory = null;
                            _discoverCubit.showRail = false;
                            _discoverCubit.selectedIndex = null;
                            _discoverCubit.updateCategoriesWidget();
                            _discoverCubit.refreshSearchRef();
                          }
                        }
                      },
                    ),
                  );
                }),
                //------------------------------------
                // Categories Filter Button
                //------------------------------------
                // InkWell(
                //   onTap: () => _openPage(const FilterPage(), context),
                //   child: const Hero(
                //     tag: 'filters-background',
                //     child: Icon(Icons.tune, color: Colors.black),
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // ------------------------------
          // Posts Grid View
          // ------------------------------
          Expanded(
            child: BlocBuilder<DiscoverCubit, DiscoverState>(
              buildWhen: (previous, current) => current is DiscoverRefUpdated,
              builder: (context, state) {
                if (state is DiscoverInitial) {
                  _discoverCubit.refreshSearchRef();
                  return const SizedBox();
                }

                return RelationsCubitBuilder(
                  onRelationsBuilder: (state) {
                    final blockedRelations = RelationsCubit.getBlockedRelations(
                        state: state, currentUserID: _currentUser!.uid);

                    if (_discoverCubit.selectedCategory == 'nearby') return const NearbyTab();

                    return FutureFirestoreServerCacheQueryBuilder<Post>(
                      query: _discoverCubit.searchRef,
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
                            .where((post) => post.isValid())
                            .where(
                              (post) =>
                                  !(blockedRelations?.any((relation) => relation.uid == post.uid) ??
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
                              child: DiscoverTabPostCard(
                                post: post,
                                heroTag: heroTag,
                              ),
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

                        return Column(
                          children: [
                            Expanded(
                              child: MasonryGridView.count(
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
                              ),
                            ),
                            if (snapshot.isFetchingMore)
                              CircularProgressIndicator(color: Colors.grey.shade300),
                          ],
                        );
                      },
                    );

                    // return FirestoreQueryBuilder<Post>(
                    //   query: _discoverCubit.searchRef,

                    // );
                  },
                );
              },
            ),
          ),
        ],
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
