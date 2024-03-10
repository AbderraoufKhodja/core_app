import 'package:fibali/mini_apps/translator_app/models/appointment.dart';
import 'package:fibali/mini_apps/translator_app/models/check.dart';
export 'appointment.dart';
export 'check.dart';

class TranslationClient {
  const TranslationClient({
    this.name,
    this.lastName,
    this.email,
    this.photoUrl,
    this.phone,
    this.medicalChecks,
    this.appointmentHistory,
    this.nextAppointment,
  });

  final String? name;
  final String? lastName;
  final String? email;
  final String? photoUrl;
  final String? phone;
  final List<TranslationCheck>? medicalChecks;
  final List<TranslationAppointment>? appointmentHistory;
  final TranslationAppointment? nextAppointment;

  static final currentPatient = TranslationClient(
    name: 'Kevin',
    lastName: 'Melendez',
    email: 'kevinmdezhdez@gmail.com',
    photoUrl:
        'https://images.unsplash.com/photo-1480455624313-e29b44bbfde1?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjF8fG1lbnxlbnwwfHwwfA%3D%3D&auto=format&fit=crop&w=500&q=60',
    appointmentHistory: TranslationAppointment.listAppointment,
    nextAppointment: TranslationAppointment.nextAppointment,
    phone: '+52741137588',
    medicalChecks: const [
      TranslationCheck(check: TypeCheck.weight, value: 149.7),
      TranslationCheck(check: TypeCheck.height, value: 170.7),
      TranslationCheck(check: TypeCheck.cholesterol, value: 200),
      TranslationCheck(check: TypeCheck.electrocardiogram, value: 60),
      TranslationCheck(check: TypeCheck.bloodPressure, value: 0.87),
      TranslationCheck(check: TypeCheck.hemoglobin, value: 120),
      TranslationCheck(check: TypeCheck.glucose, value: 89),
    ],
  );
}
