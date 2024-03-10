import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/ui/pages/swap_item_report_page.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/swap_item/swap_item_bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/swap_factory_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_header.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'bloc/swap_factory/bloc.dart';

class SwapItemPage extends StatefulWidget {
  const SwapItemPage({
    super.key,
    required this.swapItem,
    required this.heroTag,
  });

  final SwapItem swapItem;
  final String? heroTag;

  @override
  State<SwapItemPage> createState() => _SwapItemPageState();

  static Future<dynamic>? showPage({
    String? swapItemID,
    required SwapItem? swapItem,
    required String? heroTag,
  }) {
    if (swapItem != null) {
      return Get.to(() => SwapItemPage(swapItem: swapItem, heroTag: heroTag));
    } else if (swapItemID != null) {
      EasyLoading.show(dismissOnTap: true);
      SwapItem.ref.doc(swapItemID).get().then((swapDoc) {
        EasyLoading.dismiss();
        if (swapDoc.data() != null) {
          return Get.to(() => SwapItemPage(swapItem: swapDoc.data()!, heroTag: heroTag));
        }
      }).whenComplete(() => EasyLoading.dismiss());
    }

    return null;
  }
}

class _SwapItemPageState extends State<SwapItemPage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  SwapItemBloc get _swapItemBloc => BlocProvider.of<SwapItemBloc>(context);

  @override
  void initState() {
    _swapItemBloc.addViewSwapItem(
      photo: widget.swapItem.photoUrls?[0],
      itemID: widget.swapItem.itemID!,
      uid: _currentUser!.uid,
      swapItem: widget.swapItem,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<String>(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) {
                return [
                  if (_currentUser?.uid != null && _currentUser?.uid != widget.swapItem.uid)
                    PopupMenuItem<String>(
                      value: null,
                      child: Text(RCCubit.instance.getText(R.report)),
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        SwapItemReportPage.showPage(
                          reportedUserName: widget.swapItem.ownerName!,
                          reportedUserUID: widget.swapItem.uid!,
                          reportedItemID: widget.swapItem.itemID!,
                        );
                      },
                    ),
                  if (_currentUser?.uid != null && _currentUser?.uid == widget.swapItem.uid)
                    PopupMenuItem<String>(
                      value: null,
                      child: Text(RCCubit.instance.getText(R.edit)),
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        SwapFactoryPage.show(
                          currentUser: _currentUser!,
                          itemID: widget.swapItem.itemID,
                        );
                      },
                    ),
                  if (_currentUser?.uid == widget.swapItem.uid)
                    PopupMenuItem<String>(
                      value: null,
                      child: Text(RCCubit.instance.getText(R.delete)),
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        showRemoveSwapItem();
                      },
                    ),
                ];
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white70,
        onPressed: () {},
        child: const PopButton(color: Colors.black26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SwapItemHeader(
        swapItem: widget.swapItem,
        percent: 0.5,
        heroTag: widget.heroTag,
      ),
    );
  }

  void showRemoveSwapItem() {
    Utils.showBlurredDialog(
      child: AlertDialog(
        title: Text(RCCubit.instance.getText(R.delete)),
        content: Text(RCCubit.instance.getText(R.deleteItemWarning)),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(RCCubit.instance.getText(R.cancel)),
          ),
          TextButton(
            onPressed: () async {
              await SwapFactoryBloc.handleDeleteSwapItem(swapItem: widget.swapItem);
              Get.back();
              Get.back();
            },
            child: Text(RCCubit.instance.getText(R.delete)),
          ),
        ],
      ),
    );
  }
}
