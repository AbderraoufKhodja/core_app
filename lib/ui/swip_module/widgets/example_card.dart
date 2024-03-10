import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_page.dart';
import 'package:fibali/ui/swip_module/widgets/bottom_buttons_row.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/entypo.dart';
import 'package:uuid/uuid.dart';

class ExampleCard extends StatefulWidget {
  const ExampleCard({
    required this.swapItem,
    super.key,
  });

  final SwapItem swapItem;

  @override
  State<ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<ExampleCard> with AutomaticKeepAliveClientMixin<ExampleCard> {
  @override
  bool get wantKeepAlive => true;

  int index = 0;

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Badge(
      badgeStyle: const BadgeStyle(
        shape: BadgeShape.instagram,
        badgeColor: Colors.transparent,
        elevation: 1,
      ),
      position: BadgePosition.topEnd(end: 5, top: 5),
      badgeContent: IconButton(
        onPressed: () {
          final heroTag = const Uuid().v4();
          SwapItemPage.showPage(
            swapItem: widget.swapItem,
            heroTag: heroTag,
          );
        },
        icon: const Iconify(
          Entypo.info_with_circle,
          color: Colors.white70,
        ),
      ),
      child: Card(
        child: DefaultTabController(
          length: widget.swapItem.photoUrls!.length,
          child: Builder(builder: (context) {
            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 26,
                          color: Colors.black.withOpacity(0.08),
                        ),
                      ],
                    ),
                    child: Badge(
                      position: BadgePosition.custom(top: 10),
                      badgeStyle: const BadgeStyle(
                        shape: BadgeShape.instagram,
                        badgeColor: Colors.transparent,
                        elevation: 0,
                      ),
                      showBadge: widget.swapItem.photoUrls!.length > 1,
                      badgeContent: const TabPageSelector(
                        selectedColor: Colors.white,
                        indicatorSize: 10,
                      ),
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: widget.swapItem.photoUrls!.map((url) {
                          return PhotoWidget.network(photoUrl: url);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 0,
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      final tabController = DefaultTabController.of(context);
                                      if (index > 0) {
                                        index -= 1;
                                        tabController.animateTo(index);
                                      }
                                    },
                                    child: Container(color: Colors.transparent))),
                            Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      final tabController = DefaultTabController.of(context);
                                      if (index < widget.swapItem.photoUrls!.length - 1) {
                                        index += 1;
                                        tabController.animateTo(index);
                                      }
                                    },
                                    child: Container(color: Colors.transparent))),
                          ],
                        ),
                      ),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(14),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.black12.withOpacity(0),
                              Colors.black12.withOpacity(.4),
                              Colors.black12.withOpacity(.82),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // if (widget.item.ownerName != null)
                                    //   Expanded(
                                    //     child: Text(
                                    //       '${RCCubit.instance.getText(R.by)} ${widget.item.ownerName!}',
                                    //       maxLines: 1,
                                    //       style: const TextStyle(
                                    //         color: Colors.white,
                                    //       ),
                                    //     ),
                                    //   ),
                                    if (widget.swapItem.location?.containsKey('geopoint') == true)
                                      if ((getDistance(
                                                      location:
                                                          widget.swapItem.location!['geopoint']) ??
                                                  300) <
                                              200 ==
                                          true)
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.white70,
                                              size: 16,
                                            ),
                                            Text(
                                              getDistance(
                                                          location:
                                                              widget.swapItem.location!['geopoint'])
                                                      ?.toString() ??
                                                  '',
                                              style: const TextStyle(color: Colors.white70),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              RCCubit.instance.getText(R.km),
                                              style: const TextStyle(color: Colors.white70),
                                            )
                                          ],
                                        ),
                                  ],
                                ),
                                dense: true,
                                subtitle: widget.swapItem.description != null
                                    ? Text(
                                        widget.swapItem.description!,
                                        maxLines: 3,
                                        style: const TextStyle(color: Colors.white70),
                                      )
                                    : null,
                              ),
                              const SizedBox(height: BottomButtonsRow.height)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  int? getDistance({required GeoPoint location}) {
    if (_settingsCubit.hasLocation) {
      final distance = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        _settingsCubit.state.latitude!,
        _settingsCubit.state.longitude!,
      );

      return distance ~/ 1000;
    } else {
      return null;
    }
  }
}
