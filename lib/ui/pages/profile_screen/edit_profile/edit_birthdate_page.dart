import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:get/get.dart';

class EditBirthDayPage extends StatefulWidget {
  const EditBirthDayPage({super.key});

  static Future<dynamic>? show() {
    return Get.to(() => const EditBirthDayPage());
  }

  @override
  EditBirthDayPageState createState() => EditBirthDayPageState();
}

class EditBirthDayPageState extends State<EditBirthDayPage> {
  Timestamp? _birthDay = Timestamp.fromDate(DateTime(1992));

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  bool _isFilled = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (_currentUser?.birthDay != null) _birthDay = _currentUser?.birthDay;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) return const LogInWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.editBirthday)),
        leading: const PopButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
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
                        EasyLoading.showError(RCCubit.instance.getText(R.failed),
                            dismissOnTap: true);
                      }).whenComplete(() {
                        setState(() {
                          _isSubmitting = false;
                          checkIsFilled();
                        });
                      });
                    }
                  : null,
              child: Text(RCCubit.instance.getText(R.save)),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: buildListTile(
          title: RCCubit.instance.getText(R.birthDate),
          trailing: _birthDay != null
              ? '${_birthDay!.toDate().year}-${_birthDay!.toDate().month}-${_birthDay!.toDate().day} '
              : RCCubit.instance.getText(R.selectDate),
          isEmpty: _birthDay == null,
          onTap: () {
            showModalBottomSheet(
              context: context,
              constraints: BoxConstraints(
                maxHeight: Get.height * .6,
                minHeight: Get.height * 0.4,
              ),
              isScrollControlled: true,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(RCCubit.instance.getText(R.kReturn))),
                          Text(RCCubit.instance.getText(R.selectBirthDay)),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  checkIsFilled();
                                });
                                Navigator.pop(context);
                              },
                              child: Text(RCCubit.instance.getText(R.select))),
                        ],
                      ),
                      Expanded(
                        child: CupertinoDatePicker(
                          initialDateTime: _birthDay?.toDate(),
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (value) {
                            _birthDay = Timestamp.fromDate(value);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _onSubmitted() {
    final firestore = FirebaseFirestore.instance;

    return firestore.collection(usersCollection).doc(_currentUser!.uid).update(
      {'birthDay': _birthDay},
    ).then((value) {
      _currentUser!.birthDay = _birthDay;
    });
  }

  bool checkIsFilled() {
    return _isFilled = (_birthDay != null && _birthDay != _currentUser?.birthDay) ? true : false;
  }

  ListTile buildListTile({
    required String title,
    required String trailing,
    bool? isEmpty,
    Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      title: Text(title),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
                child: Text(
              trailing,
              style: isEmpty == true ? const TextStyle(color: Colors.grey) : null,
            )),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  get isButtonEnabled => _isFilled && !_isSubmitting;
}
