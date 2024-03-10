import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/store_factory/bloc.dart';
import 'package:fibali/ui/pages/register_store/fill_author_info_tab.dart';
import 'package:fibali/ui/pages/register_store/fill_store_address_tab.dart';
import 'package:fibali/ui/pages/register_store/fill_store_info_tab.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:get/get.dart';

class StoreFactoryPage extends StatefulWidget {
  const StoreFactoryPage({super.key});

  static Future<dynamic>? show() {
    return Get.to(
      () => BlocProvider(
        create: (context) => StoreFactoryBloc(),
        child: const StoreFactoryPage(),
      ),
    );
  }

  @override
  State<StoreFactoryPage> createState() => _StoreFactoryPageState();
}

class _StoreFactoryPageState extends State<StoreFactoryPage> with TickerProviderStateMixin {
  StoreFactoryBloc get _storeFactory => BlocProvider.of<StoreFactoryBloc>(context);
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 3)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: const PopButton(),
            title: Text(RCCubit.instance.getText(R.createNewStore)),
            centerTitle: true,
            bottom: TabBar(
              controller: _controller,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              tabs: [
                Icon(FluentIcons.building_shop_20_regular,
                    size: 30, color: _storeFactory.isKeyValid1 == false ? Colors.red : null),
                Icon(FluentIcons.guest_20_regular,
                    size: 30, color: _storeFactory.isKeyValid2 == false ? Colors.red : null),
                Icon(FluentIcons.city_20_regular,
                    size: 30, color: _storeFactory.isKeyValid3 == false ? Colors.red : null),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            child: TabBarView(
              controller: _controller,
              children: const [
                FillStoreInfoTab(),
                FillAuthorInfoTab(),
                FillStoreAddressTab(),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16.0),
            height: 80,
            color: Colors.grey.shade300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _controller.index == 0
                      ? null
                      : () {
                          if (_controller.index > 0) _controller.animateTo(_controller.index - 1);
                        },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
                const Spacer(),
                ElevatedButton(
                  style: _controller.index == _controller.length - 1
                      ? ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                        )
                      : ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                        ),
                  onPressed: _controller.index == _controller.length - 1
                      ? _onSubmitted
                      : () {
                          if (_controller.index < _controller.length) {
                            _controller.animateTo(_controller.index + 1);
                          }
                        },
                  child: _controller.index == _controller.length - 1
                      ? Text(
                          RCCubit.instance.getText(R.submit),
                          style: const TextStyle(color: Colors.deepOrange),
                        )
                      : const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black54,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmitted() async {
    if (_currentUser != null && _storeFactory.validate()) {
      await _storeFactory.handleOpenStore(
        context,
        storeOwnerID: _currentUser!.uid,
        description: _storeFactory.description!,
        storeName: _storeFactory.storeName!,
        authorFirstName: _storeFactory.authorFirstName!,
        authorLastName: _storeFactory.authorLastName!,
        phoneNumber: _storeFactory.phoneNumber!,
        dialCode: _storeFactory.dialCode!,
        logoFile: _storeFactory.logoFile!,
        backgroundFile: _storeFactory.backgroundFile!,
        currency: _storeFactory.currency!,
        country: _storeFactory.country!,
        province: _storeFactory.province,
        subProvince: _storeFactory.subProvince,
        subSubProvince: _storeFactory.subSubProvince,
        keywords: _storeFactory.keywords.isNotEmpty ? _storeFactory.keywords : null,
        streetAddress: _storeFactory.streetAddress!,
      );
    }
  }
}
