import 'package:fibali/bloc/store_factory/store_factory_bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/my_stores/my_store_info_page.dart';
import 'package:fibali/ui/pages/my_stores/my_store_items_view_page.dart';
import 'package:fibali/ui/pages/my_stores/my_store_statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:get/get.dart';

class MyStorePage extends StatefulWidget {
  final Store store;

  const MyStorePage({super.key, required this.store});

  static Future<dynamic>? show({required Store store}) {
    return Get.to(
      () => BlocProvider(
        create: (context) => StoreFactoryBloc(),
        child: MyStorePage(store: store),
      ),
    );
  }

  @override
  MyStorePageState createState() => MyStorePageState();
}

class MyStorePageState extends State<MyStorePage> {
  Store get _store => widget.store;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(RCCubit.instance.getText(R.storeInfo)),
          leading: const PopButton(color: Colors.grey),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            indicatorColor: Colors.transparent,
            tabs: [
              Text(RCCubit.instance.getText(R.items)),
              Text(RCCubit.instance.getText(R.stats)),
              Text(RCCubit.instance.getText(R.info)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyStoreItemsViewPage(store: _store),
            MyStoreStatisticsPage(store: _store),
            MyStoreInfoPage(store: _store),
          ],
        ),
      ),
    );
  }
}
