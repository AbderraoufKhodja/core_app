import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:fibali/ui/pages/messaging_page.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/call.dart';
import 'package:fibali/fibali_core/models/call_event.dart';
import 'package:fibali/fibali_core/models/call_model.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class ActionBarButtons extends StatefulWidget {
  const ActionBarButtons({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final TranslatorAppointment appointment;

  @override
  State<ActionBarButtons> createState() => _ActionBarButtonsState();
}

class _ActionBarButtonsState extends State<ActionBarButtons> {
  TranslatorDashboardCubit get _dashboardCubit => BlocProvider.of(context);
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    if (widget.appointment.lastAppointmentEvent?[AELabels.type.name] ==
        TAStates.newTranslatorAppointment.name) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                RCCubit.instance.getText(R.connectWithClient),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SpinKitThreeBounce(color: Colors.grey.shade200),
            ],
          ),
          TextButton(
            child: Text(
              RCCubit.instance.getText(R.cancel),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onPressed: () {
              _dashboardCubit.handleCancelTranslatorAppointment(context,
                  appointment: widget.appointment);
            },
          ),
        ],
      );
    }
    if (widget.appointment.lastAppointmentEvent?[AELabels.type.name] == TAStates.complete.name) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Iconify(Ic.round_check_circle, color: Colors.green),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  RCCubit.instance.getText(R.lookingForTranslator),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          TextButton(
            child: Text(
              RCCubit.instance.getText(R.details),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onPressed: () {},
          ),
        ],
      );
    }

    if (widget.appointment.interID != null) {
      return Row(
        children: [
          ElevatedButton(
            onPressed: () {
              final typeChatID =
                  '${ChatTypes.translation.name}_${Utils.getUniqueID(firstID: _currentUser!.uid, secondID: widget.appointment.interID!)}';
              showMessagingPage(
                chatID: typeChatID,
                type: ChatTypes.translation,
                otherUserID: _currentUser!.uid == widget.appointment.clientID
                    ? widget.appointment.interID!
                    : widget.appointment.clientID!,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              RCCubit.instance.getText(R.message).toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.blueGrey,
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent.shade200,
              shadowColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              children: [
                const Iconify(
                  Mdi.local_phone,
                  size: 22,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  RCCubit.instance.getText(R.phone).toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              final chatID = '${ChatTypes.translation.name}_${Utils.getUniqueID(
                firstID: _currentUser!.uid,
                secondID: widget.appointment.interID!,
              )}';

              BlocProvider.of<CallHandlerCubit>(context).fireVideoCall(
                context,
                chat: Chat(
                  appointmentID: widget.appointment.appointmentID,
                  type: CallTypes.translationCall.name,
                  lastMessage: Message(
                    appointmentID: widget.appointment.appointmentID,
                    type: MessageTypes.call.name,
                    token: null,
                    channelName: null,
                    chatID: chatID,
                    messageID: null,
                    senderID: _currentUser?.uid,
                    senderPhoto: _currentUser?.photoUrl,
                    senderName: _currentUser?.name,
                    receiverID: widget.appointment.interID,
                    receiverPhoto: widget.appointment.interPhoto,
                    receiverName: widget.appointment.interName,
                    status: CallStatus.ringing.name,
                    createAt: DateTime.now().millisecondsSinceEpoch,
                    timestamp: DateTime.now().millisecondsSinceEpoch,
                    item: null,
                    location: null,
                    order: null,
                    swap: null,
                    otherItems: null,
                    photoUrl: null,
                    senderItems: null,
                    text: null,
                    photoUrls: null,
                  ).toFirestore(),
                  token: null,
                  channelName: null,
                  chatID: chatID,
                  senderID: _currentUser?.uid,
                  senderPhoto: _currentUser?.photoUrl,
                  senderName: _currentUser?.name,
                  receiverID: widget.appointment.interID,
                  receiverPhoto: widget.appointment.interPhoto,
                  receiverName: widget.appointment.interName,
                  createAt: DateTime.now().millisecondsSinceEpoch,
                  current: true,
                  callMethod: CallMethods.inApp.name,
                  lastEventTimestamp: FieldValue.serverTimestamp(),
                  timestamp: FieldValue.serverTimestamp(),
                  isSeen: {widget.appointment.interID!: false},
                  usersID: FieldValue.arrayRemove([_currentUser!.uid, widget.appointment.interID]),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(136, 172, 242, 75),
              shadowColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              children: [
                const Iconify(
                  Mdi.cellphone_iphone,
                  size: 22,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  RCCubit.instance.getText(R.video).toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
