import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/pages/profile_screen/edit_profile/edit_bio_page.dart';
import 'package:fibali/ui/pages/profile_screen/edit_profile/edit_birthdate_page.dart';
import 'package:fibali/ui/pages/profile_screen/edit_profile/edit_gender.dart';
import 'package:fibali/ui/pages/profile_screen/edit_profile/edit_name_page.dart';
import 'package:fibali/ui/pages/profile_screen/edit_profile/edit_photo_page.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  static Future<dynamic>? show() async {
    final needLogIn = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
    if (needLogIn) {
      return null;
    }

    return Get.to(() => const EditProfilePage());
  }

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<AppUser>>(
        stream: BlocProvider.of<AuthBloc>(context).currentUserStream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(RCCubit.instance.getText(R.editProfile)),
              leading: const PopButton(),
            ),
            body: ListView.separated(
              itemBuilder: (context, index) => widgets[index],
              separatorBuilder: (context, index) => const PaddedDivider(hight: 8.0),
              itemCount: widgets.length,
            ),
          );
        });
  }

  List<Widget> get widgets => <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: GestureDetector(
                onTap: () async {
                  await EditPhotoPage.show();
                  setState(() {});
                },
                child: Row(
                  children: [
                    PhotoWidgetNetwork(
                      label: Utils.getInitial(_currentUser?.name),
                      photoUrl: _currentUser!.photoUrl ?? '',
                      boxShape: BoxShape.circle,
                      height: Get.width * 0.25,
                      width: Get.width * 0.25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        buildListTile(
          title: RCCubit.instance.getText(R.name),
          trailing: _currentUser?.name ?? '',
          onTap: () => showEditNamePage(context).then((value) {
            setState(() {});
          }),
        ),
        // buildListTile(
        //   title: RCCubit.instance.getText(R.location),
        //   trailing: _currentUser?.country != null
        //       ? RCCubit.instance.getCloudText(context, _currentUser!.country!)
        //       : RCCubit.instance.getText(R.selectCountry),
        //   isEmpty: _currentUser?.country == null,
        //   onTap: () => showEditCountryPage(context).then((value) {
        //     MyApp.updateAppUI(context);
        //   }),
        // ),
        buildListTile(
          title: RCCubit.instance.getText(R.biography),
          trailing: _currentUser?.bio ?? RCCubit.instance.getText(R.addBiography),
          isEmpty: _currentUser?.bio == null,
          onTap: () => EditBioPage.show()?.then((value) {
            setState(() {});
          }),
        ),
        buildListTile(
          title: RCCubit.instance.getText(R.gender),
          trailing: _currentUser?.gender != null
              ? RCCubit.instance.getCloudText(context, _currentUser!.gender!)
              : RCCubit.instance.getText(R.selectGender),
          isEmpty: _currentUser?.gender == null,
          onTap: () => showEditGenderPage(context).then((value) {
            setState(() {});
          }),
        ),
        buildListTile(
          title: RCCubit.instance.getText(R.birthDate),
          trailing: _currentUser!.birthDay != null
              ? '${_currentUser!.birthDay!.toDate().year}-${_currentUser!.birthDay!.toDate().month}-${_currentUser!.birthDay!.toDate().day} '
              : RCCubit.instance.getText(R.selectBirthDay),
          isEmpty: _currentUser?.birthDay == null,
          onTap: () => EditBirthDayPage.show()?.then((value) {
            setState(() {});
          }),
        ),
      ];

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
}
