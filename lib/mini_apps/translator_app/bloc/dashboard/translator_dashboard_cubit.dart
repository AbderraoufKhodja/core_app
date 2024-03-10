import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fibali/fibali_core/algeria_location.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/call.dart';
import 'package:fibali/fibali_core/models/call_event.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_state.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/communication_method.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/location_selection.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/phone_selection.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/select_language.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/translator_class.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:language_picker/languages.dart';

enum Show {
  SELECT_LANGUAGE,
  SELECT_DATE,
  HOME,
  LOCATION,
  PHONE,
  TRANSLATOR_CLASS,
  COMMUNICATION_METHOD
}

enum Itinerary { FROM, TO }

class TranslatorDashboardCubit extends Cubit<TranslatorDashboardState> {
  TranslatorDashboardCubit() : super(DashboardInitial());

  final dashRepo = DashboardRepository();
  Show show = Show.HOME;
  Itinerary airportState = Itinerary.FROM;
  DateTime? startDateTime;
  DateTime? endDateTime;
  bool isSubmitting = false;

  List<String> provinces = AlgeriaCities.getProvinces();
  List<String> subProvinces = [];
  List<String> subSubProvinces = [];

  String? isoCode;
  String? province;
  String? subProvince;
  String? subSubProvince;
  String? phoneNumber;
  String? dialCode;
  String? streetAddress;

  String interClass = 'ALL';
  String? communicationMethod;
  String? displayMethodeName;
  bool asap = false;

  List<Language> languages = Languages.defaultLanguages;
  final List<Language> translateFrom = [];
  final List<Language> translateTo = [];

  Future<void> handleCreateTranslatorAppointment(
    context, {
    required AppUser currentUser,
    required String subject,
    required String type,
    required List<dynamic> interFrom,
    required List<dynamic> interTo,
    required String interClass,
    required String? method,
    required bool? asap,
    required String dialCode,
    required String phoneNumber,
    required String isoCode,
    required String? province,
    required String? subProvince,
    required String? subSubProvince,
    required String? streetAddress,
    required Timestamp? startDateTime,
    required Timestamp? endDateTime,
  }) {
    //TODO: enable check isSubmitting
    if (true) {
      if (!isSubmitting) {
        isSubmitting = true;
        EasyLoading.show(dismissOnTap: true);

        final languages = interFrom.followedBy(interTo).toList();
        List<String> languagesCodings = <String>[];
        languages.forEach((slectedLanguage) {
          languages.forEach((language) {
            if (slectedLanguage != language) {
              languagesCodings.add(Utils.getUniqueID(firstID: slectedLanguage, secondID: language));
            }
          });
        });

        languagesCodings = languagesCodings.toSet().toList();

        return FirebaseFunctions.instance.httpsCallable('createTranslatorAppointment').call({
          TALabels.clientID.name: currentUser.uid,
          TALabels.clientName.name: currentUser.name,
          TALabels.clientPhoto.name: currentUser.photoUrl,
          TALabels.subject.name: subject,
          TALabels.type.name: type,
          TALabels.interFrom.name: interFrom,
          TALabels.interTo.name: interTo,
          TALabels.languagesCodings.name: languagesCodings,
          TALabels.interClass.name: interClass,
          TALabels.method.name: method,
          TALabels.asap.name: asap,
          TALabels.isActive.name: true,
          TALabels.dialCode.name: dialCode,
          TALabels.clientPhoneNumber.name: phoneNumber,
          TALabels.isoCode.name: isoCode,
          TALabels.province.name: province,
          TALabels.subProvince.name: subProvince,
          TALabels.subSubProvince.name: subSubProvince,
          TALabels.streetAddress.name: streetAddress,
          TALabels.startDateTime.name: startDateTime?.millisecondsSinceEpoch,
          TALabels.endDateTime.name: endDateTime?.millisecondsSinceEpoch,
        }).then(
          (channelId) {
            isSubmitting = false;
            //TODO: reactivate JoinChannelVideo
            EasyLoading.showInfo('channel ID will be $channelId');

            // CallMethods.makeCloudCall(
            //   uid: 0,
            //   channelName: channelId.data,
            // ).then((result) {
            //   isSubmitting = false;
            //   //TODO: reactivate JoinChannelVideo
            //   EasyLoading.showInfo('TODO: reactivate JoinChannelVideo');
            //   // Navigator.push(
            //   //   context,
            //   //   MaterialPageRoute(
            //   //     builder: (context) => JoinChannelVideo(
            //   //       token: result?['token'],
            //   //       channelId: result?['channelId'],
            //   //       call: null,
            //   //       uid: 0,
            //   //     ),
            //   //   ),
            //   // );
            // }).onError((error, stackTrace) {
            //   isSubmitting = false;
            //   EasyLoading.showError(RCCubit.instance.getText(R.failed),
            //       dismissOnTap: true);
            // });
          },
        );
      } else {
        EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
        return Future.value(null);
      }
    }
  }

  changeWidgetShowed(context, {required Show widget}) {
    if (kDebugMode) {
      debugPrint(widget.toString());
    }

    if (widget == Show.SELECT_LANGUAGE) showSelectLanguageBottomSheet(context);
    if (widget == Show.TRANSLATOR_CLASS) {
      showSelectTranslatorClassBottomSheet(context);
    }
    if (widget == Show.COMMUNICATION_METHOD) {
      showSelectCommunicationMethodBottomSheet(context);
    }
    if (widget == Show.LOCATION) showSelectLocationBottomSheet(context);
    if (widget == Show.PHONE) showSelectPhoneBottomSheet(context);
  }

