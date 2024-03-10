import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/swap.dart';
import 'package:fibali/fibali_core/models/swap_event.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/Theme.dart';
import 'package:fibali/ui/pages/swap_user_profile_page.dart';
import 'package:fibali/ui/swap_events_page.dart';
import 'package:fibali/ui/widgets/stream_firestore_query_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class SwapsPage extends StatefulWidget {
  const SwapsPage({Key? key}) : super(key: key);

  @override
  SwapsPageState createState() => SwapsPageState();

  static Future<dynamic>? show() async {
    final needLogIn = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
    if (needLogIn) {
      return null;
    }

    return Get.to(() => const SwapsPage());
  }
}

class SwapsPageState extends State<SwapsPage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  Size get size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: const PopButton(),
          title: Text(RCCubit.instance.getText(R.swaps)),
        ),
        body: StreamFirestoreServerCacheQueryBuilder<Swap>(
          query: Swap.ref.where('usersID', arrayContains: _currentUser!.uid),
          loader: (context, snapshot) {
            return LoadingGrid(width: Get.width - 16);
          },
          emptyBuilder: (context, snapshot) {
            return DoubleCirclesWidget(
              title: RCCubit.instance.getText(R.noSwaps),
              description: RCCubit.instance.getText(R.swapsWillAppearHere),
              child: const FaIcon(
                FontAwesomeIcons.bagShopping,
                color: Colors.grey,
                size: 80,
              ),
            );
          },
          builder: (context, snapshot, _) {
            final swaps =
                snapshot.docs.map((swap) => swap.data()).where((swap) => swap.isValid()).toList();

            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: swaps.length,
              itemBuilder: (BuildContext _, int index) {
                // if we reached the end of the currently obtained items, we try to
                // obtain more items
                if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                  // Tell FirestoreQueryBuilder to try to obtain more items.
                  // It is safe to call this function from within the build method.
                  snapshot.fetchMore();
                }
                return SwapCard(swap: swaps[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class SwapCard extends StatefulWidget {
  const SwapCard({
    Key? key,
    required this.swap,
    this.onTap,
  }) : super(key: key);

  final Swap swap;
  final Function? onTap;

  @override
  State<SwapCard> createState() => _SwapCardState();
}

class _SwapCardState extends State<SwapCard> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  late String timeAgo = widget.swap.timestamp != null
      ? timeago.format((widget.swap.lastSwapEvent![SELabels.timestamp.name] as Timestamp).toDate())
      : '';

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
    var list1 = widget.swap.receiverItemsID?.values
        .whereType<List<dynamic>>()
        .where((list) => list.isNotEmpty)
        .map((list) => PhotoWidget.network(
              photoUrl: list[0],
              fit: BoxFit.cover,
              width: Get.width / 2,
            ))
        .toList();

    var list2 = widget.swap.senderItemsID?.values
        .whereType<List<dynamic>>()
        .where((list) => list.isNotEmpty)
        .map((list) => PhotoWidget.network(
              photoUrl: list[0],
              fit: BoxFit.cover,
              width: Get.width / 2,
            ))
        .toList();

    return GestureDetector(
      onTap: () => SwapEventsPage.showPage(swapID: widget.swap.swapID!),
      child: Card(
        elevation: 0,
        child: SizedBox(
          height: 210,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  minLeadingWidth: 60,
                  visualDensity: VisualDensity.compact,
                  leading: CircleAvatar(
                    child: GestureDetector(
                        onTap: () =>
                            SwapUserProfilePage.showPage(userID: _otherUserID(swap: widget.swap)),
                        child: PhotoWidgetNetwork(
                          boxShape: BoxShape.circle,
                          label: Utils.getInitial(
                            _otherUserName(swap: widget.swap),
                          ),
                          photoUrl: _otherUserPhoto(swap: widget.swap),
                        )),
                  ),
                  title: Text(
                    _otherUserName(swap: widget.swap),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    RCCubit.instance
                        .getCloudText(context, widget.swap.lastSwapEvent?['type'] ?? ''),
                    style: const TextStyle(
                      color: ArgonColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  dense: true,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (list1?.isNotEmpty == true)
                          Expanded(
                            child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: list1!
                                    .map((image) =>
                                        SizedBox(height: 60, width: 60, child: Card(child: image)))
                                    .toList()),
                          ),
                        if (list2?.isNotEmpty == true)
                          Expanded(
                            child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: list2!
                                    .map((image) =>
                                        SizedBox(height: 60, width: 60, child: Card(child: image)))
                                    .toList()),
                          )
                      ],
                    ),
                  ),
                ),
                const Divider(),
                //  data and place
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
