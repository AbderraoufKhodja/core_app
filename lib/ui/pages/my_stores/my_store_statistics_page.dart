import 'package:fibali/fibali_core/models/store.dart';
import 'package:flutter/material.dart';

class MyStoreStatisticsPage extends StatelessWidget {
  const MyStoreStatisticsPage({
    Key? key,
    required Store store,
  })  : _store = store,
        super(key: key);

  final Store _store;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Text('avgRating'),
          title: Text(_store.avgRating?.toStringAsFixed(1) ?? ''),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        ),
        ListTile(
          leading: Text('numRatings'),
          title: Text(_store.numRatings?.toString() ?? ''),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        ),
        ListTile(
          leading: Text('numReviews'),
          title: Text(_store.numReviews?.toString() ?? ''),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        ),
        ListTile(
          leading: Text('numLikes'),
          title: Text(_store.numLikes?.toString() ?? ''),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        ),
        ListTile(
          leading: Text('numRefunds'),
          title: Text(_store.numRefunds?.toString() ?? ''),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        ),
        ListTile(
          leading: Text('numReceptions'),
          title: Text(_store.numReceptions?.toString() ?? ''),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        ),
        ListTile(
          leading: Text('numOrders'),
          title: Text(_store.numOrders?.toString() ?? ''),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        ),
        ListTile(
          leading: Text('numPackagesSent'),
          title: Text(_store.numPackagesSent?.toString() ?? ''),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        ),
        ListTile(
          leading: Text('numConfirmations'),
          title: Text(_store.numConfirmations?.toStringAsFixed(1) ?? ''),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        ),
        ListTile(
          leading: Text('numReminders'),
          title: Text(_store.numReminders?.toString() ?? ''),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        ),
      ],
    );
  }
}
