import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/swap_factory_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class SwapItemImage extends StatefulWidget {
  final SwapItem item;

  const SwapItemImage({super.key, required this.item});

  @override
  State<SwapItemImage> createState() => _SwapItemImageState();
}

class _SwapItemImageState extends State<SwapItemImage> {
  SwapItem get _item => widget.item;

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  bool showExpansionTileSubtitle = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: size.width * 0.8,
          child: bd.Badge(
            position: bd.BadgePosition.custom(top: 10, end: 5),
            badgeStyle: const bd.BadgeStyle(
              shape: bd.BadgeShape.instagram,
              badgeColor: Colors.transparent,
              elevation: 0,
            ),
            badgeAnimation: const bd.BadgeAnimation.slide(
              toAnimate: false,
            ),
            badgeContent: GestureDetector(
              onTapDown: (TapDownDetails details) {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    70,
                    10,
                  ),
                  items: [
                    PopupMenuItem(
                      padding: const EdgeInsets.all(0),
                      child: ListTile(
                        onTap: () async {
                          await Future.delayed(const Duration(milliseconds: 100));
                          if (mounted) {
                            Get.back();
                            SwapFactoryPage.show(
                              currentUser: _currentUser!,
                              itemID: _item.itemID,
                            );
                          }
                        },
                        title: Text(RCCubit.instance.getText(R.edit)),
                        trailing: const FaIcon(
                          FontAwesomeIcons.pen,
                          size: 15,
                        ),
                      ),
                    ),
                    // PopupMenuItem(
                    //   padding: const EdgeInsets.all(0),
                    //   child: ListTile(
                    //     title: Text(RCCubit.instance.getText(R.markAsSwapped)),
                    //     trailing: const FaIcon(
                    //       FontAwesomeIcons.recycle,
                    //       size: 15,
                    //     ),
                    //   ),
                    // ),
                    // PopupMenuItem(
                    //   padding: const EdgeInsets.all(0),
                    //   child: ListTile(
                    //     title: Text(RCCubit.instance.getText(R.delete)),
                    //     trailing: const FaIcon(
                    //       FontAwesomeIcons.trash,
                    //       size: 15,
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              },
              child: const Icon(Icons.more_vert, color: Colors.grey),
            ),
            child: SwapItemWidget(
              padding: 0,
              photoHeight: size.height * 0.7,
              photoWidth: size.width * 0.8,
              photoUrl: _item.photoUrls?[0],
              clipRadius: 0.2,
              containerHeight: size.height * 0.6,
              containerWidth: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildImageFooter(size),
                  // SwitchListTile(
                  //   title: Text(
                  //     RCCubit.instance.getText(R.giveAway),
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   value: false,
                  //   activeColor: Colors.green.shade300,
                  //   onChanged: (bool) {},
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageFooter(Size size) {
    int? distance;
    if (_item.location?.containsKey('geopoint') == true &&
        _item.location!['geopoint'] is GeoPoint) {
      distance = getDifference(
        location: _item.location?['geopoint'] as GeoPoint,
      );
    }

    final timeAgo = _item.timestamp != null ? timeago.format(_item.timestamp!.toDate()) : '';
    return Container(
      height: size.height * 0.4,
      alignment: Alignment.bottomCenter,
      child: ExpansionTile(
        collapsedIconColor: Colors.white,
        tilePadding: const EdgeInsets.all(0),
        onExpansionChanged: (bool) {
          setState(() {
            showExpansionTileSubtitle = !bool;
          });
        },
        subtitle: showExpansionTileSubtitle
            ? Text(
                '${_item.description}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: size.height * 0.03,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 15,
                    ),
                    if (distance != null)
                      Text(
                        '${(distance / 1000).floor()}km away ',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: size.width / 3.5,
              child: FittedBox(
                child: Text(
                  timeAgo,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              height: size.height * 0.25,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  '${_item.description}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: size.height * 0.03,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int? getDifference({required GeoPoint location}) {
    if (_settingsCubit.hasLocation) {
      final distance = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        _settingsCubit.state.latitude!,
        _settingsCubit.state.longitude!,
      );
      return distance ~/ 1000;
    }
    return null;
  }
}
