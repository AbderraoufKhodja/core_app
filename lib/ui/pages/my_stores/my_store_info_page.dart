import 'package:fibali/bloc/store_factory/bloc.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/ui/pages/my_stores/edit_my_store_info_page.dart';
import 'package:fibali/ui/pages/my_stores/view_my_store_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyStoreInfoPage extends StatefulWidget {
  final Store store;

  const MyStoreInfoPage({Key? key, required this.store}) : super(key: key);

  @override
  State<MyStoreInfoPage> createState() => _MyStoreInfoPageState();
}

class _MyStoreInfoPageState extends State<MyStoreInfoPage> {
  StoreFactoryBloc get _userStoresBloc => BlocProvider.of<StoreFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: FaIcon(
              _userStoresBloc.editEnabled
                  ? FontAwesomeIcons.circleXmark
                  : FontAwesomeIcons.penToSquare,
              color: Colors.grey,
            ),
            onPressed: () => setState(() {
              _userStoresBloc.editEnabled = !_userStoresBloc.editEnabled;
            }),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: _userStoresBloc.editEnabled
          ? EditMyStoreInfoPage(
              store: widget.store,
              onSubmitted: () {
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  setState(() {
                    _userStoresBloc.editEnabled = false;
                  });
                });
              },
            )
          : ViewMyStoreInfoPage(store: widget.store),
    );
  }
}
