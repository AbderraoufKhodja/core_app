import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';
import 'package:iconify_flutter/icons/ion.dart';

class EditGenderPage extends StatefulWidget {
  const EditGenderPage({super.key});

  @override
  EditGenderPageState createState() => EditGenderPageState();
}

class EditGenderPageState extends State<EditGenderPage> {
  String? gender;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  Size get size => MediaQuery.of(context).size;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    gender = _currentUser?.gender;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) return const LogInWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.selectGender)),
        leading: const PopButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: ListView(children: [
          buildgenderTile(
            activeFlag: Twemoji.female_sign,
            inactiveFlag: Ion.md_female,
            genderDisplayLabel: RCCubit.instance.getText(R.female),
            genderBackendLabel: 'female',
          ),
          buildgenderTile(
            activeFlag: Twemoji.male_sign,
            inactiveFlag: Ion.md_male,
            genderDisplayLabel: RCCubit.instance.getText(R.male),
            genderBackendLabel: 'male',
          ),
        ]),
      ),
    );
  }

  ListTile buildgenderTile({
    required String activeFlag,
    required String inactiveFlag,
    required String genderDisplayLabel,
    required String genderBackendLabel,
  }) {
    return ListTile(
      leading: gender == genderBackendLabel
          ? Iconify(activeFlag, size: 40)
          : Iconify(
              inactiveFlag,
              size: 30,
              color: Colors.grey,
            ),
      title: Text(
        genderDisplayLabel,
        style: TextStyle(color: gender != genderBackendLabel ? Colors.grey : null),
      ),
      onTap: () {
        if (gender != genderBackendLabel) {
          _updategender(selectedgender: genderBackendLabel);
        }
      },
    );
  }

  Future<void> _updategender({required String selectedgender}) {
    final firestore = FirebaseFirestore.instance;
    isSubmitting = true;
    EasyLoading.show(dismissOnTap: true);
    return firestore.collection(usersCollection).doc(_currentUser!.uid).update(
      {'gender': selectedgender},
    ).then((value) {
      gender = selectedgender;
      EasyLoading.dismiss(animation: true);
      _currentUser!.gender = selectedgender;
    }).onError((error, stackTrace) {
      EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
    }).whenComplete(() {
      setState(() {
        isSubmitting = false;
      });
    });
  }
}

Future<void> showEditGenderPage(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: BlocProvider.of<SettingsCubit>(context)),
          BlocProvider.value(value: BlocProvider.of<AuthBloc>(context)),
          BlocProvider.value(value: BlocProvider.of<RCCubit>(context)),
        ],
        child: const EditGenderPage(),
      ),
    ),
  );
}
