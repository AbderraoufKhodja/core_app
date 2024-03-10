import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/swap_events/swap_events_cubit.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/user_swap_items/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_page.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class MakeSwapCard extends StatefulWidget {
  final String chatID;
  final bool initiallyExpanded;
  final Color color;
  final String receiverID;
  final String receiverName;
  final String? receiverPhoto;

  const MakeSwapCard({
    super.key,
    required this.chatID,
    required this.receiverID,
    required this.receiverName,
    required this.receiverPhoto,
    this.initiallyExpanded = false,
    this.color = Colors.white,
  });

  @override
  MakeSwapCardState createState() => MakeSwapCardState();
}

class MakeSwapCardState extends State<MakeSwapCard> {
  bool isSubmitingSwap = false;

  List<SwapItem> _senderItems = [];
  List<SwapItem> _receiverItems = [];

  final _currentUserMultiSelectKey = GlobalKey<FormFieldState>();
  final _interestedUserMultiSelectKey = GlobalKey<FormFieldState>();

  late UserSwapItemsBloc _otherUserSwapItemsBloc;
  final _swapEventsCubit = SwapEventsCubit();

  bool get isSwapButtonActive => _senderItems.isNotEmpty && _senderItems.isNotEmpty;

  String get receiverID => widget.receiverID;
  String get chatID => widget.chatID;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  Size get size => MediaQuery.of(context).size;

  @override
  void initState() {
    _otherUserSwapItemsBloc = UserSwapItemsBloc()..add(LoadUserSwapItemsEvent(userID: receiverID));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Colors.white,
      expandedCrossAxisAlignment: CrossAxisAlignment.center,
      initiallyExpanded: widget.initiallyExpanded,
      title: const Text('Propose a swap:'),
      maintainState: true,
      children: [
        BlocProvider(
          create: (_) => _otherUserSwapItemsBloc,
          child: BlocBuilder<UserSwapItemsBloc, UserSwapItemsState>(
            bloc: _otherUserSwapItemsBloc,
            builder: (_, state) {
              if (state is UserSwapItemsInitialState) {
                _otherUserSwapItemsBloc.add(
                  LoadUserSwapItemsEvent(userID: receiverID),
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

                    // Only show none swapped items
                    final List<SwapItem> items = snapshot.data!.docs
                        .map((doc) => doc.data())
                        .where((item) => item.isSwapped != true)
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: buildMultiSelectItems(
                        multiSelectKey: _interestedUserMultiSelectKey,
                        size: size,
                        items: items,
                        selectedItems: _receiverItems,
                        selectedColor: Colors.redAccent.shade100,
                      ),
                    );
                  },
                );
              }

              return Container(height: size.width / 5);
            },
          ),
        ),
        const SizedBox(height: 6),
        BlocBuilder<UserSwapItemsBloc, UserSwapItemsState>(
          bloc: BlocProvider.of<UserSwapItemsBloc>(context),
          builder: (BuildContext _, UserSwapItemsState state) {
            if (state is UserSwapItemsInitialState) {
              BlocProvider.of<UserSwapItemsBloc>(context)
                  .add(LoadUserSwapItemsEvent(userID: _currentUser!.uid));
            }
            if (state is UserSwapItemsLoadedState) {
              final userSwapItems = state.userSwapItems;
              return StreamBuilder<QuerySnapshot<SwapItem>>(
                stream: userSwapItems,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  // Only show none swapped items
                  final List<SwapItem> items = snapshot.data!.docs
                      .map((doc) => doc.data())
                      .where((item) => item.isSwapped != true)
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: buildMultiSelectItems(
                      multiSelectKey: _currentUserMultiSelectKey,
                      size: size,
                      items: items,
                      selectedItems: _senderItems,
                      selectedColor: Colors.blueAccent.shade100,
                    ),
                  );
                },
              );
            }
            return Container(height: size.width / 5);
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed:
                  _senderItems.isNotEmpty && _receiverItems.isNotEmpty && isSubmitingSwap != true
                      ? _onSwapSubmitted
                      : null,
              child: Text(RCCubit.instance.getText(R.send)),
            ),
          ),
        ),
      ],
    );
  }

  void _onSwapSubmitted() {
    if (isSwapButtonActive) {
      _swapEventsCubit.handleSubmitSwap(
        currentUser: _currentUser!,
        receiverID: widget.receiverID,
        receiverName: widget.receiverName,
        receiverPhoto: widget.receiverPhoto,
        senderItemsID: {for (var item in _senderItems) item.itemID!: item.photoUrls},
        receiverItemsID: {for (var item in _receiverItems) item.itemID!: item.photoUrls},
        price: null,
        finalPrice: null,
        note: null,
      );

      setState(() {
        _senderItems = [];
        _receiverItems = [];
      });
    }
  }

  MultiSelectChipField<SwapItem> buildMultiSelectItems({
    required GlobalKey<FormFieldState> multiSelectKey,
    required Size size,
    required List<SwapItem> items,
    required List<SwapItem> selectedItems,
    required Color selectedColor,
  }) {
    return MultiSelectChipField(
      height: size.width / 5,
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
        child: bd.Badge(
          badgeContent: GestureDetector(
              onTap: () {
                selectedItems.map((swapItem) => swapItem.itemID).contains(item.value?.itemID)
                    ? selectedItems.removeWhere((swapItem) => swapItem.itemID == item.value?.itemID)
                    : selectedItems.add(item.value!);
                state.didChange(selectedItems);
                _currentUserMultiSelectKey.currentState!.validate();
                setState(() {});
              },
              child: Icon(
                Icons.check,
                color: selectedItems.map((swapItem) => swapItem.itemID).contains(item.value?.itemID)
                    ? Colors.white
                    : Colors.transparent,
                size: 12,
              )),
          badgeStyle: bd.BadgeStyle(
            shape: bd.BadgeShape.instagram,
            borderSide: const BorderSide(color: Colors.white),
            badgeColor:
                selectedItems.map((swapItem) => swapItem.itemID).contains(item.value?.itemID)
                    ? selectedColor
                    : Colors.white10,
            padding: const EdgeInsets.all(2),
            elevation: 0,
          ),
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
                height: size.width / 5,
                width: size.width / 5,
                boxShape: BoxShape.rectangle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
