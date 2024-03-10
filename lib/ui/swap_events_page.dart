import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/swap/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/swap_events/swap_events_cubit.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_card_2.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_page.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/ui/submit_swap_review_page.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/swap.dart';
import 'package:fibali/fibali_core/models/swap_event.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/entypo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class SwapEventsPage extends StatefulWidget {
  final String swapID;

  const SwapEventsPage({Key? key, required this.swapID}) : super(key: key);

  @override
  SwapEventsPageState createState() => SwapEventsPageState();

  static Future<dynamic>? showPage({required String swapID}) {
    return Get.to(() => SwapEventsPage(swapID: swapID));
  }
}

class SwapEventsPageState extends State<SwapEventsPage> {
  final swapEventsBloc = SwapLogicBloc();

  final _swapEventsCubit = SwapEventsCubit();

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  void initState() {
    super.initState();
    swapEventsBloc.add(LoadSwapLogic(swapID: widget.swapID));

    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString("currentSwapID", widget.swapID));

    swapEventsBloc.markAsSeen(
      currentUserID: _currentUser!.uid,
      swapID: widget.swapID,
    );
  }

  String _otherUserID({required Swap swap}) {
    if (swap.senderID == _currentUser!.uid) {
      return swap.receiverID!;
    } else {
      return swap.senderID!;
    }
  }

  String _otherUserName({required Swap swap}) {
    if (swap.senderID == _currentUser!.uid) {
      return swap.receiverName!;
    } else {
      return swap.senderName!;
    }
  }

  String? _otherUserPhoto({required Swap swap}) {
    if (swap.senderID == _currentUser!.uid) {
      return swap.receiverPhoto;
    } else {
      return swap.senderPhoto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        swapEventsBloc.markAsSeen(
          currentUserID: _currentUser!.uid,
          swapID: widget.swapID,
        );

        return Future.value(true);
      },
      child: StreamBuilder<DocumentSnapshot<Swap>>(
        stream: Swap.ref.doc(widget.swapID).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingGrid(width: Get.width);
          }

          final swap = snapshot.data!.data();

          if (snapshot.hasData && swap != null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(RCCubit.instance.getText(R.details)),
                leading: PopButton(
                  onPressed: () {
                    swapEventsBloc.markAsSeen(
                      currentUserID: _currentUser!.uid,
                      swapID: widget.swapID,
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                height: kBottomNavigationBarHeight,
                child: ListTile(
                  title: _buildSwapActionsButton(swap: swap),
                  trailing: IconButton(
                    onPressed: () => _showMessaging(swap: swap),
                    icon: const Icon(FontAwesomeIcons.solidComments),
                  ),
                ),
              ),
              body: _buildBody(swap: swap),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildBody({required Swap swap}) {
    return BlocBuilder<SwapLogicBloc, SwapLogicState>(
      bloc: swapEventsBloc,
      builder: (context, state) {
        if (state is SwapLogicInitial) {
          swapEventsBloc.add(LoadSwapLogic(swapID: swap.swapID!));
        }
        if (state is SwapLogicLoaded) {
          return StreamBuilder<QuerySnapshot<SwapEvent>>(
            stream: state.swapEvents,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data?.docs.isNotEmpty == true) {
                return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: snapshot.data!.docs
                        .map((swapEvents) => swapEvents.data())
                        .where((swapEvent) => swapEvent.isValid())
                        .map(
                          (swapEvent) => SwapEventTile(swapEvent: swapEvent),
                        )
                        .toList());
              }

              return const SizedBox();
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSwapActionsButton({required Swap swap}) {
    switch (Utils.enumFromString(SETypes.values, swap.lastSwapEvent?['type'])) {
      case SETypes.newSwap:
        if (swap.senderID == _currentUser!.uid) {
          return Row(
            children: [
              TextButton(
                onPressed: () => _swapEventsCubit.handleCancel(
                  context,
                  swapID: swap.swapID!,
                  currentUser: _currentUser!,
                  receiverID: _otherUserID(swap: swap),
                  receiverName: _otherUserName(swap: swap),
                  receiverPhoto: _otherUserPhoto(swap: swap),
                ),
                child: Text(RCCubit.instance.getText(R.cancel)),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => _swapEventsCubit.handleDeclineSwap(
                    context,
                    swapID: swap.swapID!,
                    currentUser: _currentUser!,
                    receiverID: _otherUserID(swap: swap),
                    receiverName: _otherUserName(swap: swap),
                    receiverPhoto: _otherUserPhoto(swap: swap),
                  ),
                  child: Text(RCCubit.instance.getText(R.decline)),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _swapEventsCubit.handleAcceptSwap(
                    context,
                    swapID: swap.swapID!,
                    currentUser: _currentUser!,
                    receiverID: _otherUserID(swap: swap),
                    receiverName: _otherUserName(swap: swap),
                    receiverPhoto: _otherUserPhoto(swap: swap),
                    receiverItemsID: swap.receiverItemsID,
                    senderItemsID: swap.senderItemsID,
                  ),
                  child: Text(RCCubit.instance.getText(R.accept)),
                ),
              ),
            ],
          );
        }
      case SETypes.swapDeclined:
        return const SizedBox();
      case SETypes.swapAccepted:
        // TODO: Handle this case.
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => SubmitSwapReviewPage.showPage(
                  onSubmitted: (rating, comment, photoFiles) {
                    _swapEventsCubit.handleAddSwapReview(
                      context,
                      swapID: swap.swapID!,
                      currentUser: _currentUser!,
                      receiverID: _otherUserID(swap: swap),
                      receiverName: _otherUserName(swap: swap),
                      receiverPhoto: _otherUserPhoto(swap: swap),
                      receiverItemsID: swap.receiverItemsID,
                      senderItemsID: swap.senderItemsID,
                      reviewText: comment?.isNotEmpty == true ? comment : null,
                      rating: rating,
                      photoFiles: photoFiles,
                    );
                  },
                ),
                child: Text(RCCubit.instance.getText(R.review)),
              ),
            ),
          ],
        );
      case SETypes.swapCanceled:
        return const SizedBox();
      case SETypes.addSwapReview:
        // TODO: Handle this case.
        return const SizedBox();

      case null:
        return const SizedBox();
    }
  }

  Future<dynamic>? _showMessaging({required Swap swap}) {
    final chatID = '${ChatTypes.swapIt.name}_${Utils.getUniqueID(
      firstID: _currentUser!.uid,
      secondID: _otherUserID(swap: swap),
    )}';

    return showMessagingPage(
      chatID: chatID,
      type: ChatTypes.swapIt,
      otherUserID: _otherUserID(swap: swap),
    );
  }
}

