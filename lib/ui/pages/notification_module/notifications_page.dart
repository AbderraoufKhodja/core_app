import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/app_notification.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/notification_module/notification_tile.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:fibali/ui/widgets/stream_firestore_query_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  static Future<dynamic>? show() {
    if (BlocProvider.of<AuthBloc>(Get.context!).auth.currentUser?.isAnonymous ?? true) {
      BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
      return null;
    }

    return Get.to(() => const NotificationsPage());
  }

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage>
    with AutomaticKeepAliveClientMixin<NotificationsPage> {
  @override
  bool get wantKeepAlive => true;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(RCCubit.instance.getText(R.notifications),
            style: GoogleFonts.fredokaOne(color: Colors.grey)),
        elevation: 0,
        leading: const PopButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(indent: 8, endIndent: 8),
          if (_currentUser == null)
            const LogInWidget()
          else
            Expanded(child: _buildNotificationTiles(chatType: ChatTypes.swapIt)),
        ],
      ),
    );
  }

  Widget _buildNotificationTiles({required ChatTypes chatType}) {
    return StreamFirestoreServerCacheQueryBuilder<AppNotification>(
      query: AppNotification.ref(userID: _currentUser!.uid)
          .orderBy(AppNotLabels.timestamp.name, descending: true),
      loader: (context, snapshot) {
        return LoadingGrid(width: Get.width - 16);
      },
      emptyBuilder: (context, snapshot) {
        return DoubleCirclesWidget(
          title: RCCubit.instance.getText(R.emptyNotificationsTitle),
          description: RCCubit.instance.getText(R.emptyNotificationsDescription),
          child: const FaIcon(FontAwesomeIcons.bell, size: 70),
        );
      },
      builder: (context, snapshot, child) {
        final notifications = snapshot.docs
            .map((doc) => doc.data())
            // .where((notification) => notification.isValid())
            .toList();

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];

            return Column(
              children: [
                NotificationTile(
                  notification: notification,
                  otherUserID: notification.receiverID!,
                ),
                const PaddedDivider(hight: 0),
              ],
            );
          },
        );
      },
    );
  }
}
