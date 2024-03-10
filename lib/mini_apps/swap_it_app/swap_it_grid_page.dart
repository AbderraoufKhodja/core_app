import 'dart:developer';

import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/tooltips_into/tooltips_intro_cubit.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/search/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_board_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_chats_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/swap_cards_deck_widget.dart';
import 'package:fibali/ui/widgets/no_items_widget.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/curved_button.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa.dart';
import 'package:iconify_flutter/icons/jam.dart';
import 'package:showcaseview/showcaseview.dart';

import 'bloc/user_swap_items/bloc.dart';

class SwapItGridPage extends StatefulWidget {
  const SwapItGridPage({super.key});

  @override
  SwapItGridPageState createState() => SwapItGridPageState();
}

class SwapItGridPageState extends State<SwapItGridPage>
    with AutomaticKeepAliveClientMixin<SwapItGridPage>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  bool showExpansionTileSubtitle = true;

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  List<SwapItem> previousItems = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ShowCaseWidget(
      onStart: (index, key) {
        log('onStart: $index, $key');
      },
      onComplete: (index, key) {
        log('onComplete: $index, $key');
        if (index == 4) {
          _settingsCubit.setSwapScreenShowCaseDone(true);
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white,
            ),
          );
        }
      },
      blurValue: 1,
      builder: Builder(builder: (context) => const SwapItScaffold()),
      autoPlayDelay: const Duration(seconds: 3),
    );
  }
}

class SwapItScaffold extends StatefulWidget {
  const SwapItScaffold({super.key});

  @override
  State<SwapItScaffold> createState() => _SwapItScaffoldState();
}

class _SwapItScaffoldState extends State<SwapItScaffold> {
  final globalKey1 = GlobalKey();
  final globalKey2 = GlobalKey();
  final globalKey3 = GlobalKey();
  final globalKey4 = GlobalKey();
  final globalKey5 = GlobalKey();

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  SwapSearchBloc get _searchBloc => BlocProvider.of<SwapSearchBloc>(context);

