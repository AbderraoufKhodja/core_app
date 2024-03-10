import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_item_page.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CustomSwapCard extends StatefulWidget {
  const CustomSwapCard({
    required this.swapItem,
    super.key,
  });

  final SwapItem swapItem;

  @override
  State<CustomSwapCard> createState() => _CustomSwapCardState();
}

class _CustomSwapCardState extends State<CustomSwapCard>
    with AutomaticKeepAliveClientMixin<CustomSwapCard> {
  @override
  bool get wantKeepAlive => true;

  int index = 0;

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        final heroTag = const Uuid().v4();
        SwapItemPage.showPage(
          swapItem: widget.swapItem,
          heroTag: heroTag,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Column(
          children: [
            Card(
              child: PhotoWidget.network(
                photoUrl: widget.swapItem.photoUrls![0],
                fit: BoxFit.fitWidth,
                loadingHeight: Get.width / 3,
                loadingWidth: Get.width / 2,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.swapItem.ownerName != null)
                        Expanded(
                          child: Text(
                            widget.swapItem.ownerName!,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (widget.swapItem.location?.containsKey('geopoint') == true)
                        if ((getDistance(location: widget.swapItem.location!['geopoint']) ?? 300) <
                                200 ==
                            true)
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 16,
                              ),
                              Text(
                                getDistance(location: widget.swapItem.location!['geopoint'])
                                        ?.toString() ??
                                    '',
                                style: const TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                RCCubit.instance.getText(R.km),
                                style: const TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.bold),
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
                        )
                      : null,
                ),
              ],
            ),
          ],
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
