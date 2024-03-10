import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/profile_screen/about_info_page.dart';
import 'package:fibali/ui/pages/profile_screen/edit_profile_page.dart';
import 'package:fibali/ui/pages/settings_pages/general_settings/general_settings.dart';
import 'package:fibali/ui/pages/settings_pages/privacy_security/privacy_security_page.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static Future? show() => Get.to(() => const SettingsPage());

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.setting)),
        leading: const PopButton(),
      ),
      body: Column(
        children: [
          const Divider(
            indent: 8,
            endIndent: 8,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              children: [
                buildContainer(
                  child: Column(
                    children: [
                      buildListTile(
                        title: RCCubit.instance.getText(R.personalInformation),
                        onTap: () => EditProfilePage.show(),
                      ),
                      const PaddedDivider(hight: 4.0),
                      buildListTile(
                        title: RCCubit.instance.getText(R.privacyNSecurity),
                        onTap: () => PrivacySecurityPage.show(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                buildContainer(
                  child: Column(
                    children: [
                      // buildListTile(
                      //   title: RCCubit.instance.getText(R.notificationSettings),
                      // ),
                      // const PaddedDivider(hight: 4.0),
                      buildListTile(
                        title: RCCubit.instance.getText(R.generalSettings),
                        onTap: () => showGeneralSettingsPage(),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 14),
                // buildContainer(
                //   child: Column(
                //     children: [
                //       // buildListTile(
                //       //   title: RCCubit.instance.getText(R.fontSize),
                //       // ),
                //       // const PaddedDivider(hight: 4.0),
                //       buildListTile(
                //         title: RCCubit.instance.getText(R.brightness),
                //         onTap: () => BrightnessPage.show(),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 14),
                buildContainer(
                  child: Column(
                    children: [
                      // buildListTile(
                      //   title: RCCubit.instance.getText(R.helpCenter),
                      // ),
                      // const PaddedDivider(hight: 4.0),
                      // buildListTile(
                      //   title: RCCubit.instance.getText(R.appreciation),
                      // ),
                      // const PaddedDivider(hight: 4.0),
                      // buildListTile(
                      //   title: RCCubit.instance.getText(R.links),
                      // ),
                      // const PaddedDivider(hight: 4.0),
                      // buildListTile(
                      //   title: RCCubit.instance.getText(R.workWithUs),
                      //   // onTap: () => showRegisterBusinessPage(),
                      // ),
                      // const PaddedDivider(hight: 4.0),
                      buildListTile(
                        title: RCCubit.instance.getText(R.about),
                        onTap: () => AboutInfoPage.show(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (BlocProvider.of<AuthBloc>(context).auth.currentUser?.isAnonymous == false)
                  buildContainer(
                    child: buildListTile(
                      title: RCCubit.instance.getText(R.logout),
                      onTap: () => BlocProvider.of<AuthBloc>(context).add(LoggedOutEvent(context)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card buildContainer({required Widget child}) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(padding: const EdgeInsets.symmetric(vertical: 8.0), child: child),
      );

  Widget buildListTile({
    required String title,
    Function()? onTap,
  }) {
    return ListTile(
      style: ListTileStyle.list,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      title: Text(title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: onTap == null ? Colors.grey : null)),
      onTap: onTap,
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: Colors.grey.shade300,
        size: 14,
      ),
      horizontalTitleGap: 5,
    );
  }
}