  changeWidgetLanguage({required Itinerary widget}) {
    emit(DashboardLoading());
    airportState = widget;
    if (kDebugMode) {
      debugPrint(airportState.toString());
    }
    emit(DashboardUpdated());
  }

  closeWidgetShowed() {
    emit(DashboardLoading());
    show = Show.HOME;
    emit(DashboardUpdated());
    Get.back();
  }

  updateUI() {
    emit(DashboardLoading());
    emit(DashboardUpdated());
  }

  Future<void> handleCancelTranslatorAppointment(context,
      {required TranslatorAppointment appointment}) async {
    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.show(dismissOnTap: true);
      return dashRepo.cancelTranslatorAppointment(appointment: appointment).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss();
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
        isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
    }
  }
}

class DashboardRepository {
  final _db = FirebaseFirestore.instance;

  final callsRef = TranslatorAppointment.ref();

  Future<void> cancelTranslatorAppointment({required TranslatorAppointment appointment}) {
    final writeBatch = _db.batch();

    final appointmentRef = TranslatorAppointment.ref().doc(appointment.appointmentID!);

    final appointmentEventRef =
        AppointmentEvent.ref(appointmentID: appointment.appointmentID!).doc();

    final appointmentEvent = AppointmentEvent(
      type: TAStates.canceledByClient.name,
      appointmentID: appointment.appointmentID!,
      clientName: appointment.clientName,
      clientID: appointment.clientID,
      interID: appointment.interID,
      rating: null,
      isSeen: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    writeBatch
      ..update(
        appointmentRef,
        {
          TALabels.lastAppointmentEvent.name: appointmentEvent.toFirestore(),
          TALabels.isActive.name: false, // To exclude this doc from beign queried
        },
      )
      ..set(appointmentEventRef, appointmentEvent);

    return writeBatch.commit();
  }

  Future<String> _requestTranslatorAppointment({
    required AppUser currentUser,
    required String subject,
    required List<dynamic> interFrom,
    required List<dynamic> interTo,
    required String type,
    required String? method,
    required bool asap,
    required String dialCode,
    required String phoneNumber,
    required String isoCode,
    required String? province,
    required String? subProvince,
    required String? subSubProvince,
    required String? streetAddress,
    required Timestamp? startDateTime,
    required Timestamp? endDateTime,
    required String interClass,
  }) async {
    final writeBatch = _db.batch();

    final appointmentRef = TranslatorAppointment.ref().doc();

    final appointmentEventRef = AppointmentEvent.ref(appointmentID: appointmentRef.id).doc();

    final languages = interFrom.followedBy(interTo).toList();

    List<String> languagesCodings = <String>[];
    languages.forEach((slectedLanguage) {
      languages.forEach((language) {
        if (slectedLanguage != language) {
          languagesCodings.add(Utils.getUniqueID(firstID: slectedLanguage, secondID: language));
        }
      });
    });

    languagesCodings = languagesCodings.toSet().toList();

    final appointmentEvent = AppointmentEvent(
      type: TAStates.newTranslatorAppointment.name,
      appointmentID: appointmentRef.id,
      clientName: currentUser.name,
      clientID: currentUser.uid,
      interID: null,
      rating: null,
      isSeen: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    final appointment = TranslatorAppointment(
      usersID: [],
      appointmentID: appointmentRef.id,
      lastAppointmentEvent: appointmentEvent.toFirestore(),
      clientID: currentUser.uid,
      clientName: currentUser.name,
      clientPhoto: currentUser.photoUrl,
      clientPhoneNumber: currentUser.phoneNumber,
      subject: subject,
      interID: null,
      interName: null,
      interPhoto: null,
      interPhoneNumber: null,
      interFrom: interFrom,
      interTo: interTo,
      languagesCodings: languagesCodings,
      type: type,
      method: method,
      interClass: interClass,
      asap: asap,
      isActive: true,
      dialCode: dialCode,
      isoCode: isoCode,
      province: province,
      subProvince: subProvince,
      subSubProvince: subSubProvince,
      streetAddress: streetAddress,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      timestamp: FieldValue.serverTimestamp(),
    );

    writeBatch
      ..set(
        appointmentRef,
        appointment,
      )
      ..set(appointmentEventRef, appointmentEvent);

    return writeBatch.commit().then((value) => appointmentRef.id);
  }
}

abstract class Routes {
  static const INITIAL = '/';
  static const INTRO = '/intro';
  static const DASHBOARD = '/dashboard';
  static const FLIGHTSEARCH = '/flight_search';
  static const FLIGHTDETAILS = '/flight_details';
  static const TRAVELLERDETAILS = '/traveller_details';
  static const FLIGHTOFFERPRICE = '/flight_offer_price';
  static const PROCESSING = '/processing';
  static const PAYCARD = '/paycard';
  static const REVIEWPAY = '/reviewpay';
  static const TRIPDETAILS = '/tripdetails';
  static const MAPVIEW = '/MAPVIEW';
}
