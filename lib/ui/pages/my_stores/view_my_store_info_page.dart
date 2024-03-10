import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/my_stores/edit_my_store_info_page.dart';
import 'package:flutter/material.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:get/get.dart';

class ViewMyStoreInfoPage extends StatelessWidget {
  final Store store;

  const ViewMyStoreInfoPage({super.key, required this.store});

  static Future<dynamic>? show({required Store store}) {
    return Get.to(() => ViewMyStoreInfoPage(store: store));
  }

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PhotoWidget.network(
            photoUrl: store.logo,
            width: Get.width * 0.4,
            height: Get.width * 0.4,
            boxShape: BoxShape.circle,
          ),
        ],
      ),
      if (store.name != null)
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: Text(RCCubit.instance.getText(R.name)),
          title: Text(store.name!),
        ),
      if (store.description != null)
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: Text(RCCubit.instance.getText(R.description)),
          title: Text(store.description!),
        ),
      PhotoWidget.network(
        height: Get.width * 0.4,
        width: Get.width * 0.95,
        photoUrl: store.background,
      ),
      if (store.description != null)
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: Text(RCCubit.instance.getText(R.description)),
          title: Text(store.description!),
        ),
      ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        leading: Text(RCCubit.instance.getText(R.keywords)),
        title: Wrap(
          spacing: 10,
          alignment: WrapAlignment.start,
          children: store.keywords
                  ?.map(
                    (label) => Chip(
                      label: Text(label),
                      onDeleted: () {},
                    ),
                  )
                  .toList() ??
              [Text(RCCubit.instance.getText(R.empty))],
        ),
      ),
      if (store.currency != null)
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: Text(RCCubit.instance.getText(R.currency)),
          title: Text(store.currency!),
        ),
      if (store.phoneNumber != null)
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: Text(RCCubit.instance.getText(R.phoneNumber)),
          title: Text(store.phoneNumber!),
        ),
      if (store.country != null)
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: Text(RCCubit.instance.getText(R.country)),
          title: Text(store.country!),
        ),
      if (store.province != null)
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: Text(RCCubit.instance.getText(R.province)),
          title: Text(store.province!),
        ),
      if (store.subProvince != null)
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: Text(RCCubit.instance.getText(R.subProvince)),
          title: Text(store.subProvince!),
        ),
      if (store.streetAddress != null)
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: Text(RCCubit.instance.getText(R.streetAddress)),
          title: Text(store.streetAddress!),
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.storeInfo)),
        leading: const PopButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<String>(
              child: const Icon(Icons.more_vert_outlined, color: Colors.blueGrey),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<String>(
                    value: RCCubit.instance.getText(R.addItem),
                    child: Text(RCCubit.instance.getText(R.editStore)),
                    onTap: () => Future.delayed(const Duration(milliseconds: 50)).then(
                      (value) {
                        EditMyStoreInfoPage.show(
                          store: store,
                          onSubmitted: () {},
                        );
                      },
                    ),
                  ),
                ];
              },
            ),
          )
        ],
      ),
      body: ListView.separated(
        itemCount: widgets.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int index) => widgets[index],
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
