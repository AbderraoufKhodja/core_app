import 'package:colorful_iconify_flutter/icons/emojione.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/my_app.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/emojione_monotone.dart';

class SelectLanguagePage extends StatefulWidget {
  const SelectLanguagePage({super.key});

  static Future<dynamic>? show() {
    return Get.to(() => const SelectLanguagePage());
  }

  @override
  SelectLanguagePageState createState() => SelectLanguagePageState();
}

class SelectLanguagePageState extends State<SelectLanguagePage> {
  String? language;

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  Size get size => MediaQuery.of(context).size;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    language = _settingsCubit.state.appLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(RCCubit.instance.getText(R.selectLanguage)),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(RCCubit.instance.getText(R.save)),
          )
        ],
      ),
      body: Column(
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: ListView(
              shrinkWrap: true,
              children: [
                buildLanguageTile(
                    activeFlag: Emojione.flag_for_united_kingdom,
                    inactiveFlag: EmojioneMonotone.flag_for_united_kingdom,
                    languageDisplayLabel: RCCubit.instance.getText(R.english),
                    languageIsoCode: SettingLanguages.en.name,
                    nativeLabel: 'English'),
                buildLanguageTile(
                    activeFlag: Emojione.flag_for_saudi_arabia,
                    inactiveFlag: EmojioneMonotone.flag_for_saudi_arabia,
                    languageDisplayLabel: RCCubit.instance.getText(R.arabic),
                    languageIsoCode: SettingLanguages.ar.name,
                    nativeLabel: 'عربي'),
                buildLanguageTile(
                    activeFlag: Emojione.flag_for_france,
                    inactiveFlag: EmojioneMonotone.flag_for_france,
                    languageDisplayLabel: RCCubit.instance.getText(R.french),
                    languageIsoCode: SettingLanguages.fr.name,
                    nativeLabel: 'Français'),
                buildLanguageTile(
                    activeFlag: Emojione.flag_for_china,
                    inactiveFlag: EmojioneMonotone.flag_for_china,
                    languageDisplayLabel: RCCubit.instance.getText(R.chinese),
                    languageIsoCode: SettingLanguages.zh_Hans.name,
                    nativeLabel: '中文')
              ],
            ),
          )
        ],
      ),
    );
  }

  Card buildLanguageTile({
    required String activeFlag,
    required String inactiveFlag,
    required String languageDisplayLabel,
    required String languageIsoCode,
    required String nativeLabel,
  }) {
    return Card(
      elevation: 0,
      color: language == languageIsoCode ? null : Colors.transparent,
      child: ListTile(
        leading: language == languageIsoCode
            ? Iconify(activeFlag, size: 40)
            : Iconify(
                inactiveFlag,
                size: 30,
                color: Colors.grey,
              ),
        title: Text(
          languageDisplayLabel,
          style: TextStyle(
            color: language == languageIsoCode ? null : Colors.grey,
            fontWeight: language == languageIsoCode ? FontWeight.bold : null,
          ),
        ),
        trailing: Text(
          nativeLabel,
          style: TextStyle(
            color: language == languageIsoCode ? null : Colors.grey,
            fontWeight: language == languageIsoCode ? FontWeight.bold : null,
          ),
        ),
        onTap: () {
          if (language != languageIsoCode) {
            MyApp.setAppLanguage(language: languageIsoCode).then((value) {
              setState(() {
                language = languageIsoCode;
              });
            });
          }
        },
      ),
    );
  }
}
