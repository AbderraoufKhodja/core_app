import 'dart:ui';

import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/bloc/item/item_bloc.dart';
import 'package:fibali/bloc/reviews/reviews_bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/ui/widgets/animated_fading_items.dart';
import 'package:fibali/ui/widgets/check_order_page.dart';
import 'package:fibali/ui/widgets/favorite_button.dart';
import 'package:fibali/ui/widgets/item_card.dart';
import 'package:fibali/ui/widgets/like_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/widgets/search_progress_ripple.dart';
import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/models/shopping_review.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

class ItemPage extends StatefulWidget {
  final String itemID;
  final String? photo;
  final String storeID;

  const ItemPage({
    Key? key,
    required this.itemID,
    required this.photo,
    required this.storeID,
  }) : super(key: key);

  @override
  ItemPageState createState() => ItemPageState();
}

class ItemPageState extends State<ItemPage> {
  final _reviewsBloc = ReviewsBloc();

  String get _itemID => widget.itemID;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  ItemBloc get _itemBloc => BlocProvider.of<ItemBloc>(context);

  @override
  void initState() {
    super.initState();
    _reviewsBloc.add(LoadReviews(itemID: _itemID));
    _itemBloc.addViewItem(
      storeID: widget.storeID,
      uid: _currentUser!.uid,
      itemID: _itemID,
      photo: widget.photo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white70,
        elevation: 0,
        child: const PopButton(),
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (_, state) {
          if (state is ItemInitial) _itemBloc.add(LoadItem(itemID: _itemID));

          if (state is ItemLoaded) {
            return StreamBuilder<DocumentSnapshot<Item>>(
              stream: state.item,
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  return const SizedBox();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingGrid();
                }

                if (snapshot.data?.exists == false) {
                  return const Center(child: Text('no item'));
                }

                final item = snapshot.data!.data()!;

                return Stack(
                  children: [
                    PhotoWidgetNetwork(
                      label: null,
                      photoUrl: item.photoUrls![0],
                      fit: BoxFit.cover,
                      height: Get.height,
                      width: Get.width,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.0),
                        ),
                      ),
                    ),
                    Scaffold(
                      extendBodyBehindAppBar: true,
                      extendBody: true,
                      backgroundColor: Colors.transparent,
                      body: ListView(
                        children: [
                          _buildItemContent(item: item),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(),
                          ),
                          _buildSimilarItems(item: item),
                        ],
                      ),
                      bottomNavigationBar: _buildBottomBar(context, item),
                    ),
                  ],
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSimilarItems({required Item item}) {
    return FirestoreQueryBuilder<Item>(
      query: Item.ref
          .where(
            ItemLabels.keywords.name,
            arrayContainsAny: item.keywords,
          )
          .where(ItemLabels.itemID.name, isNotEqualTo: item.itemID),
      pageSize: 10,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const SearchProgressRipple();
        }
        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }

        final validItems =
            snapshot.docs.map((doc) => doc.data()).where((item) => item.isValid()).toList();

        return MasonryGridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          padding: const EdgeInsets.only(
            right: 4.0,
            left: 4.0,
            top: 4.0,
            bottom: kBottomNavigationBarHeight,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            // if we reached the end of the currently obtained items, we try to
            // obtain more items
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }

            final thisItem = validItems[index];
            return GestureDetector(
              onTap: () {
                showItemPage(
                  itemID: thisItem.itemID!,
                  photo: thisItem.photoUrls![0],
                  storeID: thisItem.storeID!,
                );
              },
              child: ItemCard(item: thisItem),
            );
          },
          // staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
          itemCount: validItems.length,
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, Item item) {
    return BottomAppBar(
      padding: const EdgeInsets.all(8.0),
      color: Get.theme.bottomAppBarTheme.color?.withOpacity(0.8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // IconButton(
              //   onPressed: () {
              //     showStorePage(context, storeID: _item.storeID!);
              //   },
              //   icon: FaIcon(
              //     FontAwesomeIcons.store,
              //     color: Colors.grey,
              //   ),
              // ),
              IconButton(
                onPressed: () {
                  if (_currentUser != null) {
                    final typeChatID = '${ChatTypes.shopping.name}_${Utils.getUniqueID(
                      firstID: _currentUser!.uid,
                      secondID: item.storeOwnerID!,
                    )}';
                    showMessagingPage(
                      chatID: typeChatID,
                      type: ChatTypes.shopping,
                      otherUserID: item.storeOwnerID!,
                    );
                  } else {
                    Get.snackbar(
                      'Not logged in',
                      'Please log in first',
                      onTap: (_) => () {},
                      duration: const Duration(seconds: 4),
                      animationDuration: const Duration(milliseconds: 800),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                icon: const FaIcon(
                  FontAwesomeIcons.solidComments,
                  color: Colors.grey,
                ),
              ),
              FavoriteButton(item: item),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                // ElevatedButton(
                //   onPressed: () {},
                //   child: FaIcon(FontAwesomeIcons.cartPlus),
                //   style: ElevatedButton.styleFrom(
                //     fixedSize: Size(Get.width / 4, Get.height / 18),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(30.0),
                //         bottomLeft: Radius.circular(30.0),
                //       ),
                //     ),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    CheckOrderPage.show(item: item);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(Get.width / 4, Get.height / 18),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text(RCCubit.instance.getText(R.order)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemContent({required Item item}) {
    final widgets = Column(children: [
      Card(
        color: Get.theme.cardColor.withOpacity(0.8),
        elevation: 0,
        child: SizedBox(
          height: Get.height / 2.5,
          child: bd.Badge(
            position: bd.BadgePosition.custom(bottom: 10),
            badgeStyle: const bd.BadgeStyle(
              shape: bd.BadgeShape.circle,
              badgeColor: Colors.transparent,
              elevation: 0,
            ),
            showBadge: true,
            badgeContent: const TabPageSelector(
              selectedColor: Colors.white70,
              indicatorSize: 10,
            ),
            child: TabBarView(
              children: item.photoUrls!
                  .map(
                    (url) => PhotoWidgetNetwork(
                      label: null,
                      photoUrl: url,
                      fit: BoxFit.fitHeight,
                      canDisplay: true,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
      Column(
        children: [
          Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              color: Get.theme.cardColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              item.title!,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 50,
                                  color: Colors.transparent,
                                  child: LikeButton(item: item),
                                ),
                                Container(
                                  width: 50,
                                  height: 30,
                                  color: Colors.grey.shade200,
                                  child: FittedBox(
                                    child: Text(item.numLikes?.toString() ?? '',
                                        style: const TextStyle(color: Colors.grey)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      subtitle: Text(
                        item.description!,
                        maxLines: 6,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 64.0),
                      child: Divider(height: 0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!kIsWeb)
                          IconButton(
                              onPressed: () {
                                _itemBloc.handleShareShoppingItem(context, item: item);
                              },
                              icon: const Icon(Icons.share)),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '${item.price!.toStringAsFixed(2)} ${item.currency ?? ''}',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.red.shade300,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [FaIcon(FontAwesomeIcons.balanceScale), FaIcon(FontAwesomeIcons.share)],
                    // )
                  ],
                ),
              ),
            ),
          ),
          _buildReviews(item: item),
          Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: item.frequentlyAQ != null
                    ? Column(
                        children: [
                          ListTile(
                            leading: Text(RCCubit.instance.getText(R.frequentlyAskedQuestions),
                                style: const TextStyle(fontSize: 20)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '(${item.frequentlyAQ!.entries.length})',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                GestureDetector(
                                  onTap: _showFrequentlyAQ,
                                  child: const Icon(Icons.arrow_forward_ios_rounded),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(height: 0),
                          ),
                          Column(
                            children: item.frequentlyAQ!.entries.map((entry) {
                              return ListTile(
                                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                title: Text(entry.key),
                                subtitle: Text(entry.value),
                                horizontalTitleGap: 0,
                                dense: true,
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    ]);
    return DefaultTabController(
      initialIndex: 0,
      length: item.photoUrls!.length,
      child: widgets,
    );
  }

  Widget _buildReviews({required Item item}) {
    return FirestoreQueryBuilder<ShoppingReview>(
      query: ShoppingReview.ref
          .where(SRLabels.itemID.name, isEqualTo: _itemID)
          .where(SRLabels.reviewText.name, isGreaterThan: ''),
      pageSize: 4,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const CircularProgressIndicator();
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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: bd.Badge(
            position: bd.BadgePosition.topStart(top: -28, start: 50),
            badgeStyle: const bd.BadgeStyle(
              shape: bd.BadgeShape.circle,
              badgeColor: Colors.transparent,
              elevation: 0,
            ),
            badgeContent: Chip(
              label: Text(
                (item.avgRating?.toStringAsFixed(1) ?? '.'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            child: Card(
              color: Colors.grey[50],
              elevation: 0,
              child: Column(
                children: [
                  ListTile(
                    leading: Text(
                      RCCubit.instance.getText(R.reviews),
                      style: const TextStyle(fontSize: 20),
                    ),
                    title: RatingBarIndicator(
                      rating: item.avgRating!.toDouble(),
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 25.0,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '(${item.numRatings})',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: _showReviews,
                          child: const Icon(Icons.arrow_forward_ios_rounded),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(height: 0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: snapshot.docs.map((doc) {
                        final review = doc.data();
                        return ListTile(
                          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                          trailing: review.photoUrls != null
                              ? SizedBox.square(
                                  dimension: 50,
                                  child: AnimatedFadingItems(
                                    shape: BoxShape.rectangle,
                                    urls: review.photoUrls!,
                                  ),
                                )
                              : null,
                          title: Text(review.userName!),
                          subtitle: Text(review.reviewText!),
                          horizontalTitleGap: 0,
                          leading: Text(review.rating?.toStringAsFixed(1) ?? ''),
                          dense: true,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showReviews() {}

  void _showFrequentlyAQ() {}
}

Future<dynamic>? showItemPage({
  required String itemID,
  required String storeID,
  required String? photo,
}) {
  return Get.to(
    () => BlocProvider(
      create: (context) => ItemBloc()..add(LoadItem(itemID: itemID)),
      child: ItemPage(itemID: itemID, storeID: storeID, photo: photo),
    ),
  );
}
