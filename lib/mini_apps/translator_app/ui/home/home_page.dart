import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/call.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/space.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/client_online_translator_appointment_card.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/translator_booking_card.dart';
import 'package:fibali/mini_apps/translator_app/utils/md_app_colors.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class TranslatorBookingPage extends StatefulWidget {
  const TranslatorBookingPage({super.key});

  @override
  TranslatorBookingPageState createState() => TranslatorBookingPageState();
}

class TranslatorBookingPageState extends State<TranslatorBookingPage> {
  TranslatorAppointment? latestOnlineAppointment;

  TranslatorDashboardCubit get _dashboardCubit =>
      BlocProvider.of<TranslatorDashboardCubit>(context);

  AppUser? get currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  late Timer periodicCheck;
  @override
  void initState() {
    periodicCheck = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {},
    );
    super.initState();
  }

  @override
  void dispose() {
    periodicCheck.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [MdAppColors.kBlue, MdAppColors.kDarkBlue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: ListView(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0.0),
                  visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                  title: Text(
                    'Hi ${currentUser!.name}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 18, color: Colors.white),
                  ),
                  subtitle: const Text(
                    'New users can enjoy 20 min free online translation.',
                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white70),
                  ),
                  trailing: SizedBox.square(
                    dimension: 32,
                    child: PhotoWidgetNetwork(
                      label: Utils.getInitial(currentUser?.name),
                      photoUrl: currentUser?.photoUrl ?? '',
                      height: 32,
                      width: 32,
                      boxShape: BoxShape.circle,
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot<TranslatorAppointment>>(
                  stream: TranslatorAppointment.ref()
                      .where(TALabels.clientID.name, isEqualTo: currentUser!.uid)
                      .where(TALabels.type.name, isEqualTo: TAType.online.name)
                      .where(TALabels.asap.name, isEqualTo: true)
                      .orderBy(TALabels.timestamp.name, descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return const SizedBox();

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }

                    if (snapshot.data?.docs.isNotEmpty == true) {
                      final appointments = snapshot.data!.docs
                          .map((appointmentDoc) => appointmentDoc.data())
                          .where((appointment) => appointment.isValid())
                          .toList();
                      if (appointments.isNotEmpty) {
                        latestOnlineAppointment = appointments[0];

                        if (appointments[0].timestamp is Timestamp) {
                          final secondsSinceLastOnlineAppointment =
                              (appointments[0].timestamp as Timestamp).seconds -
                                  Timestamp.now().seconds;

                          if (-1800 < secondsSinceLastOnlineAppointment) {
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.all(0.0),
                                  visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                  title: Text(
                                    RCCubit.instance.getText(R.currentTranslation),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                                ClientTranslatorAppointmentCard(appointment: appointments[0]),
                              ],
                            );
                          }
                        }
                      }
                    }

                    return const SizedBox();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FirestoreQueryBuilder<TranslatorAppointment>(
                    query: TranslatorAppointment.ref()
                        .where(TALabels.clientID.name, isEqualTo: currentUser!.uid)
                        .where(TALabels.startDateTime.name,
                            isGreaterThanOrEqualTo: Timestamp.now()),
                    pageSize: 7,
                    builder: (context, snapshot, _) {
                      if (snapshot.docs.isNotEmpty) {
                        final appointments = snapshot.docs
                            .map((appointment) => appointment.data())
                            .where((appointment) => appointment.isValid())
                            .toList();
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(0.0),
                              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                              title: Text(
                                RCCubit.instance.getText(R.scheduledTranslation),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: kBottomNavigationBarHeight * 2,
                              width: Get.width - 36,
                              child: CarouselSlider.builder(
                                itemCount: appointments.length,
                                itemBuilder:
                                    (BuildContext context, int itemIndex, int pageViewIndex) {
                                  // if we reached the end of the currently obtained items, we try to
                                  // obtain more items
                                  if (snapshot.hasMore && itemIndex + 1 == appointments.length) {
                                    // Tell FirestoreQueryBuilder to try to obtain more items.
                                    // It is safe to call this function from within the build method.
                                    snapshot.fetchMore();
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right: appointments.length == 1 ? 0.0 : 8.0),
                                    child: ClientTranslatorAppointmentCard(
                                        appointment: appointments[itemIndex]),
                                  );
                                },
                                options: CarouselOptions(
                                  height: kBottomNavigationBarHeight * 2,
                                  viewportFraction: appointments.length == 1 ? 1 : 0.9,
                                  scrollDirection: Axis.horizontal,
                                  autoPlay: false,
                                  enlargeCenterPage: false,
                                  padEnds: false,
                                  scrollPhysics: appointments.length == 1
                                      ? const NeverScrollableScrollPhysics()
                                      : null,
                                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox(height: 8);
                    },
                  ),
                ),
                const TranslatorBookingCard(),
                const Space.Y(kBottomNavigationBarHeight * 1.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const surface = Colors.blueAccent;
const cards = Colors.white70;
const textColor = Colors.blueGrey;
const primaryColor = Colors.deepOrangeAccent;
const green = Color(0xFF9ACA99);
const purple = Color(0xFFA097F2);
const teal = Color(0xFFC1E3E1);
const yellow = Color(0xFFF8CF80);
const red = Color(0xFFFF8F8F);
const appYellow = Color(0xFFBF4DF0);

const primary = LinearGradient(
    begin: Alignment(0.5, 0.5),
    end: Alignment(-0.5, 0.5),
    colors: [Color.fromRGBO(248, 130, 100, 1), Color.fromRGBO(255, 226, 196, 1)]);

const textColorI = Color(0xFF30313F);
const textColorII = Color(0xFF5F6160);
const textColorIII = Color(0xFF979797);
const textColorIV = Color(0xFF7A7B7B);
const textColorV = Color(0xFFC4C4C4);
const textColorVI = Color(0xFFD7D7D7);
const textColorVII = Color(0xFFE1E1E1);
const textColorVIII = Color(0xFFF1F1F1);
