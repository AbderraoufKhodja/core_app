import 'package:fibali/bloc/authentication/bloc.dart';

import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_state.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/home_page.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/offline_translator_booking_tab.dart';
import 'package:fibali/mini_apps/translator_app/utils/md_app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:get/get.dart';

class OnlineBookingTab extends StatefulWidget {
  const OnlineBookingTab({Key? key}) : super(key: key);

  @override
  State<OnlineBookingTab> createState() => _OnlineBookingTabState();
}

class _OnlineBookingTabState extends State<OnlineBookingTab> with TickerProviderStateMixin {
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
                    _dashboardCubit.updateUI();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ToggleSwitch(
                        minWidth: Get.width / 2 - 43,
                        minHeight: kBottomNavigationBarHeight,
                        cornerRadius: 8.0,
                        activeBgColors: const [
                          [MdAppColors.kBlue, MdAppColors.kDarkBlue],
                          [Colors.deepOrange, Colors.orange],
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.black12,
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: _dashboardCubit.asap == false ? 0 : 1,
                        totalSwitches: 2,
                        customTextStyles: const [
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ],
                        labels: const ['Scheduled', 'Flash'],
                        icons: const [
                          FontAwesomeIcons.calendarDay,
                          FontAwesomeIcons.bolt,
                        ],
                        radiusStyle: true,
                        onToggle: (index) {
                          if (index == 0) _dashboardCubit.asap = false;
                          if (index == 1) _dashboardCubit.asap = true;

                          _dashboardCubit.updateUI();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0),
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
                                                  maxLines: 1,
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
                    return _dashboardCubit.asap
                        ? const SizedBox()
                        : Column(
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
                                        BlocBuilder<TranslatorDashboardCubit,
                                            TranslatorDashboardState>(
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
                                      BlocBuilder<TranslatorDashboardCubit,
                                          TranslatorDashboardState>(
                                        builder: (context, state) {
                                          return _dashboardCubit.startDateTime != null
                                              ? Text(
                                                  DateFormat(DateFormat.HOUR24_MINUTE)
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
                            ],
                          );
                  },
                ),
                Divider(
                  thickness: 1,
                  color: textColor.withOpacity(0.2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _dashboardCubit.changeWidgetShowed(context, widget: Show.PHONE);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            RCCubit.instance.getText(R.phone).toUpperCase(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: textColor.withOpacity(0.7)),
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
                                  : Text(
                                      RCCubit.instance.getText(R.number),
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
                    GestureDetector(
                      onTap: () {
                        _dashboardCubit.changeWidgetShowed(context,
                            widget: Show.COMMUNICATION_METHOD);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            RCCubit.instance.getText(R.by).toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: textColor.withOpacity(0.7)),
                          ),
                          BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                            builder: (context, state) {
                              return _dashboardCubit.communicationMethod != null
                                  ? Text(
                                      _dashboardCubit.displayMethodeName!,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: textColor),
                                    )
                                  : Text(
                                      RCCubit.instance.getText(R.selectMethod),
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
                Divider(
                  thickness: 1,
                  color: textColor.withOpacity(0.2),
                ),
                BlocBuilder<TranslatorDashboardCubit, TranslatorDashboardState>(
                  builder: (context, state) {
                    return _dashboardCubit.asap
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              _dashboardCubit.changeWidgetShowed(context,
                                  widget: Show.TRANSLATOR_CLASS);
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: textColor),
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
                      _dashboardCubit.communicationMethod != null &&
                      (_dashboardCubit.asap == false
                          ? _dashboardCubit.startDateTime != null
                          : true) &&
                      _dashboardCubit.isoCode != null &&
                      _dashboardCubit.dialCode != null &&
                      _phoneNumberWithoutDialCode().isNotEmpty
                  ? Press.bold(
                      RCCubit.instance.getText(R.searchTranslator),
                      onPressed: () {
                        _dashboardCubit.handleCreateTranslatorAppointment(
                          context,
                          currentUser: _currentUser!,
                          subject: 'subject',
                          type: 'online',
                          interFrom: _dashboardCubit.translateFrom
                              .map((language) => language.isoCode)
                              .toList(),
                          interTo: _dashboardCubit.translateTo
                              .map((language) => language.isoCode)
                              .toList(),
                          interClass: _dashboardCubit.interClass,
                          method: _dashboardCubit.communicationMethod!,
                          dialCode: _dashboardCubit.dialCode!,
                          phoneNumber: _dashboardCubit.phoneNumber!,
                          isoCode: _dashboardCubit.isoCode!,
                          asap: _dashboardCubit.asap,
                          startDateTime: _dashboardCubit.asap == false
                              ? _dashboardCubit.startDateTime != null
                                  ? Timestamp.fromDate(_dashboardCubit.startDateTime!)
                                  : null
                              : null,
                          province: null,
                          subProvince: null,
                          subSubProvince: null,
                          streetAddress: null,
                          endDateTime: null,
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
