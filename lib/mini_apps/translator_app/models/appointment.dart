import 'package:fibali/mini_apps/translator_app/models/doctor.dart';
import 'package:fibali/mini_apps/translator_app/models/indication.dart';

class TranslationAppointment {
  TranslationAppointment({
    this.title,
    this.date,
    this.doctor,
    this.medicalIndications,
  });

  final String? title;
  DateTime? date;
  final Doctor? doctor;
  final List<TranslationIndication>? medicalIndications;

  static final _listIndications = [
    TranslationIndication.kDrinkWater,
    TranslationIndication.kEatVegetables,
    TranslationIndication.kExercise,
    TranslationIndication.kNoCoffee,
    TranslationIndication.kNoDrinkAlcohol,
    TranslationIndication.kNoEatFastFood,
  ];

  static final nextAppointment = TranslationAppointment(
    title: 'Heart care',
    date: DateTime.now().add(const Duration(days: 30)),
    doctor: Doctor.drRichard,
    medicalIndications: _listIndications,
  );

  static final skinCareAppointment = TranslationAppointment(
    title: 'Skin care',
    date: DateTime.now().subtract(const Duration(days: 10)),
    doctor: Doctor.drLiliana,
    medicalIndications: _listIndications,
  );

  static final sutureAppointment = TranslationAppointment(
    title: 'Suture revision',
    date: DateTime.now().subtract(const Duration(days: 30)),
    doctor: Doctor.drEdward,
    medicalIndications: _listIndications,
  );

  static final childAppointment = TranslationAppointment(
    title: 'Kid Vaccine',
    date: DateTime.now().subtract(const Duration(days: 50)),
    doctor: Doctor.drJulissa,
    medicalIndications: _listIndications,
  );

  static final listAppointment = [
    skinCareAppointment,
    sutureAppointment,
    childAppointment,
  ];
}
