import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/module/multiple_media_selector.dart.dart';
import 'package:fibali/fibali_core/ui/widgets/chewie_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

class EditUploadMediaPage extends StatefulWidget {
  const EditUploadMediaPage({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  final void Function(List<dynamic>? images, dynamic video) onSave;

  @override
  State<EditUploadMediaPage> createState() => _EditUploadMediaPageState();
}

class _EditUploadMediaPageState extends State<EditUploadMediaPage> {
  late List<dynamic>? currentImages = List.from(_mediaSelectorCubit.images ?? <dynamic>[]);
  late dynamic currentVideo = _mediaSelectorCubit.video;
  bool isDismissing = false;

  MediaSelectorCubit get _mediaSelectorCubit => BlocProvider.of<MediaSelectorCubit>(context);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onCloseConfirm();
        return Future.value(false);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white70,
          onPressed: () {
            onAddMediasPressed().then(
              (needUpdateUI) {
                if (needUpdateUI) setState(() {});
              },
            );
          },
          child: const Iconify(Ic.baseline_add, color: Colors.black54),
        ),
        appBar: AppBar(
          title: Text(
            RCCubit.instance.getText(R.editImages),
            style: GoogleFonts.fredokaOne(color: Colors.grey),
          ),
          leading: PopButton(
            onPressed: () {
              onCloseConfirm();
            },
          ),
          elevation: 0.5,
          actions: [
            TextButton(
              child: Text(RCCubit.instance.getText(R.save)),
              onPressed: () {
                widget.onSave.call(currentImages, currentVideo);
                _mediaSelectorCubit.images = currentImages;
                _mediaSelectorCubit.video = currentVideo;
                Get.back();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              if (currentVideo is File) ChewieWidget(source: currentVideo),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '● ${RCCubit.instance.getText(R.longPressChangeOrder)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              if (currentImages?.isNotEmpty != null)
                ReorderableGridView.extent(
                  shrinkWrap: true,
                  maxCrossAxisExtent: Get.width / 4,
                  padding: const EdgeInsets.all(0.0),
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      onReorder(oldIndex, newIndex);
                    });
                  },
                  childAspectRatio: 1,
                  children: currentImages!.asMap().entries.map(
                    (entry) {
                      final idx = entry.key;
                      final val = entry.value;

                      final key = ValueKey('dismissible$idx');
                      final paddingKey = ValueKey('padding$idx');

                      return Padding(
                        key: paddingKey,
                        padding: const EdgeInsets.all(4.0),
                        child: Badge(
                          badgeStyle: const BadgeStyle(
                            badgeColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.all(0.0),
                          ),
                          badgeContent: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.grey.shade200,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                currentImages?.removeAt(idx);
                                isDismissing = false;
                              });
                            },
                          ),
                          child: Card(
                            child: val is XFile
                                ? PhotoWidget.file(
                                    file: File(val.path),
                                    fit: BoxFit.cover,
                                    width: Get.width / 3,
                                    height: Get.width / 3,
                                  )
                                : PhotoWidget.network(
                                    photoUrl: val,
                                    photoUrl100x100: null,
                                    photoUrl250x375: null,
                                    photoUrl500x500: null,
                                    fit: BoxFit.cover,
                                    width: Get.width / 3,
                                    height: Get.width / 3,
                                  ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void onCloseConfirm() {
    final eq = const ListEquality().equals.call(_mediaSelectorCubit.images, currentImages);

    if (!eq) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(RCCubit.instance.getText(R.reminder)),
          content: Text(RCCubit.instance.getText(R.ifLeaveChangesDiscarded)),
          actions: [
            TextButton(
              child: Text(
                RCCubit.instance.getText(R.discard),
              ),
              onPressed: () {
                Get.back(result: true);
              },
            ),
            TextButton(
              child: Text(
                RCCubit.instance.getText(R.kReturn),
              ),
              onPressed: () {
                Get.back(result: false);
              },
            ),
          ],
        ),
      ).then((needClose) {
        if (needClose == true) Get.back();
      });
    } else {
      Get.back();
    }
  }

  void onReorder(int oldIndex, int newIndex) {
    final temp = currentImages?.removeAt(oldIndex);
    currentImages?.insert(newIndex, temp);
  }

  Future<bool> onAddMediasPressed() async {
    List<XFile>? imageFiles;
    File? videoFile;
    bool needUpdateUI = false;

    await SettingsCubit.handlePickMedia(
      title: RCCubit.instance.getText(R.chooseSource),
      maxNumWarning: RCCubit.instance.getText(R.sixImagesMax),
      onFilesSelected: (dynamic) {
        if (dynamic is List<XFile>) {
          imageFiles = dynamic;
        } else if (dynamic is File) {
          videoFile = dynamic;
        }
      },
    );

    if (imageFiles != null) {
      currentImages ??= [];
      if (((currentImages?.length ?? 0) + imageFiles!.length) > 6) {
        Get.showSnackbar(
          GetSnackBar(
            title: RCCubit.instance.getText(R.numberLimited),
            message: RCCubit.instance.getText(R.sixImagesMax),
          ),
        );

        if (currentImages?.length == 6) return false;

        final validImagesNumber = 6 - (currentImages?.length ?? 0);
        currentImages?.addAll(imageFiles!.sublist(0, validImagesNumber));
        needUpdateUI = true;
      } else {
        currentImages?.addAll(imageFiles!);
        needUpdateUI = true;
      }
    }

    if (videoFile != null) {
      currentVideo = videoFile;
      needUpdateUI = true;
    }

    return needUpdateUI;
  }
}
