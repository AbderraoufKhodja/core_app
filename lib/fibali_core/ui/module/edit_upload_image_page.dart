import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/module/multiple_image_selector.dart.dart';
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

class EditUploadImagePage extends StatefulWidget {
  const EditUploadImagePage({
    super.key,
    // required this.images,
    required this.onSave,
  });

  // final List<dynamic>? images;
  final void Function(List<dynamic>? images) onSave;

  @override
  State<EditUploadImagePage> createState() => _EditUploadImagePageState();
}

class _EditUploadImagePageState extends State<EditUploadImagePage> {
  late List<dynamic>? currentImages = List.from(_selectorCubit.images ?? <dynamic>[]);

  final _picker = ImagePicker();
  bool isDismissing = false;

  ImageSelectorCubit get _selectorCubit => BlocProvider.of<ImageSelectorCubit>(context);

  Size get _size => MediaQuery.of(context).size;

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
            onAddImagesPressed(context, imagePicker: _picker).then(
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
                widget.onSave.call(currentImages);
                _selectorCubit.images = currentImages;
                Get.back();
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
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
                  maxCrossAxisExtent: _size.width / 4,
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
              // if (currentImages?.isNotEmpty != null)
              //   ReorderableColumn(
              //     padding: const EdgeInsets.all(8),
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     onReorder: (oldIndex, newIndex) {
              //       setState(() {
              //         onReorder(oldIndex, newIndex);
              //       });
              //     },
              //     onNoReorder: (int index) {},
              //     onReorderStarted: (int index) {},
              //     children: currentImages!.asMap().entries.map(
              //       (entry) {
              //         final idx = entry.key;
              //         final val = entry.value;

              //         final key = ValueKey('dismissible' + idx.toString());
              //         final paddingKey = ValueKey('padding' + idx.toString());

              //         return Padding(
              //           key: paddingKey,
              //           padding: const EdgeInsets.symmetric(vertical: 4.0),
              //           child: Dismissible(
              //             key: key,
              //             background: Container(
              //               color: Colors.red,
              //               child: Center(
              //                 child: ListTile(
              //                     leading: const Iconify(
              //                       Ooui.clear,
              //                       color: Colors.white,
              //                     ),
              //                     horizontalTitleGap: 0,
              //                     title: Text(
              //                       RCCubit.instance.getText(R.delete),
              //                       style: Theme.of(context)
              //                           .textTheme
              //                           .headline6
              //                           ?.copyWith(color: Colors.white),
              //                     )),
              //               ),
              //             ),
              //             secondaryBackground: Container(color: Colors.transparent),
              //             confirmDismiss: (direction) => Future.value(!isDismissing),
              //             onResize: () {
              //               isDismissing = true;
              //             },
              //             onDismissed: (direction) {
              //               setState(() {
              //                 currentImages?.removeAt(idx);
              //                 isDismissing = false;
              //               });
              //             },
              //             movementDuration: Duration(milliseconds: 0),
              //             resizeDuration: Duration(milliseconds: 100),
              //             direction: DismissDirection.startToEnd,
              //             child: ClipRRect(
              //               borderRadius: BorderRadius.circular(10),
              //               child: val is XFile
              //                   ? PhotoWidget.file(file:
              //                           File(val.path),
              //                           fit: BoxFit.fitWidth,
              //                           height: _size.height / 7,
              //                           width: _size.width,
              //                         )
              //                   : PhotoWidget.network(photoUrl:val),
              //             ),
              //           ),
              //         );
              //       },
              //     ).toList(),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  void onCloseConfirm() {
    final eq = const ListEquality().equals.call(_selectorCubit.images, currentImages);

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

  Future<bool> onAddImagesPressed(BuildContext context, {required ImagePicker imagePicker}) async {
    late List<XFile> imageFiles;
    await SettingsCubit.handlePickMultiGalleryCamera(
      title: RCCubit.instance.getText(R.chooseSource),
      maxNumWarning: RCCubit.instance.getText(R.sixImagesMax),
      onImagesSelected: (images) {
        imageFiles = images;
      },
    );
    currentImages ??= [];

    if (((currentImages?.length ?? 0) + imageFiles.length) > 6) {
      Get.showSnackbar(
        GetSnackBar(
          title: RCCubit.instance.getText(R.numberLimited),
          message: RCCubit.instance.getText(R.sixImagesMax),
        ),
      );

      if (currentImages?.length == 6) return false;

      final validImagesNumber = 6 - (currentImages?.length ?? 0);
      currentImages?.addAll(imageFiles.sublist(0, validImagesNumber));
      return true;
    } else {
      currentImages?.addAll(imageFiles);
      return true;
    }

    return false;
  }
}
