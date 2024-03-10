import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/app_settings.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/repositories/settings_repository.dart';
import 'package:fibali/fibali_core/ui/pages/google_map_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fluent_emoji_high_contrast.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';

class SettingsCubit extends Cubit<AppSettings> {
  final _settingsRepository = SettingsRepository();

  SettingsCubit() : super(AppSettings.initial());

  static SettingsCubit get instance => BlocProvider.of<SettingsCubit>(Get.context!);

  int activeIdx = 0;

  setHomeActiveIndex(int idx) {
    activeIdx = idx;
  }

  void updateRadius({required double distance}) async {
    await _settingsRepository.updateDistance(distance: distance);
    emit(_settingsRepository.getSettings());
  }

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    await _settingsRepository.updateLocation(
      latitude: latitude,
      longitude: longitude,
    );

    await updateChangeUserLocationTime();

    emit(_settingsRepository.getSettings());
  }

  Future<void> updateChangeUserLocationTime() async {
    await _settingsRepository.updateChangeUserLocationTime();
    emit(_settingsRepository.getSettings());
  }

  Future<void> updateBusinessLocation({
    required double latitude,
    required double longitude,
  }) async {
    await _settingsRepository.updateBusinessLocation(
      latitude: latitude,
      longitude: longitude,
    );

    emit(_settingsRepository.getSettings());
  }

  Future<void> initSettings() async {
    await _settingsRepository.initSettings();
    emit(_settingsRepository.getSettings());
  }

  Future<void> disableSearchPageTuto() async {
    await _settingsRepository.disableSearchPageTuto();
    emit(_settingsRepository.getSettings());
  }

  Future<void> setRequestNotifyPermission({required bool value}) async {
    await _settingsRepository.setRequestNotifyPermission(value: value);
    emit(_settingsRepository.getSettings());
  }

  Future<void> disableUserItemsPageTuto() async {
    await _settingsRepository.disableUserItemsPageTuto();
    emit(_settingsRepository.getSettings());
  }

  Future<List<Placemark>?> getAddress() async {
    if (hasLocation) {
      return placemarkFromCoordinates(
        state.latitude!,
        state.longitude!,
        localeIdentifier: state.appLanguage,
      );
    } else {
      return null;
    }
  }

  static Future<List<Placemark>> getAddressFromLatLong({
    required double latitude,
    required double longitude,
    required String? appLanguage,
  }) async {
    return placemarkFromCoordinates(
      latitude,
      longitude,
      localeIdentifier: appLanguage,
    );
  }

  Future<void> setStrictSearchMode(bool bool) async {
    await _settingsRepository.setStrictSearchMode(bool);
    emit(_settingsRepository.getSettings());
  }

  Future<void> setIntroduced(bool bool) async {
    await _settingsRepository.setIntroduced(bool);
    emit(_settingsRepository.getSettings());
  }

  Future<void> performedFirstSwipe(bool bool) async {
    await _settingsRepository.performedFirstSwipe(bool);
    emit(_settingsRepository.getSettings());
  }

  Future<void> performedFirstSwipeRight(bool bool) async {
    await _settingsRepository.performedFirstSwipeRight(bool);
    emit(_settingsRepository.getSettings());
  }

  Future<void> performedFirstSwipeLeft(bool bool) async {
    await _settingsRepository.performedFirstSwipeLeft(bool);
    emit(_settingsRepository.getSettings());
  }

  Future<void> setSwapItAppIntroduced(bool value) async {
    await _settingsRepository.setSwapItAppIntroduced(value);
    emit(_settingsRepository.getSettings());
  }

  Future<void> setSwapScreenShowCaseDone(bool value) async {
    await _settingsRepository.setSwapScreenShowCaseDone(value);
    emit(_settingsRepository.getSettings());
  }

  Future<void> setSettingsToDefault() async {
    await _settingsRepository.setSettingsToDefault();
    emit(_settingsRepository.getSettings());
  }

  Future<void> setDialCode({required String value}) async {
    await _settingsRepository.setDialCode(value: value);
    emit(_settingsRepository.getSettings());
  }

  Future<void> setIsoCode({required String value}) async {
    await _settingsRepository.setIsoCode(value: value);
    emit(_settingsRepository.getSettings());
  }

  Future<void> setPhoneNumber({required String value}) async {
    await _settingsRepository.setPhoneNumber(value: value);
    emit(_settingsRepository.getSettings());
  }

  Future<bool> setAppLanguage({required String language}) async {
    EasyLoading.show();
    final result = await _settingsRepository.setAppLanguage(language);
    EasyLoading.dismiss(animation: true);
    emit(_settingsRepository.getSettings());
    return result;
  }

  Future<bool> setAppCountry({required String country}) async {
    EasyLoading.show();
    final result = await _settingsRepository.setCountry(country);
    EasyLoading.dismiss(animation: true);
    emit(_settingsRepository.getSettings());
    return result;
  }

  Future<void> changeUserLocation({required String userID}) async {
    final location = await showGoogleMaps();

    if (location?.containsKey('geopoint') == true) {
      final geopoint = location!['geopoint'] as GeoPoint?;
      final countryCode = location!['country'] as String?;

      if (geopoint != null) {
        updateLocation(
          latitude: geopoint.latitude,
          longitude: geopoint.longitude,
        );

        return AppUser.ref.doc(userID).update({
          AULabels.country.name: countryCode,
          AULabels.location.name: GeoFlutterFire()
              .point(latitude: geopoint.latitude, longitude: geopoint.longitude)
              .dataForThreeHundredKm,
        });
      }
    }
  }

  bool get hasLocation => state.latitude != null && state.longitude != null;

  bool get isTimestampOverdue {
    if (state.userLocationLastChangeTime != null) {
      return DateTime.fromMillisecondsSinceEpoch(state.userLocationLastChangeTime!.toInt())
              .difference(DateTime.now())
              .inMinutes >
          30;
    }
    return true;
  }

  Locale getLocale() {
    switch (state.appLanguage) {
      case 'ar':
        return const Locale('ar', 'DZ');
      case 'fr':
        return const Locale('fr', 'FR');
      case 'zh_Hans':
        return const Locale('zh', 'CN');
      default:
        return const Locale('en', 'US');
    }
  }

  int? getDistance({required GeoPoint location}) {
    if (hasLocation) {
      final distance = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        state.latitude!,
        state.longitude!,
      );

      return distance ~/ 1000;
    } else {
      return null;
    }
  }

  Future<GeoPoint> getSwapPosition({required String? userID}) async {
    if (hasLocation && !isTimestampOverdue) {
      return GeoPoint(
        state.latitude!,
        state.longitude!,
      );
    }

    final position = await determinePosition(userID: userID);

    updateLocation(latitude: position.latitude, longitude: position.longitude);

    return GeoPoint(position.latitude, position.longitude);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position> determinePosition({required String? userID}) async {
    final bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return Future.error(LocationDisabledException('Location services are disabled.'));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      switch (permission) {
        case LocationPermission.denied:
          FAC.logEvent(FAEvent.deniedForever);
          break;
        case LocationPermission.deniedForever:
          FAC.logEvent(FAEvent.deniedForever);
          break;
        case LocationPermission.whileInUse:
          FAC.logEvent(FAEvent.whileInUse);
          break;
        case LocationPermission.always:
          FAC.logEvent(FAEvent.always);
          break;
        case LocationPermission.unableToDetermine:
          FAC.logEvent(FAEvent.unableToDetermine);
          break;
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return Future.error(LocationDeniedException('Location permissions are denied'));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return Future.error(LocationPermanentlyDeniedException(
          'Location permissions are permanently denied, we cannot request permissions.'));
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    if (userID?.isNotEmpty == true) {
      getAddressFromLatLong(
        latitude: position.latitude,
        longitude: position.longitude,
        appLanguage: null,
      ).then((placemark) {
        AppUser.ref.doc(userID).update({
          if (placemark.isNotEmpty) AULabels.country.name: placemark[0].isoCountryCode,
          AULabels.location.name: GeoFlutterFire()
              .point(latitude: position.latitude, longitude: position.longitude)
              .dataForThreeHundredKm,
        });
      });
    }

    return position;
  }

  // Check camera and photo permission, if not granted request permission, if permanently denied show bottom GetSnackBar with open phone settings button to grant permission, wait and check permission after return to app.
  static Future<bool> checkCameraPermission({required void Function() actionOnGranted}) async {
    final cameraStatus = await Permission.camera.status;

    if (cameraStatus.isPermanentlyDenied) {
      askSettingsCameraPermission();
      return false;
    }

    if (cameraStatus.isGranted) {
      actionOnGranted.call();
    } else {
      final status = await [Permission.camera].request();

      if (status[Permission.camera] != PermissionStatus.granted) {
        askSettingsCameraPermission();
        return false;
      }

      actionOnGranted.call();
    }

    return true;
  }

  // // Check camera and photo permission, if not granted request permission, if permanently denied show bottom GetSnackBar with open phone settings button to grant permission, wait and check permission after return to app.
  // static Future<bool> checkPhotoPermission({required void Function() actionOnGranted}) async {
  //   late PermissionStatus photoStatus;
  //   AndroidDeviceInfo? androidInfo;

  //   if (Platform.isAndroid) {
  //     androidInfo = await DeviceInfoPlugin().androidInfo;
  //     if (androidInfo.version.sdkInt <= 32) {
  //       photoStatus = await Permission.storage.status;
  //     } else {
  //       photoStatus = await Permission.photos.status;
  //     }
  //   } else {
  //     photoStatus = await Permission.photos.status;
  //   }

  //   if (photoStatus.isPermanentlyDenied) {
  //     askSettingsPhotosPermission();
  //     return false;
  //   }

  //   if (photoStatus.isGranted) {
  //     actionOnGranted.call();
  //   } else {
  //     final status = await [
  //       if (Platform.isAndroid)
  //         if (androidInfo!.version.sdkInt <= 32) Permission.storage else Permission.photos
  //       else
  //         Permission.photos
  //     ].request();

  //     if (status[Permission.photos] != PermissionStatus.granted) {
  //       askSettingsPhotosPermission();
  //       return false;
  //     }

  //     actionOnGranted.call();
  //   }

  //   return true;
  // }

  static void askSettingsCameraPermission() {
    Get.showSnackbar(
      GetSnackBar(
        title: 'Permission denied',
        message: 'Please enable camera permission in settings',
        mainButton: TextButton(
          onPressed: () async {
            await openAppSettings();
            if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
          },
          child: const Text('Open settings', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  static void askSettingsPhotosPermission() {
    Get.showSnackbar(
      GetSnackBar(
        title: 'Permission denied',
        message: 'Please enable photo library permission in settings',
        mainButton: TextButton(
          onPressed: () async {
            await openAppSettings();
            if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
          },
          child: const Text('Open settings', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  static Future handlePickMultiGalleryCamera({
    String? title,
    required String maxNumWarning,
    required void Function(List<XFile> imageFiles) onImagesSelected,
    int maxNum = 6,
    double maxHeight = 1024,
    double maxWidth = 1024,
  }) {
    FAC.logEvent(FAEvent.select_image_from_gallery_or_camera);
    return Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SimpleDialog(
          backgroundColor: Get.theme.cardColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          // title: Text(title),
          // titleTextStyle: Theme.of(Get.context!).textTheme.bodyMedium,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () async {
                    XFile? imageFile;
                    try {
                      imageFile = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        maxHeight: 1024,
                        maxWidth: 1024,
                      );
                    } catch (error) {
                      if (error is PlatformException) {
                        if (error.code == 'camera_access_denied') {
                          SettingsCubit.askSettingsCameraPermission();
                        }
                      }
                    }
                    if (Get.isDialogOpen == true) Get.back();
                    if (imageFile != null) {
                      onImagesSelected([imageFile]);
                    }
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Iconify(
                          MaterialSymbols.camera_rounded,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      Text(RCCubit().getText(R.camera).toUpperCase())
                    ],
                  ),
                ),
                const SizedBox(height: 30, child: VerticalDivider(thickness: 2, width: 0)),
                MaterialButton(
                  onPressed: () async {
                    List<XFile>? imageFiles;
                    try {
                      imageFiles = await ImagePicker().pickMultiImage(
                        maxHeight: 1024,
                        maxWidth: 1024,
                      );
                    } catch (error) {
                      if (error is PlatformException) {
                        if (error.code == 'photo_access_denied') {
                          SettingsCubit.askSettingsPhotosPermission();
                        }
                      }
                    }

                    // Check if imageFiles is null, if so return
                    if (Get.isDialogOpen == true) Get.back();
                    if (imageFiles != null) {
                      // Check if imageFiles.length is greater than maxNum, if so show GetSnackBar and return
                      if ((imageFiles.length) > maxNum) {
                        Get.showSnackbar(GetSnackBar(title: maxNumWarning));
                        onImagesSelected(imageFiles.sublist(0, maxNum));
                      } else {
                        onImagesSelected(imageFiles);
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Text(RCCubit().getText(R.gallery).toUpperCase()),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Iconify(
                          FluentEmojiHighContrast.flower_playing_cards,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future handlePickMedia({
    String? title,
    required void Function(dynamic files) onFilesSelected,
    required String maxNumWarning,
    int maxNum = 6,
    double maxHeight = 1024,
    double maxWidth = 1024,
  }) {
    FAC.logEvent(FAEvent.pick_video);
    return Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SimpleDialog(
          backgroundColor: Get.theme.cardColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          // title: Text(title),
          // titleTextStyle: Theme.of(Get.context!).textTheme.bodyMedium,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () async {
                    File? result;
                    try {
                      final pickedFile = await FilePicker.platform.pickFiles(
                        allowCompression: true,
                        type: FileType.video,
                        allowMultiple: false,
                      );

                      if (pickedFile?.files.single.path == null) {
                        return;
                      }

                      result = File(pickedFile!.files.single.path!);
                    } catch (error) {
                      debugPrint(error.toString());
                      if (error is PlatformException) {
                        if (error.code == 'photo_access_denied') {
                          SettingsCubit.askSettingsPhotosPermission();
                        }
                      } else {
                        EasyLoading.showError(RCCubit().getText(R.oopsSomethingWentWrong));
                      }
                    }
                    if (Get.isDialogOpen == true) Get.back();
                    if (result != null) {
                      onFilesSelected(result);
                    }
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Iconify(
                          MaterialSymbols.play_arrow_rounded,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                      Text(RCCubit().getText(R.video).toUpperCase())
                    ],
                  ),
                ),
                const SizedBox(height: 30, child: VerticalDivider(thickness: 2, width: 0)),
                MaterialButton(
                  onPressed: () async {
                    List<XFile>? imageFiles;
                    try {
                      imageFiles = await ImagePicker().pickMultiImage(
                        maxHeight: 1024,
                        maxWidth: 1024,
                      );
                    } catch (error) {
                      if (error is PlatformException) {
                        if (error.code == 'photo_access_denied') {
                          SettingsCubit.askSettingsPhotosPermission();
                        }
                      }
                    }

                    // Check if imageFiles is null, if so return
                    if (Get.isDialogOpen == true) Get.back();
                    if (imageFiles != null) {
                      // Check if imageFiles.length is greater than maxNum, if so show GetSnackBar and return
                      if ((imageFiles.length) > maxNum) {
                        Get.showSnackbar(GetSnackBar(title: maxNumWarning));
                        onFilesSelected(imageFiles.sublist(0, maxNum));
                      } else {
                        onFilesSelected(imageFiles);
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Text(RCCubit().getText(R.gallery).toUpperCase()),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Iconify(
                          FluentEmojiHighContrast.flower_playing_cards,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> handlePickSingleGalleryCamera({
    required String title,
    required void Function(XFile imageFiles) onImageSelected,
    double maxHeight = 1024,
    double maxWidth = 1024,
  }) async {
    return Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: SimpleDialog(
          backgroundColor: Get.theme.cardColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          // title: Text(title),
          // titleTextStyle: Theme.of(Get.context!).textTheme.bodyMedium,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () async {
                    XFile? imageFile;
                    try {
                      imageFile = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        maxHeight: 1024,
                        maxWidth: 1024,
                      );
                    } catch (error) {
                      if (error is PlatformException) {
                        if (error.code == 'camera_access_denied') {
                          SettingsCubit.askSettingsCameraPermission();
                        }
                      }
                    }

                    if (imageFile != null) {
                      onImageSelected(imageFile);
                    }
                    if (Get.isDialogOpen == true) Get.back();
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Iconify(
                          MaterialSymbols.camera_rounded,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      Text(RCCubit().getText(R.camera).toUpperCase())
                    ],
                  ),
                ),
                const SizedBox(height: 30, child: VerticalDivider(thickness: 2, width: 0)),
                MaterialButton(
                  onPressed: () async {
                    XFile? imageFile;
                    try {
                      imageFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 1024,
                        maxWidth: 1024,
                      );
                    } catch (error) {
                      if (error is PlatformException) {
                        if (error.code == 'photo_access_denied') {
                          SettingsCubit.askSettingsPhotosPermission();
                        }
                      }
                    }

                    if (imageFile != null) {
                      onImageSelected(imageFile);
                    }

                    if (Get.isDialogOpen == true) Get.back();
                  },
                  child: Row(
                    children: [
                      Text(RCCubit().getText(R.gallery).toUpperCase()),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Iconify(
                          FluentEmojiHighContrast.flower_playing_cards,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VideoCompressionTest extends StatefulWidget {
  const VideoCompressionTest({Key? key, this.title}) : super(key: key);

  final String? title;

  static void show() {
    Get.to(() => const VideoCompressionTest(title: 'Video Compression Test'));
  }

  @override
  _VideoCompressionTestState createState() => _VideoCompressionTestState();
}

class _VideoCompressionTestState extends State<VideoCompressionTest> {
  String _counter = 'video';

  Future<void> _compressVideo() async {
    File file;
    if (Platform.isMacOS) {
      // final typeGroup = XTypeGroup(label: 'videos', extensions: ['mov', 'mp4']);
      // file = await openFile(acceptedTypeGroups: [typeGroup]);
      throw UnimplementedError();
    } else {
      final pickedFile = await FilePicker.platform.pickFiles(
        allowCompression: true,
        type: FileType.video,
        allowMultiple: false,
      );
      if (pickedFile?.files.single.path == null) {
        return;
      }
      file = File(pickedFile!.files.single.path!);
    }

    await VideoCompress.setLogLevel(0);
    final info = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );

    setState(() {
      _counter = info!.path!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _counter,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            InkWell(
                child: const Icon(
                  Icons.cancel,
                  size: 55,
                ),
                onTap: () {
                  VideoCompress.cancelCompression();
                }),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoThumbnail()),
                );
              },
              child: const Text('Test thumbnail'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _compressVideo(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class VideoThumbnail extends StatefulWidget {
  const VideoThumbnail({super.key});

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  File? _thumbnailFile;

  @override
  Widget build(BuildContext context) {
    Future<void> _getVideoThumbnail() async {
      File? file;

      if (Platform.isMacOS) {
        // final typeGroup = XTypeGroup(label: 'videos', extensions: ['mov', 'mp4']);
        // file = await openFile(acceptedTypeGroups: [typeGroup]);
        throw UnimplementedError();
      } else {
        final picker = ImagePicker();
        final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

        if (pickedFile != null) {
          file = File(pickedFile.path);
          _thumbnailFile = await VideoCompress.getFileThumbnail(file.path);
          setState(() {
            print(_thumbnailFile);
          });
        } else {
          return;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('File Thumbnail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                child: ElevatedButton(
                    onPressed: _getVideoThumbnail, child: const Text('Get File Thumbnail'))),
            _buildThumbnail(),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (_thumbnailFile != null) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        child: Image(image: FileImage(_thumbnailFile!)),
      );
    }
    return Container();
  }
}

class LocationDisabledException implements Exception {
  String message;

  LocationDisabledException(this.message);
}

class LocationDeniedException implements Exception {
  String message;

  LocationDeniedException(this.message);
}

class LocationPermanentlyDeniedException implements Exception {
  String message;

  LocationPermanentlyDeniedException(this.message);
}
