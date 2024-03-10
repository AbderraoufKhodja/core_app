import 'package:fibali/bloc/authentication/bloc.dart';

import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_state.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';

class OfflineBookingTab extends StatefulWidget {
  const OfflineBookingTab({Key? key}) : super(key: key);

  @override
  State<OfflineBookingTab> createState() => _OfflineBookingTabState();
}

class _OfflineBookingTabState extends State<OfflineBookingTab> with TickerProviderStateMixin {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  TranslatorDashboardCubit get _dashboardCubit =>
      BlocProvider.of<TranslatorDashboardCubit>(context);

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: cards,
      ),
      margin: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, right: 12.0, left: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _dashboardCubit.changeWidgetShowed(context, widget: Show.SELECT_LANGUAGE);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              RCCubit.instance.getText(R.from).toUpperCase(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textColor.withOpacity(0.7)),
                            ),
                            BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                              builder: (context, state) {
                                return _dashboardCubit.translateFrom.isNotEmpty == true
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: _dashboardCubit.translateFrom
                                            .map((language) => Text(
                                                  language.name,
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.deepOrangeAccent),
                                                ))
                                            .toList(),
                                      )
                                    : Text(
                                        RCCubit.instance.getText(R.select),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: textColor.withOpacity(0.4)),
                                      );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: VerticalDivider(
                          color: textColor.withOpacity(0.2),
                          thickness: 3,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              RCCubit.instance.getText(R.to).toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textColor.withOpacity(0.7)),
                            ),
                            BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                              builder: (context, state) {
                                return _dashboardCubit.translateTo.isNotEmpty == true
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: _dashboardCubit.translateTo
                                            .map((language) => Text(
                                                  language.name,
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.deepOrangeAccent),
                                                ))
                                            .toList(),
                                      )
                                    : Text(
                                        RCCubit.instance.getText(R.select),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: textColor.withOpacity(0.4)),
                                      );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Divider(
                          thickness: 1,
                          color: textColor.withOpacity(0.2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    RCCubit.instance.getText(R.startDate).toUpperCase(),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: textColor.withOpacity(0.7)),
                                  ),
                                  BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                                    builder: (context, state) {
                                      return _dashboardCubit.startDateTime != null
                                          ? Text(
                                              DateFormat('EEEE, d MMM',
                                                      _settingsCubit.state.appLanguage)
                                                  .format(_dashboardCubit.startDateTime!),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: textColor),
                                            )
                                          : Text(
                                              RCCubit.instance.getText(R.selectDate),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: textColor.withOpacity(0.4)),
                                            );
                                    },
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final dateTime = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: DateTime.now(),
                                  locale: _settingsCubit.getLocale(),
                                  lastDate: DateTime(DateTime.now().year + 1),
                                );
                                if (dateTime != null) {
                                  _dashboardCubit.startDateTime = dateTime;
                                  _dashboardCubit.updateUI();
                                }
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  RCCubit.instance.getText(R.time).toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: textColor.withOpacity(0.7)),
                                ),
                                BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                                  builder: (context, state) {
                                    return _dashboardCubit.startDateTime != null
                                        ? Text(
                                            DateFormat(DateFormat.HOUR24_MINUTE,
                                                    _settingsCubit.state.appLanguage)
                                                .format(_dashboardCubit.startDateTime!),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: textColor),
                                          )
                                        : const Text('');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: textColor.withOpacity(0.2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    RCCubit.instance.getText(R.endDate).toUpperCase(),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: textColor.withOpacity(0.5)),
                                  ),
                                  BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                                    builder: (context, state) {
                                      if (_dashboardCubit.endDateTime != null) {
                                        return Text(
                                          DateFormat(
                                                  'EEEE, d MMM', _settingsCubit.state.appLanguage)
                                              .format(_dashboardCubit.endDateTime!),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: textColor),
                                        );
                                      } else {
                                        return Text(
                                          RCCubit.instance.getText(R.selectDate),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: textColor.withOpacity(0.5)),
                                        );
                                      }
                                    },
                                  )
                                ],
                              ),
                              onTap: () async {
                                final dateTime = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: DateTime.now(),
                                  locale: _settingsCubit.getLocale(),
                                  lastDate: DateTime(DateTime.now().year + 1),
                                );
                                if (dateTime != null) {
                                  _dashboardCubit.endDateTime = dateTime;
                                  _dashboardCubit.updateUI();
                                }
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  RCCubit.instance.getText(R.time).toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: textColor.withOpacity(0.5)),
                                ),
                                BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                                  builder: (context, state) {
                                    return _dashboardCubit.endDateTime != null
                                        ? Text(
                                            DateFormat(DateFormat.HOUR24_MINUTE,
                                                    _settingsCubit.state.appLanguage)
                                                .format(_dashboardCubit.endDateTime!),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: textColor),
                                          )
                                        : const Text('');
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                Divider(
                  thickness: 1,
                  color: textColor.withOpacity(0.2),
                ),
                GestureDetector(
                  onTap: () {
                    _dashboardCubit.changeWidgetShowed(context, widget: Show.LOCATION);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            RCCubit.instance.getText(R.location).toUpperCase(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: textColor.withOpacity(0.5)),
                          ),
                          BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                            builder: (context, state) {
                              return _dashboardCubit.dialCode != null
                                  ? Row(
                                      children: [
                                        Text(
                                          '(${_dashboardCubit.dialCode}) ',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: textColor),
                                        ),
                                        Text(
                                          _phoneNumberWithoutDialCode(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: textColor),
                                        ),
                                      ],
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ],
                      ),
                      BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                        builder: (context, state) {
                          return _dashboardCubit.isoCode != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '(${_dashboardCubit.isoCode!})',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: textColor),
                                        ),
                                        if (_dashboardCubit.province != null)
                                          Text(
                                            ' ${_dashboardCubit.province!}',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: textColor),
                                          ),
                                        if (_dashboardCubit.subProvince != null)
                                          Text(
                                            ' | ${_dashboardCubit.subProvince!}',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: textColor),
                                          ),
                                        if (_dashboardCubit.subSubProvince != null)
                                          Text(
                                            ' | ${_dashboardCubit.subSubProvince!}',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: textColor),
                                          ),
                                      ],
                                    ),
                                    if (_dashboardCubit.streetAddress != null)
                                      Text(
                                        _dashboardCubit.streetAddress!,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: textColor),
                                      ),
                                  ],
                                )
                              : Text(
                                  RCCubit.instance.getText(R.select),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: textColor.withOpacity(0.5)),
                                );
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: textColor.withOpacity(0.2),
                ),
                BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        _dashboardCubit.changeWidgetShowed(context, widget: Show.TRANSLATOR_CLASS);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            RCCubit.instance.getText(R.translatorClass).toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: textColor.withOpacity(0.7)),
                          ),
                          BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                            builder: (context, state) {
                              return Text(
                                _dashboardCubit.interClass,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
            builder: (context, state) {
              return _dashboardCubit.translateTo.isNotEmpty == true &&
                      _dashboardCubit.translateFrom.isNotEmpty == true &&
                      _dashboardCubit.dialCode != null &&
                      _dashboardCubit.isoCode != null &&
                      _dashboardCubit.province != null &&
                      _dashboardCubit.subProvince != null &&
                      _dashboardCubit.subSubProvince != null &&
                      _phoneNumberWithoutDialCode().isNotEmpty
                  ? Press.bold(
                      RCCubit.instance.getText(R.searchTranslator),
                      onPressed: () {
                        _dashboardCubit.handleCreateTranslatorAppointment(
                          context,
                          currentUser: _currentUser!,
                          subject: 'subject',
                          type: 'offline',
                          interFrom: _dashboardCubit.translateFrom
                              .map((language) => language.isoCode)
                              .toList(),
                          interTo: _dashboardCubit.translateTo
                              .map((language) => language.isoCode)
                              .toList(),
                          interClass: _dashboardCubit.interClass,
                          dialCode: _dashboardCubit.dialCode!,
                          phoneNumber: _dashboardCubit.phoneNumber!,
                          isoCode: _dashboardCubit.isoCode!,
                          province: _dashboardCubit.province!,
                          subProvince: _dashboardCubit.subProvince!,
                          subSubProvince: _dashboardCubit.subSubProvince!,
                          streetAddress: _dashboardCubit.streetAddress,
                          startDateTime: Timestamp.fromDate(_dashboardCubit.startDateTime!),
                          endDateTime: _dashboardCubit.endDateTime != null
                              ? Timestamp.fromDate(_dashboardCubit.endDateTime!)
                              : null,
                          method: null,
                          asap: null,
                        );
                      },
                    )
                  : Press.bold(
                      RCCubit.instance.getText(R.searchTranslator),
                    );
            },
          ),
        ],
      ),
    );
  }

  String _phoneNumberWithoutDialCode() {
    if (_dashboardCubit.dialCode != null) {
      return _dashboardCubit.phoneNumber?.split(_dashboardCubit.dialCode!)[1] ?? '';
    }
    return '';
  }
}

class Press extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final Color? background;
  final Color? foreground;
  final bool loading;

  const Press.light(this.title, {super.key, this.onPressed, this.loading = false})
      : background = Colors.white,
        foreground = const Color(0xFF2F3733);

  const Press.bold(this.title,
      {super.key,
      this.onPressed,
      this.loading = false,
      this.foreground = Colors.white30,
      this.background});

  const Press.dark(this.title, {super.key, this.onPressed, this.loading = false})
      : background = const Color(0xFFFFC78C),
        foreground = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: loading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade400,
                  textStyle: const TextStyle(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: loading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        title,
                        style: TextStyle(
                          color: onPressed != null ? Colors.white : foreground,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
