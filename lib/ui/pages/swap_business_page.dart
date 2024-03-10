import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/swap_factory_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_it_grid_page.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SwapBusinessPage extends StatefulWidget {
  const SwapBusinessPage({Key? key}) : super(key: key);

  @override
  SwapBusinessPageState createState() => SwapBusinessPageState();
}

class SwapBusinessPageState extends State<SwapBusinessPage>
    with AutomaticKeepAliveClientMixin<SwapBusinessPage> {
  @override
  bool get wantKeepAlive => true;

  final scaffoldKey = GlobalKey();

  AppUser? get currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          onPressed: () {
            SwapFactoryPage.show(currentUser: currentUser!, itemID: null);
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Get.theme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(RCCubit.instance.getText(R.addItem),
              style: Get.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ))),
      body: const SwapItGridPage(),
    );
  }
}
