import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
// import 'package:dart_openai/dart_openai.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/post_factory/post_factory_bloc.dart';
import 'package:fibali/bloc/video_post_factory/video_post_factory_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/ui/pages/post_factory/post_factory_page.dart';
import 'package:fibali/ui/pages/video_post_factory/video_post_factory_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:video_compress/video_compress.dart';

class Utils {
  static Future<List<String>> uploadPhotos({
    required Reference ref,
    required List<dynamic> files,
    bool needModeration = true,
  }) {
    return Future.wait(files.asMap().entries.map(
      (entry) {
        final photo = entry.value;
        final idx = entry.key;

        if (photo is XFile) {
          final photoFile = photo;
          final thisPhotoRef = ref.child(idx.toString());
          return uploadPhoto(
            file: photoFile,
            ref: thisPhotoRef,
            needModeration: needModeration,
          );
        }

        if (photo is String) {
          return Future.value(photo.toString());
        }

        throw Exception('Invalid photo type');
      },
    ).toList());
  }

  static Color? getInverse(Color? color) {
    if (color == null) {
      return null;
    }
    return Color.fromRGBO(
      255 - color.red,
      255 - color.green,
      255 - color.blue,
      1.0, // Opacity
    );
  }

  static String formatCurrency(String currency) {
    final currencySymbol = NumberFormat.currency(name: currency).currencySymbol;
    final isCharSymbol = currencySymbol.length == 1;
    if (isCharSymbol) {
      return currency.substring(0, 2) + currencySymbol;
    } else {
      return currency.substring(0, 2);
    }
  }

  static Future<void> uploadPostVideo({
    required String postID,
    required String uid,
    required String postPath,
    required String videoID,
    required Reference ref,
    required dynamic file,
    bool needModeration = true,
  }) {
    if (file is File) {
      return uploadPostVideoFile(
        postID: postID,
        uid: uid,
        postPath: postPath,
        videoID: videoID,
        origFile: file,
        ref: ref,
        needModeration: needModeration,
      );
    }

    if (file is String) {
      return Future.value(file.toString());
    }

    throw Exception('Invalid photo type');
  }

  static Future<void> uploadItemVideo({
    required String itemID,
    required String uid,
    required String itemPath,
    required String videoID,
    required Reference ref,
    required dynamic file,
    bool needModeration = true,
  }) {
    if (file is File) {
      return uploadItemVideoFile(
        itemID: itemID,
        uid: uid,
        itemPath: itemPath,
        videoID: videoID,
        origFile: file,
        ref: ref,
        needModeration: needModeration,
      );
    }

    if (file is String) {
      return Future.value(file.toString());
    }

    throw Exception('Invalid photo type');
  }

