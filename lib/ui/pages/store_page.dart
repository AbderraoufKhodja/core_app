import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'profile_screen/store_home_page.dart';

class StorePage extends StatefulWidget {
  final String storeID;

  const StorePage({super.key, required this.storeID});

  @override
  StorePageState createState() => StorePageState();

  static Future<dynamic>? show({required String storeID}) {
    return Get.to(() => StorePage(storeID: storeID));
  }
}

class StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Store>>(
      future: Store.ref.doc(widget.storeID).get(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return const SizedBox();

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingGrid(width: Get.width - 16);
        }

        if (!snapshot.hasData)
          return Center(child: Text(RCCubit.instance.getText(R.storeNotFound)));

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data?.data()?.isValid() == true) {
            final store = snapshot.data!.data()!;

            return DefaultTabController(
              initialIndex: 0,
              length: 5,
              child: Scaffold(
                body: TabBarView(
                  children: [
                    StoreHomePage(store: store),
                    const Center(child: Text('empty')),
                    const Center(child: Text('empty')),
                    const Center(child: Text('empty')),
                    const Center(child: Text('empty')),
                  ],
                ),
                bottomNavigationBar: TabBar(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  labelColor: Colors.black,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  padding: const EdgeInsets.all(5),
                  tabs: [
                    PhotoWidgetNetwork(
                      label: Utils.getInitial(store.name),
                      photoUrl: store.logo ?? '',
                      boxShape: BoxShape.circle,
                      height: Get.size.height / 18,
                      width: Get.size.height / 18,
                    ),
                    const FaIcon(FontAwesomeIcons.tableCells),
                    const FaIcon(FontAwesomeIcons.networkWired),
                    const FaIcon(FontAwesomeIcons.list),
                    const FaIcon(FontAwesomeIcons.comments),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                    title: Text(RCCubit.instance.getText(R.store)), leading: const PopButton()),
                body: Center(child: Text(RCCubit.instance.getText(R.storeNotAvailable))));
          }
        }

        return Scaffold(
            appBar:
                AppBar(title: Text(RCCubit.instance.getText(R.store)), leading: const PopButton()),
            body: Center(child: Text(RCCubit.instance.getText(R.oopsSomethingWentWrong))));
      },
    );
  }
}
