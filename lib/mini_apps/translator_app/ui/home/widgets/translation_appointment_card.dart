import 'package:fibali/mini_apps/translator_app/ui/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/call.dart';

class TranslationAppointmentCard extends StatefulWidget {
  final TranslatorAppointment appointment;
  final Color? color;
  const TranslationAppointmentCard(
      {super.key, required this.appointment, this.color = Colors.white});

  @override
  State<TranslationAppointmentCard> createState() => _TranslationAppointmentCardState();
}

class _TranslationAppointmentCardState extends State<TranslationAppointmentCard> {
  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: widget.color),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (widget.appointment.timestamp is Timestamp)
            Row(
              children: [
                Text(
                  DateFormat('EEEE, d MMM', _settingsCubit.state.appLanguage)
                      .format((widget.appointment.timestamp! as Timestamp).toDate()),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
                ),
                Text(
                  ' | ${DateFormat(DateFormat.HOUR24_MINUTE, _settingsCubit.state.appLanguage).format((widget.appointment.timestamp! as Timestamp).toDate())}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.appointment.interFrom != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${RCCubit.instance.getText(R.from)}: ',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: textColor.withOpacity(0.7)),
                        ),
                        if (widget.appointment.interFrom is List<dynamic>)
                          Row(
                            children: widget.appointment.interFrom!
                                .map((language) => Text(
                                      language,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrangeAccent),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  if (widget.appointment.method != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${RCCubit.instance.getText(R.by)}: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: textColor.withOpacity(0.7)),
                        ),
                        Text(
                          widget.appointment.method!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  if (widget.appointment.type != null)
                    Row(
                      children: [
                        Text(
                          '${RCCubit.instance.getText(R.type)}: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: textColor.withOpacity(0.7)),
                        ),
                        Text(
                          widget.appointment.type!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.appointment.interTo != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${RCCubit.instance.getText(R.to)}: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: textColor.withOpacity(0.7)),
                        ),
                        if (widget.appointment.interTo is List<dynamic>)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.appointment.interTo!
                                .map((language) => Text(
                                      language,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrangeAccent),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  if (widget.appointment.interClass != null)
                    Row(
                      children: [
                        Text(
                          '${RCCubit.instance.getText(R.kClass)}: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: textColor.withOpacity(0.7)),
                        ),
                        Text(
                          widget.appointment.interClass!,
                        ),
                      ],
                    ),
                  if (widget.appointment.asap == true) Text(RCCubit.instance.getText(R.flash)),
                ],
              ),
            ],
          ),
          if (widget.appointment.startDateTime != null)
            Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'START DATE',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: textColor.withOpacity(0.7)),
                        ),
                        Text(
                          DateFormat('EEEE, d MMM', _settingsCubit.state.appLanguage)
                              .format((widget.appointment.startDateTime! as Timestamp).toDate()),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'TIME',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: textColor.withOpacity(0.7)),
                        ),
                        Text(
                          DateFormat(DateFormat.HOUR24_MINUTE, _settingsCubit.state.appLanguage)
                              .format((widget.appointment.startDateTime! as Timestamp).toDate()),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Text formatDate() {
    return Text(widget.appointment.timestamp is Timestamp
        ? DateFormat.yMd().add_jm().format((widget.appointment.timestamp as Timestamp).toDate())
        : '');
  }
}
