import 'dart:io';

import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:language_picker/languages.dart';

class AccountSetupPage extends StatefulWidget {
  const AccountSetupPage({Key? key}) : super(key: key);

  @override
  AccountSetupPageState createState() => AccountSetupPageState();
}

class AccountSetupPageState extends State<AccountSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  AuthBloc get _authBloc => BlocProvider.of<AuthBloc>(context);

  SettingsCubit get settings => BlocProvider.of<SettingsCubit>(context);

  XFile? _photoFile;
  String? _photoUrl;

// It's sample code of Dialog Item.
  Widget _buildDialogItem(Language language) {
    late String nativeLetter;
    switch (language.isoCode) {
      case 'ar':
        nativeLetter = 'عربية';
        break;
      case 'fr':
        nativeLetter = 'Francais';
        break;
      case 'zh_Hans':
        nativeLetter = '中文';
        break;
      default:
        nativeLetter = 'English';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(language.name),
        const SizedBox(width: 8.0),
        Flexible(child: Text(nativeLetter))
      ],
    );
  }

  @override
  void initState() {
    if (_authBloc.auth.currentUser?.displayName != null) {
      _nameController.text = _authBloc.auth.currentUser!.displayName ?? '';
    } else if (_authBloc.auth.currentUser?.email != null) {
      _nameController.text = _authBloc.auth.currentUser!.email?.split('@')[0] ?? '';
    }
    _photoUrl = _authBloc.auth.currentUser?.photoURL;

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            RCCubit.instance.getText(R.profile),
            style: GoogleFonts.fredokaOne(color: Colors.grey),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: _onSubmitted,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: RCCubit.instance.getTextWidget(context, R.save),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              const Divider(indent: 8, endIndent: 8, color: Colors.grey),
              Expanded(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        SettingsCubit.handlePickSingleGalleryCamera(
                            title: RCCubit.instance.getText(R.chooseSource),
                            onImageSelected: (image) {
                              setState(() {
                                _photoFile = image;
                              });
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _photoFile != null
                              ? PhotoWidget.file(
                                  file: File(_photoFile!.path),
                                  boxShape: BoxShape.circle,
                                  height: Get.width * 0.35,
                                  width: Get.width * 0.35,
                                )
                              : PhotoWidget.network(
                                  photoUrl: _photoUrl,
                                  boxShape: BoxShape.circle,
                                  height: Get.width * 0.35,
                                  width: Get.width * 0.35,
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        child: CustomTextField(
                          controller: _nameController,
                          hint: RCCubit.instance.getText(R.nameHint),
                          title: RCCubit.instance.getText(R.name),
                          validator: (name) =>
                              name != null ? null : RCCubit.instance.getText(R.pleaseFillName),
                          maxLines: 1,
                          maxLength: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildChangeLanguageWidget() {
  //   return GestureDetector(
  //     onTap: () => showDialog(
  //       context: context,
  //       builder: (context) => Theme(
  //           data: Theme.of(context).copyWith(primaryColor: Colors.pink),
  //           child: LanguagePickerDialog(
  //               titlePadding: const EdgeInsets.all(8.0),
  //               searchCursorColor: Colors.pinkAccent,
  //               languages: [
  //                 Languages.arabic,
  //                 Languages.french,
  //                 Languages.english,
  //                 Languages.chineseSimplified,
  //               ],
  //               searchInputDecoration: const InputDecoration(hintText: 'Search...'),
  //               title: const Text('Select your language'),
  //               onValuePicked: (Language language) async {
  //                 await settings.setAppLanguage(language: language.isoCode);
  //                 setState(() {});
  //               },
  //               itemBuilder: _buildDialogItem)),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.only(right: 8.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               const FaIcon(
  //                 FontAwesomeIcons.language,
  //                 size: 50,
  //               ),
  //               Text(
  //                 ' Language',
  //                 style:
  //                     Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  ListTile buildListTile({
    required String title,
    required String trailing,
    bool? isEmpty,
    Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
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

  _onSubmitted() {
    if (_formKey.currentState?.validate() == true) {
      _authBloc.handleAddNewUser(
        context,
        name: _nameController.text,
        defaultAddress: null,
        photoFile: _photoFile,
        photoUrl: _photoUrl,
        userID: _authBloc.auth.currentUser!.uid,
      );
    }
  }
}
