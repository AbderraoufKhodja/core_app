import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/call.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/mini_apps/translator_app/utils/md_app_colors.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/call/call_cubit.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:language_picker/languages.dart';

class OnlineScheduledTranslationBookingDetailsPage extends StatefulWidget {
  const OnlineScheduledTranslationBookingDetailsPage({
    Key? key,
    required this.appointment,
  }) : super(key: key);
  final TranslatorAppointment appointment;

  @override
  State<OnlineScheduledTranslationBookingDetailsPage> createState() =>
      _OnlineScheduledTranslationBookingDetailsPageState();
}

class _OnlineScheduledTranslationBookingDetailsPageState
    extends State<OnlineScheduledTranslationBookingDetailsPage> {
  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.translationDetails)),
        leading: const PopButton(),
        elevation: 0.5,
      ),
      body: ListView(
        children: [
          _buildBookingInfo(),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                ...RCCubit.instance
                    .getTranslatorGuideLines(context)
                    .values
                    .map((e) => Text(e.toString())),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(RCCubit.instance.getText(R.sendJobApplication)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {},
                child: Text(
                  RCCubit.instance.getText(R.apply),
                ),
              )
            ],
          ),
        ),
      ),
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

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [MdAppColors.kBlue, MdAppColors.kDarkBlue],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
              ),
            ),
            child: Column(
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
                    SizedBox(
                      width: Get.width / 3.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            RCCubit.instance.getText(R.by).toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white60),
                          ),
                          Text(
                            appointment.method!,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    )
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
                                DateFormat(
                                        DateFormat.HOUR24_MINUTE, _settingsCubit.state.appLanguage)
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
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

Future<dynamic>? showOnlineScheduledTranslatorBookingDetailsPage(context,
    {required TranslatorAppointment appointment}) {
  return Get.to(() => Builder(builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<TranslatorDashboardCubit>(context)),
            BlocProvider.value(value: BlocProvider.of<CallHandlerCubit>(context)),
            BlocProvider.value(value: BlocProvider.of<CallCubit>(context)),
          ],
          child: OnlineScheduledTranslationBookingDetailsPage(appointment: appointment),
        );
      }));
}
