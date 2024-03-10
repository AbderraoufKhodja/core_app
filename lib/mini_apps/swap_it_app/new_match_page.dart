import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/swap_events/swap_events_cubit.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_page.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import 'bloc/user_swap_items/bloc.dart';

class NewMatchPage extends StatefulWidget {
  final AppUser currentUser;
  final String otherUserID;

  const NewMatchPage({
    super.key,
    required this.currentUser,
    required this.otherUserID,
  });

  @override
  NewMatchPageState createState() => NewMatchPageState();
}

class NewMatchPageState extends State<NewMatchPage> {
  bool isSubmitingSwap = false;

  List<SwapItem> _currentUserItems = [];
  List<SwapItem> _otherUserItems = [];

  final _currentUserMultiSelectKey = GlobalKey<FormFieldState>();
  final _interestedUserMultiSelectKey = GlobalKey<FormFieldState>();

  String? otherUserName;
  String? otherUserPhoto;
  late UserSwapItemsBloc _otherUserItemsBloc;

  bool get isSwapButtonActive => _currentUserItems.isNotEmpty && _otherUserItems.isNotEmpty;

  @override
  void initState() {
    _otherUserItemsBloc = UserSwapItemsBloc()
      ..add(LoadUserSwapItemsEvent(userID: widget.otherUserID));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        leading: const PopButton(),
        title: Text(
          RCCubit.instance.getText(R.newMatch),
          style: GoogleFonts.fredokaOne(color: Colors.grey),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: isSwapButtonActive ? _onSwapSubmitted : null,
                label: Text(
                  RCCubit.instance.getText(R.send),
                ),
                icon: const Icon(FontAwesome5.paper_plane),
              ),
            ],
          ),
        ),
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
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(RCCubit.instance.getText(R.congratulation)),
                        subtitle: Text(RCCubit.instance.getText(R.foundNewMatch) +
                            RCCubit.instance.getText(R.proposeSwap)),
                        trailing: Lottie.asset(
                          'assets/5230-ciudad.json',
                          repeat: false,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        BlocBuilder<UserSwapItemsBloc, UserSwapItemsState>(
                          bloc: _otherUserItemsBloc,
                          builder: (_, state) {
                            if (state is UserSwapItemsInitialState) {
                              _otherUserItemsBloc.add(
                                LoadUserSwapItemsEvent(userID: widget.otherUserID),
                              );
                            }

                            if (state is UserSwapItemsLoadedState) {
                              return StreamBuilder<QuerySnapshot<SwapItem>>(
                                stream: state.userSwapItems,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) return Container();

                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Container();
                                  }

                                  if (snapshot.data?.docs.isNotEmpty == true) {
                                    final items =
                                        snapshot.data!.docs.map((doc) => doc.data()).toList();

                                    otherUserName = items.first.ownerName;
                                    otherUserPhoto = items.first.ownerPhoto;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        buildMultiSelectItems(
                                          multiSelectKey: _interestedUserMultiSelectKey,
                                          size: size,
                                          items: items,
                                          selectedItems: _otherUserItems,
                                          selectedColor: Colors.redAccent.shade100,
                                        ),
                                      ],
                                    );
                                  }

                                  return Container(height: size.width / 2);
                                },
                              );
                            }

                            return Container(height: size.width / 2);
                          },
                        ),
                        const Divider(),
                        BlocBuilder<UserSwapItemsBloc, UserSwapItemsState>(
                          bloc: BlocProvider.of<UserSwapItemsBloc>(context),
                          builder: (BuildContext _, UserSwapItemsState state) {
                            if (state is UserSwapItemsInitialState) {
                              BlocProvider.of<UserSwapItemsBloc>(context)
                                  .add(LoadUserSwapItemsEvent(userID: widget.currentUser.uid));
                            }
                            if (state is UserSwapItemsLoadedState) {
                              return StreamBuilder<QuerySnapshot<SwapItem>>(
                                stream: state.userSwapItems,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return Container();

                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Container();
                                  }

                                  final items =
                                      snapshot.data!.docs.map((doc) => doc.data()).toList();

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      buildMultiSelectItems(
                                        multiSelectKey: _currentUserMultiSelectKey,
                                        size: size,
                                        items: items,
                                        selectedItems: _currentUserItems,
                                        selectedColor: Colors.blueAccent.shade100,
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            return Container(height: size.width / 2);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MultiSelectChipField<SwapItem> buildMultiSelectItems({
    required GlobalKey<FormFieldState> multiSelectKey,
    required Size size,
    required List<SwapItem> items,
    required List<SwapItem> selectedItems,
    required Color selectedColor,
  }) {
    return MultiSelectChipField(
      height: size.width / 2,
      showHeader: false,
      decoration: const BoxDecoration(),
      items: items
          .map((item) => MultiSelectItem<SwapItem>(
                item,
                item.title ?? RCCubit.instance.getText(R.item),
              ))
          .toList(),
      key: multiSelectKey,
      itemBuilder: (MultiSelectItem<SwapItem?> item, FormFieldState<List<SwapItem?>> state) =>
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SizedBox(
          width: size.width / 4,
          height: size.width / 2,
          child: bd.Badge(
            badgeStyle: bd.BadgeStyle(
              shape: bd.BadgeShape.instagram,
              elevation: 0,
              borderSide: const BorderSide(color: Colors.white),
              badgeColor:
                  selectedItems.map((swapItem) => swapItem.itemID).contains(item.value?.itemID)
                      ? selectedColor
                      : Colors.white10,
              padding: const EdgeInsets.all(2),
            ),
            badgeContent: GestureDetector(
                onTap: () {
                  selectedItems.map((swapItem) => swapItem.itemID).contains(item.value?.itemID)
                      ? selectedItems
                          .removeWhere((swapItem) => swapItem.itemID == item.value?.itemID)
                      : selectedItems.add(item.value!);
                  state.didChange(selectedItems);
                  _currentUserMultiSelectKey.currentState!.validate();
                  setState(() {});
                },
                child: Icon(
                  Icons.check,
                  color:
                      selectedItems.map((swapItem) => swapItem.itemID).contains(item.value?.itemID)
                          ? Colors.white
                          : Colors.transparent,
                  size: 12,
                )),
            position: bd.BadgePosition.topEnd(end: 10, top: 10),
            child: Card(
              child: GestureDetector(
                onTap: () {
                  SwapItemPage.showPage(
                    swapItemID: item.value!.itemID!,
                    swapItem: null,
                    heroTag: null,
                  );
                },
                child: PhotoWidget.network(
                  photoUrl: item.value!.photoUrls?[0],
                  height: size.width / 2,
                  boxShape: BoxShape.rectangle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSwapSubmitted() async {
    SwapEventsCubit().handleSubmitSwap(
      currentUser: widget.currentUser,
      receiverID: widget.otherUserID,
      receiverName: otherUserName ?? '',
      receiverPhoto: otherUserPhoto,
      senderItemsID: {for (var item in _currentUserItems) item.itemID!: item.photoUrls},
      receiverItemsID: {for (var item in _otherUserItems) item.itemID!: item.photoUrls},
      price: null,
      finalPrice: null,
      note: null,
    );

    await EasyLoading.showToast(
      'Your swap has been submitted\n Keep swapping',
      toastPosition: EasyLoadingToastPosition.center,
      duration: const Duration(seconds: 2),
    );
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);

    setState(() {
      _currentUserItems = [];
      _otherUserItems = [];
    });
  }
}

Future<dynamic>? showNewMatchPage({
  required AppUser currentUser,
  required String otherUserID,
}) {
  return Get.to(
    () => NewMatchPage(
      currentUser: currentUser,
      otherUserID: otherUserID,
    ),
  );
}
