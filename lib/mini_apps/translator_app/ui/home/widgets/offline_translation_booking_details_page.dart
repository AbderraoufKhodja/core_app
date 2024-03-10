import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/call.dart';
import 'package:fibali/fibali_core/models/translator.dart';
import 'package:fibali/fibali_core/ui/widgets/curved_button.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/home_widgets.dart';
import 'package:fibali/mini_apps/translator_app/utils/md_app_colors.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/call/call_cubit.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:language_picker/languages.dart';

class OnfflineTranslationBookingDetailsPage extends StatefulWidget {
  const OnfflineTranslationBookingDetailsPage({
    Key? key,
    required this.appointment,
  }) : super(key: key);
  final TranslatorAppointment appointment;

  @override
  State<OnfflineTranslationBookingDetailsPage> createState() =>
      _OnfflineTranslationBookingDetailsPageState();
}

class _OnfflineTranslationBookingDetailsPageState
    extends State<OnfflineTranslationBookingDetailsPage> {
  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.translationDetails)),
        leading: const PopButton(),
        elevation: 0.5,
      ),
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [MdAppColors.kBlue, MdAppColors.kDarkBlue],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            ),
          ),
          child: _buildBookingInfo()),
    );
  }

  Widget _buildBookingInfo() {
    return StreamBuilder<DocumentSnapshot<TranslatorAppointment>>(
      stream: TranslatorAppointment.ref().doc(widget.appointment.appointmentID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitThreeBounce(
              color: Colors.black12,
              size: 30,
            ),
          );
        }
        if (snapshot.data?.data()?.isValid() == true) {
          final appointment = snapshot.data!.data()!;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildBookingInfo(context, appointment),
              ),
              appointment.interID != null
                  ? FutureBuilder<DocumentSnapshot<Translator>>(
                      future: Translator.ref.doc(appointment.interID).get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data?.data()?.isValid() == true) {
                          final translator = snapshot.data!.data()!;
                          return TopTranslatorCard(translator: translator);
                        }

                        return const SizedBox();
                      },
                    )
                  : Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CurvedButton(
                                child: Text(
                                  RCCubit.instance.getText(R.cancel),
                                ),
                              )
                            ],
                          ),
                          Row(children: const [
                            Text(
                              'Currently Looking for translator',
                            ),
                            SpinKitThreeBounce(
                              color: Colors.black12,
                              size: 20,
                            ),
                          ]),
                        ],
                      ),
                    ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget buildBookingInfo(BuildContext context, TranslatorAppointment appointment) {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: Get.width / 3.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    RCCubit.instance.getText(R.from).toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white60),
                  ),
                  Text(
                    Languages.defaultLanguages
                        .firstWhere((language) => language.isoCode == appointment.interFrom)
                        .name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width / 3.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    RCCubit.instance.getText(R.to).toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white60),
                  ),
                  Text(
                    Languages.defaultLanguages
                        .firstWhere((language) => language.isoCode == appointment.interTo)
                        .name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  RCCubit.instance.getText(R.startDate).toUpperCase(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white60),
                ),
                appointment.startDateTime != null
                    ? Text(
                        DateFormat('EEEE, d MMM', _settingsCubit.state.appLanguage)
                            .format((appointment.startDateTime! as Timestamp).toDate()),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                      )
                    : const Text(''),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  RCCubit.instance.getText(R.time).toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white60),
                ),
                appointment.startDateTime != null
                    ? Text(
                        DateFormat(DateFormat.HOUR24_MINUTE, _settingsCubit.state.appLanguage)
                            .format((appointment.startDateTime! as Timestamp).toDate()),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                      )
                    : const Text(''),
              ],
            ),
          ],
        ),
        const Divider(),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  RCCubit.instance.getText(R.endDate).toUpperCase(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white60),
                ),
                appointment.endDateTime != null
                    ? Text(
                        DateFormat('EEEE, d MMM', _settingsCubit.state.appLanguage)
                            .format((appointment.endDateTime! as Timestamp).toDate()),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                      )
                    : const Text(''),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  RCCubit.instance.getText(R.time).toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white60),
                ),
                appointment.endDateTime != null
                    ? Text(
                        DateFormat(DateFormat.HOUR24_MINUTE, _settingsCubit.state.appLanguage)
                            .format((appointment.endDateTime! as Timestamp).toDate()),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                      )
                    : const Text(''),
              ],
            ),
          ],
        ),
        const Divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              RCCubit.instance.getText(R.translatorClass).toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white.withOpacity(0.7)),
            ),
            Text(
              appointment.interClass!,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        const Divider(),
        Column(
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
                      color: Colors.white.withOpacity(0.5)),
                ),
                appointment.dialCode != null
                    ? Row(
                        children: [
                          Text(
                            '(${appointment.dialCode}) ',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                          ),
                          Text(
                            _phoneNumberWithoutDialCode(appointment: appointment),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
            appointment.isoCode != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '(${appointment.isoCode!})',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                          ),
                          if (appointment.province != null)
                            Text(
                              ' ${appointment.province!}',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                            ),
                          if (appointment.subProvince != null)
                            Text(
                              ' | ${appointment.subProvince!}',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                            ),
                          if (appointment.subSubProvince != null)
                            Text(
                              ' | ${appointment.subSubProvince!}',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                            ),
                        ],
                      ),
                      if (appointment.streetAddress != null)
                        Text(
                          appointment.streetAddress!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
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
                        color: Colors.white.withOpacity(0.5)),
                  ),
          ],
        )
      ],
    );
  }

  String _phoneNumberWithoutDialCode({required TranslatorAppointment appointment}) {
    if (appointment.dialCode != null) {
      return appointment.clientPhoneNumber?.split(appointment.dialCode!)[1] ?? '';
    }
    return '';
  }
}

Future<dynamic>? showOfflineScheduledTranslatorBookingDetailsPage(context,
    {required TranslatorAppointment appointment}) {
  return Get.to(() => Builder(builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<TranslatorDashboardCubit>(context)),
            BlocProvider.value(value: BlocProvider.of<CallHandlerCubit>(context)),
            BlocProvider.value(value: BlocProvider.of<CallCubit>(context)),
          ],
          child: OnfflineTranslationBookingDetailsPage(appointment: appointment),
        );
      }));
}
