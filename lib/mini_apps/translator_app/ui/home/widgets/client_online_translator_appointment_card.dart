import 'package:fibali/mini_apps/translator_app/utils/md_app_colors.dart';
import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/call.dart';

class ClientTranslatorAppointmentCard extends StatefulWidget {
  final TranslatorAppointment appointment;
  final Color? color;
  const ClientTranslatorAppointmentCard({super.key, required this.appointment, this.color});

  @override
  State<ClientTranslatorAppointmentCard> createState() => _ClientTranslatorAppointmentCardState();
}

class _ClientTranslatorAppointmentCardState extends State<ClientTranslatorAppointmentCard> {
  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return bd.Badge(
      position: bd.BadgePosition.topEnd(end: 10),
      badgeContent: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.deepOrange.shade300,
        ),
        child: Row(
          children: [
            const Text(
              'CLASS: ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
            Text(
              widget.appointment.interClass!,
              style: const TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
      badgeStyle: const bd.BadgeStyle(
        shape: bd.BadgeShape.instagram,
        badgeColor: Colors.transparent,
        elevation: 0,
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        RCCubit.instance.getText(R.from).toUpperCase(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                      if (widget.appointment.interFrom is List<dynamic>)
                        Column(
                          children: widget.appointment.interFrom!
                              .map((language) => Text(
                                    language,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.deepOrangeAccent),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        RCCubit.instance.getText(R.to).toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                      if (widget.appointment.interTo is List<dynamic>)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.appointment.interTo!
                              .map((language) => Text(
                                    language,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.deepOrangeAccent),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.appointment.startDateTime != null)
              Column(
                children: [
                  const Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'START DATE',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                            Text(
                              DateFormat('EEEE, d MMM', _settingsCubit.state.appLanguage).format(
                                  (widget.appointment.startDateTime! as Timestamp).toDate()),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'TIME',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                            Text(
                              DateFormat(DateFormat.HOUR24_MINUTE, _settingsCubit.state.appLanguage)
                                  .format(
                                      (widget.appointment.startDateTime! as Timestamp).toDate()),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (widget.appointment.method != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          'BY',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.appointment.method!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(8),
                        topLeft: Radius.circular(25),
                      ),
                      gradient: LinearGradient(
                        colors: widget.appointment.type == TAType.online.name
                            ? [Colors.orange, Colors.green]
                            : [MdAppColors.kBlue, MdAppColors.kDarkBlue],
                      )),
                  child: Text(
                    ' ${widget.appointment.type!}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Text formatDate() {
    return Text(widget.appointment.timestamp is Timestamp
        ? DateFormat.yMd().add_jm().format((widget.appointment.timestamp as Timestamp).toDate())
        : '');
  }
}
