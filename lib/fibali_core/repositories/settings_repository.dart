import 'package:fibali/fibali_core/models/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  late SharedPreferences prefs;

  Future<void> initSettings() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> updateDistance({
    required double distance,
  }) async {
    prefs.setDouble('distance', distance);
  }

  Future<void> disableSearchPageTuto() async {
    prefs.setBool('showSearchPageTuto', true);
  }

  Future<void> setRequestNotifyPermission({required bool value}) async {
    prefs.setBool('requestNotifyPermission', value);
  }

  Future<void> disableUserItemsPageTuto() async {
    prefs.setBool('showUserItemsPageTuto', false);
  }

  Future<void> setDialCode({required String value}) async {
    await prefs.setString('dialCode', value);
  }

  Future<void> setIsoCode({required String value}) async {
    await prefs.setString('isoCode', value);
  }

  Future<void> setPhoneNumber({required String value}) async {
    await prefs.setString('phoneNumber', value);
  }

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    prefs.setDouble('latitude', latitude);
    prefs.setDouble('longitude', longitude);
  }

  Future<void> updateChangeUserLocationTime() {
    return prefs.setDouble(
        'userLocationLastChangeTime', DateTime.now().millisecondsSinceEpoch.toDouble());
  }

  Future<void> updateBusinessLocation({
    required double latitude,
    required double longitude,
  }) async {
    prefs.setDouble('businessLatitude', latitude);
    prefs.setDouble('businessLongitude', longitude);
  }

  AppSettings getSettings() {
    return AppSettings.fromSharedPreferences(prefs);
  }

  Future<void> setStrictSearchMode(bool value) async {
    prefs.setBool('isStrictSearchMode', value);
  }

  Future<void> setIntroduced(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isIntroduced', value);
  }

  Future<void> performedFirstSwipe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('performedFirstSwipe', value);
  }

  Future<void> performedFirstSwipeRight(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('performedFirstSwipeRight', value);
  }

  Future<void> performedFirstSwipeLeft(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('performedFirstSwipeLeft', value);
  }

  Future<void> setSwapItAppIntroduced(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSwapItAppIntroduced', value);
  }

  Future<void> setSwapScreenShowCaseDone(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSwapScreenShowCaseDone', value);
  }

  Future<void> setSettingsToDefault() async {
    prefs.clear();
  }

  Future<bool> setAppLanguage(String language) {
    return prefs.setString('appLanguage', language);
  }

  Future<bool> setCountry(String country) {
    return prefs.setString('appCountry', country);
  }
}
