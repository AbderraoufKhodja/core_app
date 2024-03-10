import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_list_tile.dart';
import 'package:fibali/ui/pages/client_orders_page.dart';
import 'package:fibali/ui/pages/contacts_page.dart';
import 'package:fibali/ui/pages/live_post_factory/live_post_factory_page.dart';
import 'package:fibali/ui/pages/my_stores/my_stores_page.dart';
import 'package:fibali/ui/pages/profile_screen/edit_profile_page.dart';
import 'package:fibali/ui/pages/profile_screen/settings_page.dart';
import 'package:fibali/ui/pages/swaps_page.dart';
import 'package:fibali/ui/pages/view_history/view_history_page.dart';
import 'package:fibali/ui/widgets/labeled_icon.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/jam.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              CustomListTile(
                leading: Iconify(
                  Jam.user,
                  color: Get.iconColor,
                ),
                title: RCCubit.instance.getText(R.personalInformation), //Personal information
                onTap: () => EditProfilePage.show(),
              ),
              CustomListTile(
                leading: Iconify(
                  Carbon.friendship,
                  color: Get.iconColor,
                ),
                title: RCCubit.instance.getText(R.contacts), //Contacts
                onTap: () => ContactsPage.show(),
              ),
              CustomListTile(
                leading: Iconify(
                  Jam.history,
                  color: Get.iconColor,
                ),
                title: RCCubit.instance.getText(R.history), //History
                onTap: () => ViewHistoryPage.show(),
              ),
              CustomListTile(
                leading: Iconify(
                  Jam.tag,
                  color: Get.iconColor,
                ),
                title: RCCubit.instance.getText(R.orders), //Orders
                onTap: () => ClientOrdersPage.show(),
              ),
              CustomListTile(
                leading: Iconify(
                  Mdi.cards_outline,
                  color: Get.iconColor,
                ),
                title: RCCubit.instance.getText(R.swaps), //Swaps
                onTap: () => SwapsPage.show(),
              ),
              // CustomListTile(
              //   leading: const Iconify(Jam.shopping_cart),
              //   title: RCCubit.instance.getText(R.cart), //Cart
              // ),
              // CustomListTile(
              //   leading: const Iconify(Jam.ticket),
              //   title: RCCubit.instance.getText(R.coupons), //Coupons
              // ),
              // CustomListTile(
              //   leading: const Iconify(Jam.star),
              //   title: RCCubit.instance.getText(R.wishList), //Wish List
              // ),
              // CustomListTile(
              //   leading: const Iconify(Mdi.redhat),
              //   title: RCCubit.instance.getText(R.vip), //VIP
              // ),
              const PaddedDivider(),
              CustomListTile(
                leading: const Icon(Icons.live_tv_rounded),
                title: RCCubit.instance.getText(R.startLiveStreaming),
                onTap: () => LivePostFactoryPage.show(postID: null),
              ),
              const PaddedDivider(),
              CustomListTile(
                leading: const Icon(Icons.store_rounded),
                title: RCCubit.instance.getText(R.myStores),
                onTap: () => MyStoresPage.show(),
              ),
              // CustomListTile(
              //   leading: const Iconify(Jam.directions),
              //   title: RCCubit.instance.getText(R.guidelines), //Guidelines
              // ),
              // CustomListTile(
              //   leading: const Iconify(Jam.link),
              //   title: RCCubit.instance.getText(R.links), //Links
              // ),
              // CustomListTile(
              //   leading: const Iconify(IconParkOutline.necktie),
              //   title: RCCubit.instance.getText(R.workWithUs),
              //   onTap: () => showRegisterBusinessPage(),
              // ),
              // CustomListTile(
              //   leading: FaIcon(FontAwesomeIcons.codeBranch),
              //   title: RCCubit.instance.getText(R.version), //Version
              // ),
              // CustomListTile(
              //   leading: FaIcon(FontAwesomeIcons.fileAlt),
              //   title: RCCubit.instance.getText(R.termsOfUse), //Terms of Use
              // ),
              // CustomListTile(
              //   leading: FaIcon(FontAwesomeIcons.lock),
              //   title: RCCubit.instance.getText(R.privacyTerms), //Privacy Terms
              // ),
              // CustomListTile(
              //   leading: FaIcon(FontAwesomeIcons.signOutAlt),
              //   title: RCCubit.instance.getText(R.logout), //Logout
              //   onTap: () =>
              //       BlocProvider.of<AuthBloc>(context).add(LoggedOutEvent(context)),
              // ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LabeledIcon(
                icon: Jam.settings_alt,
                label: RCCubit.instance.getText(R.settings),
                onTap: () => SettingsPage.show(),
              ),
              // LabeledIcon(icon: Jam.headset, label: RCCubit.instance.getText(R.help)),
              // LabeledIcon(icon: Jam.minus_rectangle, label: RCCubit.instance.getText(R.scan), onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }
}
