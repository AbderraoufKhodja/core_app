import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/location_denied_permanently_widget.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/location_denied_widget.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/location_disable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GPSLoaderWidget extends StatefulWidget {
  const GPSLoaderWidget({super.key, required this.builder, this.loader});

  final Widget Function(BuildContext context, GeoPoint geopoint) builder;
  final Widget Function(BuildContext context)? loader;

  @override
  GPSLoaderWidgetState createState() => GPSLoaderWidgetState();
}

class GPSLoaderWidgetState extends State<GPSLoaderWidget> {
  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  late Future<GeoPoint> deviceGPSLocation =
      _settingsCubit.getSwapPosition(userID: _currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeoPoint>(
        future: deviceGPSLocation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            if (widget.loader != null) {
              return widget.loader!(context);
            }

            return LoadingGrid(width: Get.width - 20);
          }

          if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (snapshot.error is LocationPermanentlyDeniedException)
                  const LocationDeniedPermanentlyWidget()
                else if (snapshot.error is LocationDeniedException)
                  const LocationDeniedWidget()
                else if (snapshot.error is LocationDisabledException)
                  const LocationDisableWidget(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            deviceGPSLocation =
                                _settingsCubit.getSwapPosition(userID: _currentUser?.uid);
                          });
                        },
                        child: Text(
                          RCCubit.instance.getText(R.reload),
                          style: Get.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            if (snapshot.error is LocationDisabledException) {
                              await AppSettings.openLocationSettings();
                            } else {
                              await openAppSettings();
                            }
                          } catch (e) {
                            await openAppSettings();
                          }
                        },
                        child: Text(
                          RCCubit.instance.getText(R.settings),
                          style: Get.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }

          if (snapshot.data is GeoPoint) {
            return widget.builder(context, snapshot.data as GeoPoint);
          }

          return const SizedBox();
        });
  }
}