  TooltipsIntroCubit get ttIntro => BlocProvider.of<TooltipsIntroCubit>(context);

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  void initState() {
    super.initState();
    // TODO: Fix overlay swap intro bug
    if (!_settingsCubit.state.isSwapScreenShowCaseDone) {
      Future.delayed(const Duration(seconds: 15), () {
        // TODO: fix index issue
        if (ModalRoute.of(context)?.isCurrent == true && _settingsCubit.activeIdx == 0 && mounted) {
          ShowCaseWidget.of(context).startShowCase([
            globalKey1,
            globalKey2,
            globalKey3,
            globalKey4,
            globalKey5,
          ]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: BlocBuilder<SwapSearchBloc, SwapSearchState>(
          builder: (context, state) {
            return Showcase.withWidget(
              key: globalKey1,
              height: Get.height / 8,
              width: Get.width - 16,
              container: CustomTooltip(tooltipParams: ttIntro.tooltipLocation),
              child: GestureDetector(
                onTap: () {
                  _searchBloc.changeSwapLocation(userID: _currentUser!.uid);
                },
                child: _LocationBadge(geopoint: _searchBloc.currentUserGeoPoint),
              ),
            );
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          Showcase.withWidget(
            key: globalKey2,
            height: Get.height / 8,
            width: Get.width - 16,
            container: CustomTooltip(tooltipParams: ttIntro.tooltipRewind),
            child: IconButton(
              onPressed: () {
                _searchBloc.rewindSwapItems(userID: _currentUser!.uid);
              },
              icon: const Iconify(Fa.rotate_left, size: 22, color: Colors.grey),
            ),
          ),
          Showcase.withWidget(
            key: globalKey3,
            height: Get.height / 8,
            width: Get.width - 16,
            container: CustomTooltip(tooltipParams: ttIntro.tooltipBoard),
            child: BlocBuilder<UserSwapItemsBloc, UserSwapItemsState>(
              builder: (_, state) {
                if (state is UserSwapItemsInitialState) {
                  BlocProvider.of<UserSwapItemsBloc>(context)
                      .add(LoadUserSwapItemsEvent(userID: _currentUser!.uid));
                }

                if (state is UserSwapItemsLoadedState) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: state.matchedList,
                    builder: (_, snapshot) {
                      final showBadge = snapshot.data?.docs
                              .any((doc) => getField(doc, _currentUser!.uid, bool) == false) ==
                          true;

                      return bd.Badge(
                        showBadge: showBadge,
                        position: bd.BadgePosition.topEnd(top: 5, end: 5),
                        badgeContent: const CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.redAccent,
                          child: SizedBox(),
                        ),
                        badgeStyle: const bd.BadgeStyle(
                          shape: bd.BadgeShape.instagram,
                          padding: EdgeInsets.all(0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.grid_view_rounded, size: 28, color: Colors.grey),
                          visualDensity: const VisualDensity(vertical: 4),
                          onPressed: () {
                            SwapBoardPage.showPage();
                          },
                        ),
                      );
                    },
                  );
                }

                return IconButton(
                  icon: const Icon(Icons.grid_view_rounded, size: 28, color: Colors.grey),
                  onPressed: () {
                    SwapBoardPage.showPage();
                  },
                );
              },
            ),
          ),
          Showcase.withWidget(
            key: globalKey4,
            height: Get.height / 8,
            width: Get.width - 16,
            container: CustomTooltip(
              tooltipParams: ttIntro.tooltipChats,
            ),
            child: const _ChatButton(),
          ),
          Showcase.withWidget(
            key: globalKey5,
            height: Get.height / 8,
            width: Get.width - 16,
            container: CustomTooltip(
              tooltipParams: ttIntro.tooltipSettings,
            ),
            child: IconButton(
              icon: const Iconify(Jam.settings_alt, size: 30, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _searchBloc.showRail = !_searchBloc.showRail;
                });
              },
            ),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // const Expanded(child: SwapCardsGridWidget()), // GridView
          const Expanded(child: SwapCardsDecksWidget()), // DeckView

          AnimatedContainer(
            width: _searchBloc.showRail ? Get.width / 6 : 0,
            height: _searchBloc.showRail ? Get.height : 0,
            duration: const Duration(milliseconds: 500),
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CustomVerticalSlider(),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTooltip extends StatefulWidget {
  const CustomTooltip({
    super.key,
    required this.tooltipParams,
  });

  final TooltipParams tooltipParams;

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  @override
  Widget build(BuildContext context) {
    final ttIntro = BlocProvider.of<TooltipsIntroCubit>(context);

    return Card(
      child: GestureDetector(
        // onTap: () async {
        //   await widget.tooltipParams.controller.hideTooltip();
        //   widget.tooltipParams.function();
        //   if (mounted) ttIntro.showNextTooltip();
        // },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Get.width / 2),
            child: Text(
              RCCubit.instance.getText(widget.tooltipParams.string),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatButton extends StatelessWidget {
  const _ChatButton();

  @override
  Widget build(BuildContext context) {
    final currentUser = BlocProvider.of<AuthBloc>(context).currentUser;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        icon: bd.Badge(
          badgeContent: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection(chatsCollection)
                  .where(ChatLabels.usersID.name, arrayContains: currentUser!.uid)
                  .where('${ChatLabels.isSeen.name}.${currentUser.uid}', isEqualTo: false)
                  .where(ChatLabels.type.name, isEqualTo: ChatTypes.swapIt.name)
                  .limit(1)
                  .snapshots(),
              builder: (context, snapshot) {
                if ((snapshot.data?.docs.length ?? 0) > 0) {
                  return const CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.redAccent,
                    child: SizedBox(),
                  );
                }

                return const SizedBox();
              }),
          badgeStyle: const bd.BadgeStyle(
            shape: bd.BadgeShape.instagram,
            padding: EdgeInsets.all(0),
          ),
          child: const Icon(Icons.email, size: 28, color: Colors.grey),
        ),
        onPressed: () {
          SwapChatsPage.showPage(context);
        },
      ),
    );
  }
}

class _LocationBadge extends StatefulWidget {
  const _LocationBadge({required this.geopoint});

  final GeoPoint? geopoint;

  @override
  State<_LocationBadge> createState() => _LocationBadgeState();
}

class _LocationBadgeState extends State<_LocationBadge> {
  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    if (widget.geopoint == null) {
      return CurvedButton(
        height: 30,
        color: Colors.grey,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FluentIcons.location_16_regular, size: 15, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              RCCubit.instance.getText(R.location),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
          ],
        ),
      );
    } else {
      return FutureBuilder<List<Placemark>?>(
        future: SettingsCubit.getAddressFromLatLong(
          latitude: widget.geopoint!.latitude,
          longitude: widget.geopoint!.longitude,
          appLanguage: _settingsCubit.state.appLanguage,
        ),
        builder: (_, snapshot) {
          if (snapshot.data?.isNotEmpty == true) {
            final placeMarks = snapshot.data!;
            return Row(
              children: [
                if (placeMarks[0].administrativeArea?.isNotEmpty == true)
                  Flexible(
                    child: CurvedButton(
                      height: 30,
                      color: Colors.grey,
                      child: Row(
                        children: [
                          const Icon(FluentIcons.location_16_regular, size: 15, color: Colors.grey),
                          Flexible(
                            child: Text(placeMarks[0].administrativeArea ?? '',
                                overflow: TextOverflow.fade,
                                style: Theme.of(context).textTheme.labelMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }

          return CurvedButton(
            height: 30,
            color: Colors.grey,
            child: Row(
              children: [
                const Icon(FluentIcons.location_16_regular, size: 15, color: Colors.grey),
                const SizedBox(width: 8),
                Text(RCCubit.instance.getText(R.changeLocation),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      );
    }
  }

  Text buildLocationText(List<Placemark> placeMarks) {
    return Text(
      checkAddressField(str: placeMarks[0].administrativeArea) +
          checkAddressField(str: placeMarks[0].country, isLast: true),
    );
  }

  String checkAddressField({String? str, bool isLast = false}) => str != null
      ? str.isNotEmpty
          ? isLast
              ? str
              : "$str, "
          : ""
      : "";
}
