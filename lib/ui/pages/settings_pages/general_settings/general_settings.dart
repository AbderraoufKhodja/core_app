import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/select_language_page.dart';
import 'package:fibali/ui/pages/select_light_mode_page.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({Key? key}) : super(key: key);

  @override
  GeneralSettingsPageState createState() => GeneralSettingsPageState();
}

class GeneralSettingsPageState extends State<GeneralSettingsPage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) return const LogInWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.generalSettings)),
        elevation: 0,
        centerTitle: true,
        leading: const PopButton(),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) => widgets[index],
        separatorBuilder: (context, index) => const PaddedDivider(hight: 8.0),
        itemCount: widgets.length,
      ),
    );
  }

  List<Widget> get widgets => <Widget>[
        buildContainer(
          child: buildListTile(
            title: RCCubit.instance.getText(R.language),
            trailing: '',
            onTap: () => SelectLanguagePage.show()?.then((value) {
              setState(() {});
            }),
          ),
        ),
        buildContainer(
          child: buildListTile(
            title: RCCubit.instance.getText(R.lightMode),
            trailing: '',
            onTap: () => SelectLightModePage.show(),
          ),
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

  Card buildContainer({required Widget child}) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(padding: const EdgeInsets.symmetric(vertical: 8.0), child: child),
      );
}

Future<void> showGeneralSettingsPage() async {
  Get.to(() => const GeneralSettingsPage());
}
