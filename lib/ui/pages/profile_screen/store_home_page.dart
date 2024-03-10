import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fibali/fibali_core/models/store.dart';

class StoreHomePage extends StatelessWidget {
  const StoreHomePage({super.key, required this.store});
  final Store store;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(store.name!),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            labelColor: Colors.black,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.all(15),
            tabs: const [
              Text('home'),
              Text('th'),
              Text('networkWired'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text(store.name!)),
            const Center(
                child: FaIcon(
              FontAwesomeIcons.tableCells,
            )),
            const Center(child: FaIcon(FontAwesomeIcons.networkWired)),
          ],
        ),
      ),
    );
  }
}
