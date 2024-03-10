import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/view_history/posts_history_view_tab.dart';
import 'package:fibali/ui/pages/view_history/shopping_items_history_view_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ViewHistoryPage extends StatefulWidget {
  const ViewHistoryPage({super.key});

  static Future<dynamic>? show() async {
    final needLogIn = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
    if (needLogIn) {
      return null;
    }

    return Get.to(() => const ViewHistoryPage());
  }

  @override
  ViewHistoryPageState createState() => ViewHistoryPageState();
}

class ViewHistoryPageState extends State<ViewHistoryPage>
    with AutomaticKeepAliveClientMixin<ViewHistoryPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(RCCubit.instance.getText(R.history)),
          leading: const PopButton(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.transparent,
              isScrollable: true,
              padding: const EdgeInsets.all(8),
              labelPadding: const EdgeInsets.all(6.0),
              indicator: BoxDecoration(
                color: Colors.orangeAccent.shade200,
                borderRadius: BorderRadius.circular(15.0),
              ),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(RCCubit.instance.getText(R.posts))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(RCCubit.instance.getText(R.shopping)),
                ),
              ],
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TabBarView(
                  children: [
                    PostsHistoryViewTab(),
                    ShoppingItemsHistoryViewTab(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