class SwapEventTile extends StatelessWidget {
  const SwapEventTile({
    super.key,
    required this.swapEvent,
  });

  final SwapEvent swapEvent;

  @override
  Widget build(BuildContext context) {
    final list1 = swapEvent.receiverItemsID?.keys.map((key) {
      return FutureBuilder<DocumentSnapshot<SwapItem>>(
          future: SwapItem.ref.doc(key).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const SizedBox();

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }

            if (snapshot.data?.exists == true) {
              final swapItem = snapshot.data!.data()!;
              final heroTag = const Uuid().v4();

              return GestureDetector(
                onTap: () {
                  SwapItemPage.showPage(swapItem: swapItem, heroTag: heroTag);
                },
                child: SwapItemCard2(
                  swapItem: swapItem,
                  heroTag: heroTag,
                ),
              );
            }

            return const SizedBox();
          });
    }).toList();

    final list2 = swapEvent.senderItemsID?.keys.map((key) {
      return FutureBuilder<DocumentSnapshot<SwapItem>>(
          future: SwapItem.ref.doc(key).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const SizedBox();

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            if (snapshot.data?.exists == true) {
              final swapItem = snapshot.data!.data()!;

              final heroTag = const Uuid().v4();

              return GestureDetector(
                onTap: () {
                  SwapItemPage.showPage(swapItem: swapItem, heroTag: heroTag);
                },
                child: SwapItemCard2(
                  swapItem: swapItem,
                  heroTag: heroTag,
                ),
              );
            }

            return const SizedBox();
          });
    }).toList();

    return Column(
      children: [
        Card(
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: PhotoWidget.network(photoUrl: swapEvent.senderPhoto),
                title: swapEvent.senderName != null ? Text(swapEvent.senderName!) : null,
                dense: true,
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Iconify(
                    Entypo.info_with_circle,
                    color: Colors.white70,
                  ),
                ),
                subtitle: swapEvent.type != null
                    ? Text(
                        swapEvent.type!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              if (swapEvent.type == SETypes.newSwap.name)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (list1?.isNotEmpty == true)
                          Expanded(
                            child: Column(
                                children: list1!
                                    .map(
                                      (image) => SizedBox(
                                          height: Get.width / 2.5,
                                          width: Get.width / 2.5,
                                          child: image),
                                    )
                                    .toList()),
                          )
                        else
                          const SizedBox(),
                        const VerticalDivider(thickness: 2),
                        if (list2?.isNotEmpty == true)
                          Expanded(
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: list2!
                                    .map(
                                      (image) => SizedBox(
                                          height: Get.width / 2.5,
                                          width: Get.width / 2.5,
                                          child: image),
                                    )
                                    .toList()),
                          )
                        else
                          const SizedBox()
                      ],
                    ),
                  ),
                ),
              if (swapEvent.text != null) Text(swapEvent.text!),
              if (swapEvent.photoUrls?.isNotEmpty == true)
                SizedBox(
                  height: Get.height / 8,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => PhotoWidgetNetwork(
                            label: null,
                            photoUrl: swapEvent.photoUrls![index],
                            canDisplay: true,
                            height: Get.height / 8,
                            width: Get.height / 8,
                          ),
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 8.0,
                          ),
                      itemCount: swapEvent.photoUrls!.length),
                ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              swapEvent.timestamp != null ? timeago.format(swapEvent.timestamp!.toDate()) : '',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8.0),
          ],
        )
      ],
    );
  }
}
