import 'package:fibali/my_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrightnessPage extends StatefulWidget {
  const BrightnessPage({super.key});

  static Future<dynamic>? show() {
    return Get.to(() => const BrightnessPage());
  }

  @override
  BrightnessPageState createState() => BrightnessPageState();
}

class BrightnessPageState extends State<BrightnessPage> {
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedMode = Get.isDarkMode ? BrightnessMode.dark : BrightnessMode.light;
  }

  BrightnessMode _selectedMode = BrightnessMode.light;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brightness'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Light'),
            leading: Radio(
              value: BrightnessMode.light,
              groupValue: _selectedMode,
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    _selectedMode = value;
                    _changeBrightnessMode(value);
                  }
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Dark'),
            leading: Radio(
              value: BrightnessMode.dark,
              groupValue: _selectedMode,
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    _selectedMode = value;
                    _changeBrightnessMode(value);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ListTile buildLanguageTile({
  //   required String activeFlag,
  //   required String inactiveFlag,
  //   required String languageDisplayLabel,
  //   required String languageIsoCode,
  //   required String nativeLabel,
  // }) {
  //   return ListTile(
  //     tileColor: language == languageIsoCode ? Colors.white : null,
  //     leading: language == languageIsoCode
  //         ? Iconify(activeFlag, size: 40)
  //         : Iconify(
  //             inactiveFlag,
  //             size: 30,
  //             color: Colors.grey,
  //           ),
  //     title: Text(
  //       languageDisplayLabel,
  //       style: TextStyle(
  //         color: language == languageIsoCode ? null : Colors.grey,
  //         fontWeight: language == languageIsoCode ? FontWeight.bold : null,
  //       ),
  //     ),
  //     trailing: Text(
  //       nativeLabel,
  //       style: TextStyle(
  //         color: language == languageIsoCode ? null : Colors.grey,
  //         fontWeight: language == languageIsoCode ? FontWeight.bold : null,
  //       ),
  //     ),
  //     onTap: () {
  //       if (language != languageIsoCode) {
  //         MyApp.setAppLanguage(context, language: languageIsoCode).then((value) {
  //           setState(() {
  //             language = languageIsoCode;
  //           });
  //         });
  //       }
  //     },
  //   );
  // }

  void _changeBrightnessMode(BrightnessMode mode) {
    if (mode == BrightnessMode.light) {
      // Change brightness to light mode
      Get.changeTheme(MyApp.lightTheme);
    } else {
      // Change brightness to dark mode
      Get.changeTheme(MyApp.darkTheme);
    }
  }
}

enum BrightnessMode {
  light,
  dark,
}
