import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:flutter/material.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

import 'package:timeago/timeago.dart' as timeago;

class CallEventTile extends StatefulWidget {
  final Message message;
  final String currentUserId;
  final bool hasPendingWrites;

  const CallEventTile({
    super.key,
    required this.currentUserId,
    required this.message,
    required this.hasPendingWrites,
  });

  @override
  State<CallEventTile> createState() => _CallEventTileState();
}

class _CallEventTileState extends State<CallEventTile> {
  @override
  Widget build(BuildContext context) {
    final String timeAgo = widget.message.timestamp != null
        ? timeago.format(
            Timestamp.fromMillisecondsSinceEpoch(widget.message.timestamp!.toInt()).toDate())
        : '';
    return buildCall();
  }

  Widget buildCall() {
    return ListTile(
      title: Text(
        RCCubit.instance.getCloudText(context, widget.message.status ?? ''),
      ),
    );
  }
}
