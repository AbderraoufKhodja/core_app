import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  final GeoPoint? initGeoPoint;

  const GoogleMapPage({Key? key, this.initGeoPoint}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  final Completer<GoogleMapController> _controller = Completer();
  String? _formattedAddress;

  late CameraPosition _kGooglePlex;

  @override
  void initState() {
    super.initState();
    _kGooglePlex = CameraPosition(
      target: widget.initGeoPoint != null
          ? LatLng(
              widget.initGeoPoint!.latitude,
              widget.initGeoPoint!.longitude,
            )
          : const LatLng(36.7538, 3.0588),
      zoom: 14.4746,
    );
  }

  GeoPoint? _geopoint;
  Placemark? _placemark;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        EasyLoading.dismiss(animation: true);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: PopButton(),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _geopoint != null
                    ? () => Get.back(result: {
                          "country": _placemark?.isoCountryCode,
                          "geopoint": _geopoint,
                        })
                    : null,
                style: ElevatedButton.styleFrom(
                  surfaceTintColor: _formattedAddress != null && _geopoint != null
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey,
                ),
                child: Text(RCCubit.instance.getText(R.select)),
              ),
            ),
          ],
        ),
        extendBodyBehindAppBar: false,
        body: Stack(
          children: [
            GoogleMap(
              cameraTargetBounds: CameraTargetBounds.unbounded,
              mapType: MapType.terrain,
              initialCameraPosition: _kGooglePlex,
              mapToolbarEnabled: true,
              compassEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(_markers.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                EasyLoading.show();
                _determinePosition().then((position) {
                  controller.moveCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(
                        position.latitude,
                        position.longitude,
                      ),
                      zoom: 14.4746,
                    )),
                  );
                }).onError((error, stackTrace) {
                  EasyLoading.showToast(
                    RCCubit.instance.getText(R.locationUnknown),
                    duration: const Duration(seconds: 2),
                    toastPosition: EasyLoadingToastPosition.center,
                  );
                }).whenComplete(() {
                  setState(() {});
                  EasyLoading.dismiss(animation: true);
                });
              },
              onTap: (LatLng latLng) {
                _updateLocation(latLng: latLng);
              },
              myLocationEnabled: true,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _formattedAddress != null
                    ? Container(
                        margin: const EdgeInsets.only(left: 2),
                        width: MediaQuery.of(context).size.width * 3.4 / 4,
                        child: Card(
                          child: ListTile(
                            title: Text(_formattedAddress ?? ''),
                          ),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 30),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _updateLocation({required LatLng latLng}) async {
    EasyLoading.show();
    print(latLng);

    _geopoint = GeoPoint(latLng.latitude, latLng.longitude);
    _markers[const MarkerId("my_location")] = Marker(
      markerId: const MarkerId("my_location"),
      position: latLng,
    );

    if (_geopoint != null) {
      placemarkFromCoordinates(_geopoint!.latitude, _geopoint!.longitude, localeIdentifier: "en_US")
          .then((value) {
        _placemark = value[0];
        _formattedAddress = checkAddressField(str: value[0].subAdministrativeArea) +
            checkAddressField(str: value[0].administrativeArea) +
            checkAddressField(str: value[0].country, isLast: true);
      }).onError((error, stackTrace) {
        _formattedAddress = "Unknown location";
        EasyLoading.showToast(
          RCCubit.instance.getText(R.locationUnknown),
          duration: const Duration(seconds: 2),
          toastPosition: EasyLoadingToastPosition.center,
        );
      }).whenComplete(() {
        setState(() {});
        EasyLoading.dismiss(animation: true);
      });
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    final bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  String checkAddressField({String? str, bool isLast = false}) => str != null
      ? str.isNotEmpty
          ? isLast
              ? str
              : "$str, "
          : ""
      : "";
}

Future<dynamic>? showGoogleMaps({GeoPoint? initGeoPoint}) {
  return Get.to(() => GoogleMapPage(initGeoPoint: initGeoPoint));
}
