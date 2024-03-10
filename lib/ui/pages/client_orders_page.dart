import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/all_client_orders_tab.dart';
import 'package:fibali/ui/pages/received_client_orders_tab.dart';
import 'package:fibali/ui/pages/refund_client_orders_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ClientOrdersPage extends StatefulWidget {
  const ClientOrdersPage({Key? key}) : super(key: key);

  @override
  ClientOrdersPageState createState() => ClientOrdersPageState();

  static Future<dynamic>? show() async {
    final needLogIn = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
    if (needLogIn) {
      return null;
    }

    return Get.to(() => const ClientOrdersPage());
  }
}

class ClientOrdersPageState extends State<ClientOrdersPage> {
  AppUser? get currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  Size get size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: const PopButton(),
          title: Text(RCCubit.instance.getText(R.orders)),
          // backgroundColor: Colors.transparent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            TabBar(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.transparent,
              isScrollable: true,
              padding: const EdgeInsets.all(8),
              labelPadding: const EdgeInsets.all(6.0),
              indicator: BoxDecoration(
                color: Colors.redAccent.shade200,
                borderRadius: BorderRadius.circular(15.0),
              ),
              labelStyle: const TextStyle(color: Colors.white),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(RCCubit.instance.getText(R.all)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(RCCubit.instance.getText(R.received)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(RCCubit.instance.getText(R.refund)),
                ),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  AllClientOrdersTab(),
                  ReceivedClientOrdersTab(),
                  RefundClientOrdersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
