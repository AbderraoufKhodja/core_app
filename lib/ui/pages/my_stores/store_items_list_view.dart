import 'package:fibali/bloc/store_items/bloc.dart';
import 'package:fibali/ui/pages/item_factory_page/item_factory_page.dart';
import 'package:fibali/ui/widgets/animated_fading_items.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/models/store.dart';

class StoreItemsListView extends StatefulWidget {
  final Store store;

  const StoreItemsListView({super.key, required this.store});

  @override
  StoreItemsListViewState createState() => StoreItemsListViewState();
}

class StoreItemsListViewState extends State<StoreItemsListView> {
  final _storeItemsBloc = StoreItemsBloc();

  Size get _size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Item>(
      query: _storeItemsBloc.storeItemsRef.where('storeID', isEqualTo: widget.store.storeID),
      pageSize: 3,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }

        if (snapshot.docs.isEmpty) return SizedBox();

        final items = snapshot.docs;
        List<Widget> gridItems = items
            .map((item) => item.data())
            .where((item) => item.isValid())
            .map((item) => GestureDetector(
                  onTap: () => ItemFactoryPage.show(
                    store: widget.store,
                    storeID: null,
                    itemID: item.itemID,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedFadingItems(
                      urls: item.photoUrls!,
                      shape: BoxShape.rectangle,
                      height: _size.height / 10,
                      width: _size.height / 10,
                    ),
                  ),
                ))
            .toList();

        return SizedBox(
          height: _size.height / 10,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => gridItems[index],
            separatorBuilder: (context, index) => const SizedBox(width: 8.0),
            itemCount: gridItems.length,
          ),
        );
      },
    );
  }
}
