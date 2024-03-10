import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_events.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

export 'package:fibali/bloc/firebase_analytics/firebase_events.dart';
part 'firebase_analytics_state.dart';

class FAC extends Cubit<FirebaseAnalyticsCubitState> {
  FAC() : super(FirebaseAnalyticsCubitInitial());

  static void logEvent(FAEvent event, {Map<String, dynamic>? parameters}) {
    if (!kDebugMode) {
      FirebaseAnalytics.instance.logEvent(name: event.name);
    }
  }

  static void setUserProperties({required AppUser currentUser}) {
    if (!kDebugMode) {
      FirebaseAnalytics.instance.setUserId(id: currentUser.uid);
      final userJson = currentUser.toFAJson();
      for (final key in userJson.keys) {
        if (userJson[key] is String?) {
          FirebaseAnalytics.instance.setUserProperty(
            name: key,
            value: userJson[key] as String?,
          );
        }
      }
    }
  }
}
