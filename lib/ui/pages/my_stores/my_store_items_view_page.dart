import 'package:fibali/bloc/store_items/store_items_bloc.dart';
import 'package:fibali/ui/pages/item_factory_page/item_factory_page.dart';
import 'package:fibali/ui/widgets/animated_fading_items.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/models/store.dart';

class MyStoreItemsViewPage extends StatefulWidget {
  const MyStoreItemsViewPage({required this.store});
  final Store store;
  @override
  State<MyStoreItemsViewPage> createState() => _MyStoreItemsViewPageState();
}

class _MyStoreItemsViewPageState extends State<MyStoreItemsViewPage> {
  final _storeItemsBloc = StoreItemsBloc();
  Store get _store => widget.store;
  Size get _size => MediaQuery.of(context).size;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => ItemFactoryPage.show(
                store: _store,
                storeID: null,
                itemID: null,
              ),
          label: FaIcon(FontAwesomeIcons.plus)),
      body: FirestoreQueryBuilder<Item>(
        query: _storeItemsBloc.storeItemsRef.where('storeID', isEqualTo: widget.store.storeID),
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('error ${snapshot.error}');
          }

          if (snapshot.docs.isEmpty) return const SizedBox();

          final items = snapshot.docs;
          List<Widget> gridItems = items
              .map((item) => item.data())
              .where((item) => item.isValid())
              .map((item) => ListTile(
                    onTap: () => ItemFactoryPage.show(
                      store: widget.store,
                      storeID: null,
                      itemID: item.itemID,
                    ),
                    title: Text(item.title ?? ''),
                    subtitle: Text(item.description ?? ''),
                    leading: SizedBox(
                      height: _size.height / 8,
                      width: _size.height / 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedFadingItems(
                          urls: item.photoUrls!,
                          shape: BoxShape.rectangle,
                          height: _size.height / 8,
                          width: _size.height / 8,
                        ),
                      ),
                    ),
                  ))
              .toList();

          return ListView.separated(
            itemBuilder: (context, index) {
              // if we reached the end of the currently obtained items, we try to
              // obtain more items
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                // Tell FirestoreQueryBuilder to try to obtain more items.
                // It is safe to call this function from within the build method.
                snapshot.fetchMore();
              }
              return gridItems[index];
            },
            separatorBuilder: (context, index) => const SizedBox(width: 8.0),
            itemCount: gridItems.length,
          );
        },
      ),
    );
  }
}