  static jsonFromMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }

  static Future<void> handleFirestoreCall(Future<void> Function() func, bool? isSubmitting,
      {bool canDismiss = false}) {
    if (isSubmitting == true) {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting));
      return Future.value();
    }

    isSubmitting = true;
    EasyLoading.show(dismissOnTap: canDismiss);
    return func().then((value) {
      isSubmitting = false;
      EasyLoading.showSuccess(RCCubit.instance.getText(R.success));
    }).catchError((error) {
      isSubmitting = false;
      EasyLoading.showError(RCCubit.instance.getText(R.failed));
      Logger().e(error);
    });
  }

  // repeat a function until it returns true or maxTries is reached
  static Future<void> futureDoWhile({
    required Future Function() func,
    required int? maxTries,
    String? errorMessage,
    String? successMessage,
    String? loadingMessage,
    String? tryAgainMessage,
  }) {
    int? localMaxTries = maxTries;
    return Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (loadingMessage != null) {
        EasyLoading.show(status: loadingMessage);
      }

      return func().then((value) {
        if (successMessage != null) {
          EasyLoading.showSuccess(successMessage);
        }

        // success stop
        return Future.value(false);
      }).catchError((error) {
        Logger().e(error);
        if (localMaxTries != null && (localMaxTries ?? -1) > 0) {
          localMaxTries = localMaxTries! - 1;
          if (tryAgainMessage != null) {
            EasyLoading.showInfo(tryAgainMessage);
          }

          // try again
          return Future.value(true);
        }

        if (localMaxTries == null) {
          if (tryAgainMessage != null) {
            EasyLoading.showInfo(tryAgainMessage);
          }

          // try again
          return Future.value(true);
        }

        if (errorMessage != null) {
          EasyLoading.showError(errorMessage);
        }

        // failed stop
        return Future.value(false);
      });
    });
  }

  static Future<String> uploadPhoto({
    required Reference ref,
    required XFile file,
    required bool needModeration,
  }) async {
    if (kIsWeb) {
      final photoBytes = await file.readAsBytes();
      await ref.putData(photoBytes);
    } else {
      await ref.putFile(File(file.path));
    }

    final url = await ref.getDownloadURL();

    // try {
    //   final callable = FirebaseFunctions.instance.httpsCallable('checkImage');
    //   final response = await callable.call({'url': url});
    //   Logger().i(response.data);
    // } on FirebaseFunctionsException catch (error) {
    //   Logger().e(error);
    //   ref.delete();
    //   Utils.showBlurredDialog(
    //       child: AlertDialog(
    //     title: const Text('Moderation'),
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         if (error.message == 'Error: Image contains adult content')
    //           const Text(
    //               'We noticed that the images that you are trying to upload contain adult content that may not be suitable for all audiences. Please note that adult content is not allowed on this platform. Please respect the community guidelines and refrain from posting or requesting such content. Thank you for your understanding and cooperation.'),
    //         if (error.message == 'Error: Image contains violent content')
    //           const Text(
    //               'We noticed that the images that you are trying to upload contain violent content that may not be suitable for all audiences. Please note that violent content is not allowed on this platform. Please respect the community guidelines and refrain from posting or requesting such content. Thank you for your understanding and cooperation.'),
    //         if (error.message == 'Error: Image contains medical content')
    //           const Text(
    //               'We noticed that the images that you are trying to upload contain medical content that may not be suitable for all audiences. Please note that medical content is not allowed on this platform. Please respect the community guidelines and refrain from posting or requesting such content. Thank you for your understanding and cooperation.'),
    //         if (error.message == 'Error: Image contains racy content')
    //           const Text(
    //               'We noticed that the images that you are trying to upload contain racy content that may not be suitable for all audiences. Please note that racy content is not allowed on this platform. Please respect the community guidelines and refrain from posting or requesting such content. Thank you for your understanding and cooperation.'),
    //         if (error.message == 'Error: Image contains spoof')
    //           const Text(
    //               'We noticed that the images that you are trying to upload contain spoof content that may not be suitable for all audiences. Please note that spoof content is not allowed on this platform. Please respect the community guidelines and refrain from posting or requesting such content. Thank you for your understanding and cooperation.'),
    //       ],
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Get.back();
    //         },
    //         child: const Text(
    //           'OK',
    //           style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //     ],
    //   ));
    //   throw Exception(error.message);
    // }

    return url;
  }

  static Future<void> uploadPostVideoFile({
    required String postID,
    required String uid,
    required String postPath,
    required String videoID,
    required Reference ref,
    required File origFile,
    required bool needModeration,
  }) async {
    // await VideoCompress.setLogLevel(0);
    // final compressedFile = await VideoCompress.compressVideo(
    //   origFile.path,
    //   quality: VideoQuality.HighestQuality,
    //   deleteOrigin: false,
    //   includeAudio: true,
    // );

    // final file = File(compressedFile!.path!);
    if (kIsWeb) {
      final videoBytes = await origFile.readAsBytes();

      await ref.putData(
          videoBytes,
          SettableMetadata(customMetadata: {
            "postID": postID,
            "uid": uid,
            "postPath": postPath,
            "videoID": videoID,
          }));
    } else {
      await ref.putFile(
          origFile,
          SettableMetadata(customMetadata: {
            "postID": postID,
            "uid": uid,
            "postPath": postPath,
            "videoID": videoID,
          }));
    }
  }

  static Future<void> uploadItemVideoFile({
    required String itemID,
    required String uid,
    required String itemPath,
    required String videoID,
    required Reference ref,
    required File origFile,
    required bool needModeration,
  }) async {
    if (kIsWeb) {
      final videoBytes = await origFile.readAsBytes();

      await ref.putData(
          videoBytes,
          SettableMetadata(customMetadata: {
            "itemID": itemID,
            "uid": uid,
            "itemPath": itemPath,
            "videoID": videoID,
          }));
    } else {
      await ref.putFile(
          origFile,
          SettableMetadata(customMetadata: {
            "itemID": itemID,
            "uid": uid,
            "itemPath": itemPath,
            "videoID": videoID,
          }));
    }
  }

  static Future<dynamic> showBlurredDialog({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return Get.dialog<dynamic>(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: child,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static String? timeAgo(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timeago.format(timestamp.toDate());
    } else if (timestamp is DateTime) {
      return timeago.format(timestamp);
    } else {
      return null;
    }
  }

  // get initial of a name, check if string is well-formed UTF-16, name can be null

  static String getInitial(String? name) {
    try {
      if (name == null || name.isEmpty) {
        return '';
      }

      final elements = name.split(' ');
      final initials = elements
          .map((element) {
            if (element.isEmpty) {
              return '';
            }

            for (final char in element.split('')) {
              final valid = char.runes.every((rune) {
                if (rune < 0 || rune > 0xFFFF) {
                  return false;
                }

                return true;
              });

              if (valid) {
                return char;
              } else {
                return '';
              }
            }
          })
          .where((initial) => initial?.isNotEmpty == true)
          .map((initial) => initial!)
          .toList();

      if (initials.isEmpty) {
        return '?';
      }

      if (initials.length == 1) {
        return initials[0].toUpperCase();
      }

      return '${initials[0]}${initials[1]}'.toUpperCase();
    } catch (e) {
      Logger().e('name: $name');
      Logger().e(e);
      return '?';
    }
  }

  static T? enumFromString<T>(Iterable<T> values, String? value) {
    if (value?.isNotEmpty == false) {
      return null;
    }
    return values.firstWhereOrNull((type) => type.toString().split(".").last == value);
  }

  static int? getDistance({
    required GeoPoint startLocation,
    required GeoPoint endLocation,
  }) {
    final distance = Geolocator.distanceBetween(
      startLocation.latitude,
      startLocation.longitude,
      endLocation.latitude,
      endLocation.longitude,
    );

    return distance ~/ 1000;
  }

  static int convertToCodeUnitsWith8Char({required String value}) =>
      int.parse(value.codeUnits.join().substring(0, 9));

  static String getUniqueID({
    required String firstID,
    required String secondID,
  }) {
    // Check that users ID are empty strings
    assert(firstID.isNotEmpty && secondID.isNotEmpty);

    String chatID = '';
    final List<int> firstCharCode = firstID.codeUnits;
    final List<int> secondCharCode = secondID.codeUnits;
    for (int i = 0; i < max(firstCharCode.length, secondCharCode.length); i++) {
      chatID = chatID +
          ((i < firstCharCode.length ? firstCharCode[i] : 0) +
                  (i < secondCharCode.length ? secondCharCode[i] : 0))
              .toString();
    }

    return chatID;
  }

  // static Future<bool> handleHasTextViolation({required String text}) async {
  //   String getListOfFlaggedCategories(OpenAIModerationModel moderation) {
  //     final categories = <String>[];
  //     if (moderation.results.first.categories.hate) {
  //       categories.add("hate");
  //     }
  //     if (moderation.results.first.categories.hateAndThreatening) {
  //       categories.add("hate and threatening");
  //     }
  //     if (moderation.results.first.categories.selfHarm) {
  //       categories.add("self harm");
  //     }
  //     if (moderation.results.first.categories.sexual) {
  //       categories.add("sexual");
  //     }
  //     if (moderation.results.first.categories.sexualAndMinors) {
  //       categories.add("sexual and minors");
  //     }
  //     if (moderation.results.first.categories.violence) {
  //       categories.add("violence");
  //     }
  //     if (moderation.results.first.categories.violenceAndGraphic) {
  //       categories.add("violence and graphic");
  //     }
  //     return categories.join(", ");
  //   }

  //   final moderation = await OpenAI.instance.moderation.create(input: text);

  //   if (moderation.results.first.flagged) {
  //     // show dialog moderation message
  //     Logger().i(moderation.results.first.categories);
  //     EasyLoading.dismiss();
  //     Utils.showBlurredDialog(
  //       child: AlertDialog(
  //         title: const Text('Moderation'),
  //         content: Text(
  //             'Sorry, but your message violates our community guidelines.\n\nWe have identified that your message contains ${getListOfFlaggedCategories(moderation)} content, which is not allowed on our platform. Please revise your message before submitting it.\n\nThank you for helping us maintain a safe and positive community for all users.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Get.back();
  //             },
  //             child: Text(
  //               'OK',
  //               style: GoogleFonts.cairo(
  //                 color: Colors.black54,
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     );

  //     return true;
  //   }

  //   return false;
  // }

  static Future<DocumentSnapshot<T>> futureServerAndCacheFirestoreDocument<T>(
      DocumentReference<T> ref) async {
    try {
      return ref.get(const GetOptions(source: Source.cache));
    } catch (e) {
      return ref.get(const GetOptions(source: Source.server));
    }
  }

  static Future<QuerySnapshot<T>> futureCacheServerFirestoreQuery<T>(Query<T> ref) async {
    try {
      return ref.get(const GetOptions(source: Source.cache));
    } catch (e) {
      return ref.get(const GetOptions(source: Source.server));
    }
  }
}

Future<void> showVideoImagePostFactoryPage({required AppUser currentUser}) async {
  final needLogIn = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
  if (needLogIn) {
    return;
  }

  await SettingsCubit.handlePickMedia(
    title: RCCubit().getText(R.chooseSource),
    maxNumWarning: RCCubit().getText(R.sixImagesMax),
    onFilesSelected: (picked) {
      if (picked is List<XFile>) {
        final imageFiles = picked;
        if (imageFiles.isNotEmpty == true) {
          Get.to(
            () => BlocProvider(
              create: (context) => PostFactoryBloc(currentUser: currentUser),
              child: PostFactoryPage(postID: null, imageFiles: imageFiles),
            ),
          );
        }
      } else if (picked is File) {
        final videoFile = picked;
        Get.to(
          () => BlocProvider(
            create: (context) => VideoPostFactoryBloc(currentUser: currentUser),
            child: VideoPostFactoryPage(postID: null, videoFile: videoFile),
          ),
        );
      }
    },
  );
}
