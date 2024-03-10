import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:get/get.dart';

class EditBioPage extends StatefulWidget {
  const EditBioPage({super.key});

  static Future<dynamic>? show() {
    return Get.to(() => const EditBioPage());
  }

  @override
  EditBioPageState createState() => EditBioPageState();
}

class EditBioPageState extends State<EditBioPage> {
  final _bioController = TextEditingController();

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  bool _isFilled = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _bioController.text = _currentUser?.bio ?? '';
    _bioController.addListener(() {
      setState(() {
        checkIsFilled();
      });
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) return const LogInWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.editBiography)),
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
                      Navigator.pop(context, true);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: CustomTextField(
          controller: _bioController,
          hint: RCCubit.instance.getText(R.addBiography),
          title: RCCubit.instance.getText(R.biography),
          maxLines: 7,
          maxLength: 500,
        ),
      ),
    );
  }

  Future<void> _onSubmitted() {
    final bio = _bioController.text;
    final firestore = FirebaseFirestore.instance;

    return firestore.collection(usersCollection).doc(_currentUser!.uid).update(
      {'bio': bio},
    ).then((value) {
      _currentUser!.bio = bio;
    });
  }

  bool checkIsFilled() {
    return _isFilled =
        (_bioController.text.isNotEmpty && _bioController.text != _currentUser!.bio) ? true : false;
  }

  get isButtonEnabled => _isFilled && !_isSubmitting;
}
