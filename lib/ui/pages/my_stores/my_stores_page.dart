import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/bloc/store_factory/bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/my_stores/store_card.dart';
import 'package:fibali/ui/pages/register_store/store_factory_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:get/get.dart';

class MyStoresPage extends StatefulWidget {
  const MyStoresPage({super.key});

  static Future<dynamic>? show() async {
    return Get.to(() => const MyStoresPage());
  }

  @override
  State<MyStoresPage> createState() => _MyStoresPageState();
}

class _MyStoresPageState extends State<MyStoresPage> {
  final _userStoresBloc = StoreFactoryBloc();
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => StoreFactoryPage.show(),
      ),
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.myStores)),
        leading: const PopButton(),
      ),
      body: BlocBuilder<StoreFactoryBloc, StoreFactoryState>(
        bloc: _userStoresBloc,
        builder: (_, state) {
          if (state is StoreFactoryInitial) {
            _userStoresBloc.add(LoadUserStores(userID: _currentUser!.uid));
          }

          if (state is StoreFactoryLoaded) {
            return StreamBuilder<QuerySnapshot<Store>>(
              stream: state.userStores,
              builder: (_, snapshot) {
                if (snapshot.hasError) return const SizedBox();

                if (snapshot.connectionState == ConnectionState.waiting) return const LoadingGrid();

                if (snapshot.hasData) {
                  final stores = snapshot.data!.docs
                      .map((doc) => doc.data())
                      .where((store) => store.isValid());

                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: stores.map((store) => StoreCard(store: store)).toList(),
                  );
                }

                return const SizedBox();
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
