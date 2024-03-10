import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/emojione_monotone.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:colorful_iconify_flutter/icons/emojione.dart';

class EditCountryPage extends StatefulWidget {
  const EditCountryPage({Key? key}) : super(key: key);

  @override
  EditCountryPageState createState() => EditCountryPageState();
}

class EditCountryPageState extends State<EditCountryPage> {
  String? country;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  Size get size => MediaQuery.of(context).size;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    country = _currentUser?.country;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) return const LogInWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.selectCountry)),
        leading: const PopButton(),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(RCCubit.instance.getText(R.info)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: ListView(children: [
          buildCountryTile(
            activeFlag: Emojione.flag_for_algeria,
            inactiveFlag: EmojioneMonotone.flag_for_algeria,
            countryDisplayLabel: RCCubit.instance.getText(R.algeria),
            countryBackendLabel: 'DZ',
          ),
          buildCountryTile(
            activeFlag: Emojione.flag_for_morocco,
            inactiveFlag: EmojioneMonotone.flag_for_morocco,
            countryDisplayLabel: RCCubit.instance.getText(R.morroco),
            countryBackendLabel: 'MA',
          ),
          buildCountryTile(
            activeFlag: Emojione.flag_for_tunisia,
            inactiveFlag: EmojioneMonotone.flag_for_tunisia,
            countryDisplayLabel: RCCubit.instance.getText(R.tunisia),
            countryBackendLabel: 'TN',
          ),
          buildCountryTile(
            activeFlag: Emojione.flag_for_egypt,
            inactiveFlag: EmojioneMonotone.flag_for_egypt,
            countryDisplayLabel: RCCubit.instance.getText(R.egypt),
            countryBackendLabel: 'EG',
          ),
          buildCountryTile(
            activeFlag: Emojione.flag_for_egypt,
            inactiveFlag: EmojioneMonotone.flag_for_china,
            countryDisplayLabel: RCCubit.instance.getText(R.china),
            countryBackendLabel: 'CN',
          )
        ]),
      ),
    );
  }

  ListTile buildCountryTile({
    required String activeFlag,
    required String inactiveFlag,
    required String countryDisplayLabel,
    required String countryBackendLabel,
  }) {
    return ListTile(
      leading: country == countryBackendLabel
          ? Iconify(activeFlag, size: 40)
          : Iconify(
              inactiveFlag,
              size: 30,
              color: Colors.grey,
            ),
      title: Text(
        countryDisplayLabel,
        style: TextStyle(color: country != countryBackendLabel ? Colors.grey : null),
      ),
      onTap: () {
        if (country != countryBackendLabel) {
          _updateCountry(selectedCountry: countryBackendLabel);
        }
      },
    );
  }

  Future<void> _updateCountry({required String selectedCountry}) {
    final firestore = FirebaseFirestore.instance;
    isSubmitting = true;
    EasyLoading.show(dismissOnTap: true);
    return firestore.collection(usersCollection).doc(_currentUser!.uid).update(
      {'country': selectedCountry},
    ).then((value) {
      country = selectedCountry;
      EasyLoading.dismiss(animation: true);
      _currentUser!.country = selectedCountry;
    }).onError((error, stackTrace) {
      EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
    }).whenComplete(() {
      setState(() {
        isSubmitting = false;
      });
    });
  }
}

Future<void> showEditCountryPage(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: BlocProvider.of<SettingsCubit>(context)),
          BlocProvider.value(value: BlocProvider.of<AuthBloc>(context)),
          BlocProvider.value(value: BlocProvider.of<RCCubit>(context)),
        ],
        child: const EditCountryPage(),
      ),
    ),
  );
}
