import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  EditNamePageState createState() => EditNamePageState();
}

class EditNamePageState extends State<EditNamePage> {
  final _nameController = TextEditingController();

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  bool _isFilled = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = _currentUser!.name;
    _nameController.addListener(() {
      setState(() {
        checkIsFilled();
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) return const LogInWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.editName)),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: CustomTextField(
          controller: _nameController,
          hint: RCCubit.instance.getText(R.nameHint),
          title: RCCubit.instance.getText(R.name),
        ),
      ),
    );
  }

  Future<void> _onSubmitted() {
    final name = _nameController.text;
    final firestore = FirebaseFirestore.instance;

    return firestore.collection(usersCollection).doc(_currentUser!.uid).update(
      {'name': name},
    ).then((value) {
      _currentUser!.name = name;
    });
  }

  bool checkIsFilled() {
    return _isFilled =
        (_nameController.text.isNotEmpty && _nameController.text != _currentUser!.name)
            ? true
            : false;
  }

  get isButtonEnabled => _isFilled && !_isSubmitting;
}

Future<void> showEditNamePage(BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: BlocProvider.of<SettingsCubit>(context)),
          BlocProvider.value(value: BlocProvider.of<AuthBloc>(context)),
          BlocProvider.value(value: BlocProvider.of<RCCubit>(context)),
        ],
        child: const EditNamePage(),
      ),
    ),
  );
}
