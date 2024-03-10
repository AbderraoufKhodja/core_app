import 'package:colorful_iconify_flutter/icons/emojione.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class SelectLightModePage extends StatefulWidget {
  const SelectLightModePage({super.key});

  static Future<dynamic>? show() {
    return Get.to(() => const SelectLightModePage());
  }

  @override
  SelectLightModePageState createState() => SelectLightModePageState();
}

class SelectLightModePageState extends State<SelectLightModePage> {
  bool isDarkMode = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.lightMode)),
        leading: const PopButton(),
      ),
      body: Column(
        children: [
          const Divider(),
          Card(
            elevation: 0,
            child: ListTile(
              leading: Iconify(
                isDarkMode ? Emojione.crescent_moon : Emojione.sun,
                size: 30,
                color: isDarkMode ? Colors.grey : Colors.amber,
              ),
              title: Text(
                isDarkMode
                    ? RCCubit.instance.getText(R.darkMode)
                    : RCCubit.instance.getText(R.lightMode),
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Switch(
                value: !isDarkMode,
                activeColor: isDarkMode ? Colors.grey : Colors.amber,
                activeTrackColor: isDarkMode ? Colors.grey.shade100 : Colors.amber.shade100,
                onChanged: (value) {
                  if (isDarkMode) {
                    Get.changeThemeMode(ThemeMode.light);
                  } else {
                    Get.changeThemeMode(ThemeMode.dark);
                  }
                  isDarkMode = !isDarkMode;
                  setState(() {});
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
