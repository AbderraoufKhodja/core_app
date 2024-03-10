import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/models/view_item.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/settings_pages/privacy_security/blocked_users_page.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({Key? key}) : super(key: key);

  static Future<dynamic>? show() async {
    final needLogIn = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
    if (needLogIn) {
      return null;
    }

    return Get.to(() => const PrivacySecurityPage());
  }

  @override
  PrivacySecurityPageState createState() => PrivacySecurityPageState();
}

class PrivacySecurityPageState extends State<PrivacySecurityPage> {
  AuthBloc get _authBloc => BlocProvider.of<AuthBloc>(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.privacyNSecurity)),
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
            title: RCCubit.instance.getText(R.blocked),
            trailing: '',
            onTap: () => BlockedUsersPage.show(),
          ),
        ),
        buildContainer(
          child: buildListTile(
            title: RCCubit.instance.getText(R.deleteAccount),
            trailing: '',
            onTap: () => showAlertDialog(context),
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

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text("Delete User Data", style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Are you sure you want to delete all user data? This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            "This will permanently delete all of the user's data, including account information, preferences, and saved content. This cannot be undone. Proceed with caution.",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancel", style: TextStyle(fontSize: 16)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("Delete", style: TextStyle(fontSize: 16)),
          onPressed: () async {
            // Handle the deletion of user data
            await deleteUserData();
            Get.until((route) => route.isFirst);
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// function to delete user data
  Future<void> deleteUserData() async {
    EasyLoading.show(status: 'Deleting user data...');
    // get a reference to the Firebase user
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // delete user data from Firestore
      await AppUser.ref.doc(user.uid).delete();

      // delete user data from Firebase Storage
      try {
        await FirebaseStorage.instance.ref().child('users/${user.uid}').delete();
      } catch (e) {}

      // delete all user's generated posts
      final postQuery = await Post.ref.where(PoLabels.uid.name, isEqualTo: user.uid).get();
      for (final doc in postQuery.docs) {
        await doc.reference.delete();
      }

      // delete all user's generated swap items
      final swapItemsQuery = await SwapItem.ref.where(SILabels.uid.name, isEqualTo: user.uid).get();
      for (final doc in swapItemsQuery.docs) {
        await doc.reference.delete();
      }

      // delete all user's generated views
      final viewQuery = await ViewItem.ref.where(VLabels.uid.name, isEqualTo: user.uid).get();
      for (final doc in viewQuery.docs) {
        await doc.reference.delete();
      }

      // delete all user's generated likes
      final likesQuery = await Like.ref.where(LiLabels.uid.name, isEqualTo: user.uid).get();
      for (final doc in likesQuery.docs) {
        await doc.reference.delete();
      }

      // delete the Firebase user account
      try {
        await _authBloc.auth.currentUser?.delete();
      } catch (e) {}

      // delete the Firebase user account
      _authBloc.add(LoggedOutEvent(context));
    }
  }
}
