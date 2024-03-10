import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/pages/user_terms_page.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/flavors.dart';
import 'package:fibali/ui/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutInfoPage extends StatelessWidget {
  const AboutInfoPage({
    super.key,
  });

  static Future? show() => Get.to(() => const AboutInfoPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const PopButton(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLogo(color: Colors.grey.shade400),
              if (F.appFlavor == Flavor.swappers)
                PhotoWidget.asset(
                  path: 'assets/swappers_rb_label_500x500.webp',
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.width / 2,
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => UserTermsPage.show(),
                  child: Text(
                    RCCubit.instance.getText(R.termsAndConditions),
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
