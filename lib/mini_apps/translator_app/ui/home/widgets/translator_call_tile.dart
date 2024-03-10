import 'package:fibali/ui/calls_module/data/models/call_event.dart';
import 'package:fibali/fibali_core/models/call_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';

class TranslatorCallTile extends StatefulWidget {
  final CallModel call;
  final String callerID;
  final String receiverID;

  const TranslatorCallTile({
    super.key,
    required this.call,
    required this.callerID,
    required this.receiverID,
  });

  @override
  State<TranslatorCallTile> createState() => _TranslatorCallTileState();
}

class _TranslatorCallTileState extends State<TranslatorCallTile> {
  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      tileColor: Colors.white,
      horizontalTitleGap: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            RCCubit.instance.getCloudText(
                context, widget.call.lastCallEvent?[CallEventLabels.status.name] ?? ''),
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          widget.call.createAt != null
              ? Text(
                  DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, _settingsCubit.state.appLanguage)
                      .format(Timestamp.fromMillisecondsSinceEpoch(
                    widget.call.createAt!.toInt(),
                  ).toDate()),
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : const Text('')
        ],
      ),
      dense: true,
      leading: buildLeadingIcon(status: widget.call.lastCallEvent?[CallEventLabels.status.name]),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.call.callerName ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            DateFormat(DateFormat.HOUR24_MINUTE_SECOND, _settingsCubit.state.appLanguage)
                .format(Timestamp.fromMillisecondsSinceEpoch(
              widget.call.createAt!.toInt(),
            ).toDate()),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget buildLeadingIcon({required String? status}) {
    if (status == CallStatus.accept.name) {
      return const Iconify(Mdi.phone_in_talk, color: Colors.black87);
    }
    if (status == CallStatus.cancel.name) {
      return const Iconify(Mdi.phone_missed, color: Colors.black87);
    }
    if (status == CallStatus.end.name) {
      return const Iconify(Mdi.phone_check, color: Colors.black87);
    }
    if (status == CallStatus.none.name) {
      return const Iconify(Mdi.phone_alert, color: Colors.black87);
    }
    if (status == CallStatus.reject.name) {
      return const Iconify(Mdi.phone_cancel, color: Colors.black87);
    }
    if (status == CallStatus.ringing.name) {
      return const Iconify(Mdi.phone_ring, color: Colors.black87);
    }
    if (status == CallStatus.unAnswer.name) {
      return const Iconify(Mdi.phone_missed, color: Colors.black87);
    }
    return const Iconify(Mdi.phone_alert);
  }
}
