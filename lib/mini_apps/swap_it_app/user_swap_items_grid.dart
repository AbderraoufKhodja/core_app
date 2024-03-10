import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/user_swap_items/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/swap_factory_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swapped_stamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class UserSwapItemsGrid extends StatefulWidget {
  const UserSwapItemsGrid({super.key});

  @override
  UserSwapItemsGridState createState() => UserSwapItemsGridState();
}

class UserSwapItemsGridState extends State<UserSwapItemsGrid> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSwapItemsBloc, UserSwapItemsState>(
      builder: (_, state) {
        if (state is UserSwapItemsInitialState) {
          BlocProvider.of<UserSwapItemsBloc>(context)
              .add(LoadUserSwapItemsEvent(userID: _currentUser!.uid));
        }
        if (state is UserSwapItemsLoadedState) {
          return StreamBuilder<QuerySnapshot<SwapItem>>(
            stream: state.userSwapItems,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingGrid(width: Get.width - 16);
              }

              final List<QueryDocumentSnapshot<SwapItem>> items = snapshot.data!.docs;
              final gridItems = items.map((item) {
                final currentItem = item.data();

                return GestureDetector(
                  onTap: () {
                    final heroTag = const Uuid().v4();
                    SwapItemPage.showPage(swapItem: currentItem, heroTag: heroTag);
                  },
                  child: bd.Badge(
                      stackFit: StackFit.expand,
                      badgeStyle: const bd.BadgeStyle(
                        shape: bd.BadgeShape.instagram,
                        badgeColor: Colors.transparent,
                        elevation: 0,
                      ),
                      showBadge: currentItem.isSwapped == true,
                      position: bd.BadgePosition.bottomEnd(),
                      badgeContent: SwappedStamp(size: Get.width / 2, angle: -0.5),
                      child: Card(
                        margin: const EdgeInsets.all(0),
                        child: PhotoWidget.network(photoUrl: currentItem.photoUrls?[0]),
                      )),
                );
              }).toList();

              gridItems.add(buildAddItemWidget());

              return GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                crossAxisCount: 3,
                children: gridItems,
              );
            },
          );
        }
        return Container();
      },
    );
  }

  Widget buildItemImageButton(IconData iconData, {required Function() onPressed}) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: IconButton(
        icon: FaIcon(iconData),
        onPressed: () {},
      ),
    ));
  }

  GestureDetector buildAddItemWidget() {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.add_a_photo_rounded,
          size: Get.width / 8,
          color: Colors.grey,
        ),
      ),
      onTap: () {
        SwapFactoryPage.show(currentUser: _currentUser!, itemID: null);
      },
    );
  }
}
