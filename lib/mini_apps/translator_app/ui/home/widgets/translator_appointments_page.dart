import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/call.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/flash_translation_booking_details_page.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/offline_translation_booking_details_page.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/online_scheduled_translation_booking_details_page.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/translation_appointment_card.dart';
import 'package:fibali/mini_apps/translator_app/utils/md_app_colors.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransAppointHistoryPage extends StatefulWidget {
  const TransAppointHistoryPage({super.key});

  @override
  State<TransAppointHistoryPage> createState() => _TransAppointHistoryPageState();
}

class _TransAppointHistoryPageState extends State<TransAppointHistoryPage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 130,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [MdAppColors.kBlue, MdAppColors.kDarkBlue],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            RCCubit.instance.getText(R.history),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            RCCubit.instance.getText(R.myPreviousTranslationSessions),
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.history,
                        color: Colors.white70,
                        size: 50,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: FirestoreListView<TranslatorAppointment>(
            query: TranslatorAppointment.ref()
                .where(TALabels.clientID.name, isEqualTo: _currentUser!.uid)
                .orderBy(TALabels.timestamp.name, descending: true),
            padding: const EdgeInsets.only(left: 15, right: 15),
            physics: const BouncingScrollPhysics(),
            loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
            itemBuilder: (_, snapshot) {
              final appointment = snapshot.data();

              if (appointment.isValid()) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: GestureDetector(
                      onTap: () {
                        if (appointment.asap == true) {
                          showFlashTranslatorBookingDetailsPage(
                            context,
                            appointment: appointment,
                          );
                        } else if (appointment.type == TAType.online.name) {
                          showOnlineScheduledTranslatorBookingDetailsPage(
                            context,
                            appointment: appointment,
                          );
                        } else {
                          showOfflineScheduledTranslatorBookingDetailsPage(
                            context,
                            appointment: appointment,
                          );
                        }
                      },
                      child: TranslationAppointmentCard(appointment: appointment)),
                );
              } else {
                return const SizedBox();
              }
            },
          )),
        ],
      ),
    );
  }
}
