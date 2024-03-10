import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/swap_it_app/instant_match_items.dart';
import 'package:fibali/mini_apps/swap_it_app/matched_items_list_view.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/swap_factory_page.dart';
import 'package:fibali/mini_apps/swap_it_app/user_swap_items_grid.dart';
import 'package:fibali/ui/pages/swaps_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class SwapBoardPage extends StatefulWidget {
  const SwapBoardPage({super.key});

  static Future<dynamic>? showPage() {
    return Get.to(() => const SwapBoardPage());
  }

  @override
  SwapBoardPageState createState() => SwapBoardPageState();
}

final keyOne = GlobalKey();
final keyTwo = GlobalKey();
final keyThree = GlobalKey();

class SwapBoardPageState extends State<SwapBoardPage>
    with AutomaticKeepAliveClientMixin<SwapBoardPage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(RCCubit.instance.getText(R.mySwaps),
            style: GoogleFonts.fredokaOne(color: Colors.grey)),
        elevation: 0,
        leading: const PopButton(),
        actions: [
          IconButton(
            onPressed: () {
              SwapsPage.show();
            },
            icon: const Iconify(
              Mdi.cards,
              size: 34,
              color: Colors.black54,
            ),
          ),
          IconButton(
            onPressed: () {
              SwapFactoryPage.show(currentUser: _currentUser!, itemID: null);
            },
            icon: const Iconify(
              Mdi.plus_circle,
              size: 34,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 8.0)
        ],
      ),
      body: Column(
        children: [
          const Divider(
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                buildTitle(
                  label: RCCubit.instance.getText(R.matches),
                  info: RCCubit.instance.getText(R.matchesInfo),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: MatchedItemsListView(),
                ),
                buildTitle(
                  label: RCCubit.instance.getText(R.instantMatch),
                  info: RCCubit.instance.getText(R.instantMatchInfo),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: InstantMatchSwapItems(),
                ),
                buildTitle(
                  label: RCCubit.instance.getText(R.items),
                  info: RCCubit.instance.getText(R.itemsInfo),
                ),
                const UserSwapItemsGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitle({required String label, required String info}) {
    return ListTile(
      leading: Text(
        label,
        style: GoogleFonts.fredokaOne(fontSize: 16, color: Colors.grey),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.info_outline_rounded, size: 20),
        onPressed: () => Utils.showBlurredDialog(
          child: AlertDialog(
            title: Text(RCCubit.instance.getText(R.info)),
            content: Text(info),
            actions: [
              TextButton(
                child: Text(RCCubit.instance.getText(R.ok)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
