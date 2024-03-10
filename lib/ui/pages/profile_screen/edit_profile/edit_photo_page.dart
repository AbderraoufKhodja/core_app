import 'dart:io';

import 'package:badges/badges.dart' as bd;
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:image_picker/image_picker.dart';

class EditPhotoPage extends StatefulWidget {
  const EditPhotoPage({super.key});

  static Future<dynamic>? show() {
    return Get.to(() => const EditPhotoPage());
  }

  @override
  EditPhotoPageState createState() => EditPhotoPageState();
}

class EditPhotoPageState extends State<EditPhotoPage> {
  final picker = ImagePicker();

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  bool _isFilled = false;
  bool _isSubmitting = false;
  XFile? _photoFile;

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) return const LogInWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.editProfilePhoto)),
        leading: const PopButton(),
        actions: [
          TextButton(
            onPressed: isButtonEnabled
                ? () {
                    setState(() {
                      _isSubmitting = true;
                    });
                    EasyLoading.show(dismissOnTap: true);
                    _onSubmitted().then((value) {
                      EasyLoading.dismiss(animation: true);
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
                    }).whenComplete(() {
                      setState(() {
                        _isSubmitting = false;
                        checkIsFilled();
                      });
                    });
                  }
                : null,
            child: Text(RCCubit.instance.getText(R.save)),
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: GestureDetector(
              onTap: () {
                SettingsCubit.handlePickSingleGalleryCamera(
                    title: RCCubit.instance.getText(R.chooseSource),
                    onImageSelected: (images) {
                      setState(() {
                        _photoFile = images;
                        checkIsFilled();
                      });
                    });
              },
              child: bd.Badge(
                badgeStyle: const bd.BadgeStyle(
                  shape: bd.BadgeShape.circle,
                  padding: EdgeInsets.all(0),
                  badgeColor: Colors.transparent,
                  elevation: 0,
                ),
                position: bd.BadgePosition.custom(bottom: 4),
                badgeContent: Iconify(Mdi.image_edit, size: 40, color: Colors.grey.shade300),
                child: Row(
                  children: [
                    _photoFile != null
                        ? PhotoWidget.file(
                            file: File(_photoFile!.path),
                            boxShape: BoxShape.circle,
                            height: Get.width * 0.55,
                            width: Get.width * 0.5,
                          )
                        : PhotoWidgetNetwork(
                            label: Utils.getInitial(_currentUser?.name),
                            photoUrl: _currentUser!.photoUrl ?? '',
                            boxShape: BoxShape.circle,
                            height: Get.width * 0.5,
                            width: Get.width * 0.5,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmitted() async {
    if (_photoFile != null) {
      final photoUrl = await Utils.uploadPhoto(
        ref: AppUser.photoStorageRef(userID: _currentUser!.uid),
        file: _photoFile!,
        needModeration: true,
      );

      await AppUser.ref.doc(_currentUser!.uid).update(
        {AULabels.photoUrl.name: photoUrl},
      ).then((value) {
        _currentUser!.photoUrl = photoUrl;
      });
    }
  }

  bool checkIsFilled() {
    return _isFilled = _photoFile != null ? true : false;
  }

  get isButtonEnabled => _isFilled && !_isSubmitting;
}
