import 'dart:async';

import 'package:badges/badges.dart' as bd;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/call.dart';
import 'package:fibali/fibali_core/models/call_event.dart';
import 'package:fibali/fibali_core/models/call_model.dart';
import 'package:fibali/fibali_core/models/translator.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/call_event_page.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/translation_appointment_card.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/translator_action_bar.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/translator_call_tile.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/translator_card.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/translator_review_page.dart';
import 'package:fibali/mini_apps/translator_app/utils/md_app_colors.dart';
import 'package:fibali/ui/calls_module/presentation/cubit/home/home_call_cubit.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/entypo.dart';

class FlashTranslationBookingDetailsPage extends StatefulWidget {
  const FlashTranslationBookingDetailsPage({
    Key? key,
    required this.appointment,
  }) : super(key: key);
  final TranslatorAppointment appointment;

  @override
  State<FlashTranslationBookingDetailsPage> createState() =>
      _FlashTranslationBookingDetailsPageState();
}

class _FlashTranslationBookingDetailsPageState extends State<FlashTranslationBookingDetailsPage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return bd.Badge(
      badgeStyle: bd.BadgeStyle(
        shape: bd.BadgeShape.instagram,
        elevation: 0,
        badgeColor: Colors.white70,
        padding: EdgeInsets.only(right: Get.width * 0.4, top: Get.width * 0.4, bottom: 0),
      ),
      position: bd.BadgePosition.topEnd(end: -60, top: -100),
      badgeContent: CircleAvatar(
        backgroundColor: Colors.white,
        radius: Get.width * 0.3,
        child: PhotoWidget.asset(
          path: 'assets/xiaoyi.png',
          width: Get.width * 0.6,
          height: Get.width * 0.6,
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MdAppColors.kLightBlue,
              MdAppColors.kBlue,
            ],
          ),
        ),
        child: Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Colors.transparent,
          extendBody: false,
          body: _buildBookingInfo(),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const PopButton(color: Colors.white70),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          icon: const Iconify(
            Entypo.info_with_circle,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(
              () => Scaffold(
                appBar: AppBar(
                  title: Text(
                    RCCubit.instance.getText(R.translationDetails),
                  ),
                  leading: const PopButton(),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                body: Column(
                  children: RCCubit.instance
                      .getTranslatorGuideLines(context)
                      .entries
                      .map(
                        (element) => ListTile(
                          title: Text(element.key),
                          subtitle: Text(element.value.toString()),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildBookingInfo() {
    return StreamBuilder<DocumentSnapshot<TranslatorAppointment>>(
      stream: TranslatorAppointment.ref().doc(widget.appointment.appointmentID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingGrid(width: Get.width);
        }
        if (snapshot.data?.data()?.isValid() == true) {
          final appointment = snapshot.data!.data()!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: _buildBackground(appointment),
              ),
              _buildTranslatorDetails(appointment: appointment),
              _buildBottomBar(appointment),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  Column _buildBottomBar(TranslatorAppointment appointment) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Divider(height: 0, thickness: 1),
        Container(
          height: kBottomNavigationBarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              const Divider(height: 0),
              ActionBarButtons(appointment: appointment),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackground(TranslatorAppointment appointment) {
    final eventType = appointment.lastAppointmentEvent?[AELabels.type.name];

    if (eventType == TAStates.complete.name) {
      return TranslatorReviewPage(
        onSubmitted: (rating, ratingText) {},
      );
    }

    if (eventType == TAStates.canceledByClient.name) {
      return Center(
        child: Text(
          RCCubit.instance.getText(R.canceled),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white70),
        ),
      );
    }

    if (eventType == TAStates.canceledByTranslator.name) {
      return Center(
        child: Text(
          RCCubit.instance.getText(R.canceled),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white70),
        ),
      );
    }

    if (eventType == TAStates.newTranslatorAppointment.name) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            RCCubit.instance.getText(R.findingTranslatorEasy),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white70),
          ),
        ],
      );
    }

    if (eventType == TAStates.translatorApplication.name) {
      return buildCallLog(appointment);
    }

    if (eventType == TAStates.translatorHired.name) {
      return buildCallLog(appointment);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          RCCubit.instance.getText(R.findingTranslatorEasy),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  FirestoreQueryBuilder<CallModel> buildCallLog(TranslatorAppointment appointment) {
    return FirestoreQueryBuilder<CallModel>(
      query: CallModel.ref()
          .where(CallLabels.appointmentID.name, isEqualTo: appointment.appointmentID),
      builder: (context, snapshot, guideLines) {
        if (snapshot.isFetching) {
          return const SizedBox();
        }
        if (snapshot.hasError) {
          return const SizedBox();
        }

        if (snapshot.docs.isEmpty) {
          return const SizedBox();
        }

        final calls = snapshot.docs.map((call) => call.data()).map(
          (call) {
            final receiverID =
                _currentUser!.uid == call.callerId ? call.receiverId! : call.callerId!;

            return GestureDetector(
              onTap: () => showCallEventsPage(
                context,
                callID: call.callID,
                receiverID: receiverID,
                clientID: appointment.clientID!,
                clientName: appointment.clientName,
                clientPhoto: appointment.clientPhoto,
                translatorName: appointment.interName,
                translatorPhoto: appointment.interPhoto,
                translatorID: appointment.interID!,
              ),
              child: TranslatorCallTile(
                call: call,
                callerID: _currentUser!.uid,
                receiverID: receiverID,
              ),
            );
          },
        ).toList();

        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(height: 8),
          padding: const EdgeInsets.all(8.0),
          itemCount: calls.length,
          itemBuilder: (BuildContext _, int index) {
            // if we reached the end of the currently obtained items, we try to
            // obtain more items
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }
            return calls[index];
          },
        );
      },
    );
  }

  FutureBuilder<DocumentSnapshot<Translator>> _buildTranslatorDetails(
      {required TranslatorAppointment appointment}) {
    return FutureBuilder<DocumentSnapshot<Translator>>(
      future: Translator.ref.doc(appointment.interID).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const SizedBox();

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }

        final translator = snapshot.data?.data();

        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              if (snapshot.hasError) const SizedBox(),
              if (snapshot.data?.data()?.isValid() == true)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: appointment.interID != null
                      ? Column(
                          children: [
                            if (snapshot.data?.data()?.isValid() == true)
                              TranslatorCard(translator: translator!),
                            Divider(
                              thickness: 1,
                              color: Colors.black87.withOpacity(0.2),
                            ),
                            TranslationAppointmentCard(appointment: appointment)
                          ],
                        )
                      : null,
                )
              else
                TranslationAppointmentCard(appointment: appointment),
            ],
          ),
        );
      },
    );
  }
}

Future<dynamic>? showFlashTranslatorBookingDetailsPage(context,
    {required TranslatorAppointment appointment}) {
  return Get.to(
    () => Builder(
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<TranslatorDashboardCubit>(context)),
            BlocProvider.value(value: BlocProvider.of<CallHandlerCubit>(context)),
          ],
          child: FlashTranslationBookingDetailsPage(appointment: appointment),
        );
      },
    ),
  );
}
