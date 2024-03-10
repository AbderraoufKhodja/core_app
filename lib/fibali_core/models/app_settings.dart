import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends Equatable {
  final double distance;
  final double? userLocationLastChangeTime;
  final double? latitude;
  final double? longitude;
  final double? businessLatitude;
  final double? businessLongitude;
  final List<String> keywords;
  final bool showUserItemsPageTuto;
  final bool showSearchPageTuto;
  final bool isStrictSearchMode;
  final bool isIntroduced;
  final bool isSwapItAppIntroduced;
  final bool performedFirstSwipe;
  final bool performedFirstSwipeRight;
  final bool performedFirstSwipeLeft;
  final bool isSwapScreenShowCaseDone;
  final bool requestNotifyPermission;
  final String? appLanguage;
  final String? lightMode;
  final String? dialCode;
  final String? isoCode;
  final String? phoneNumber;
  final String? appCountry;
  final String? currency;

  const AppSettings({
    required this.distance,
    required this.userLocationLastChangeTime,
    required this.latitude,
    required this.longitude,
    required this.businessLatitude,
    required this.businessLongitude,
    required this.keywords,
    required this.showUserItemsPageTuto,
    required this.showSearchPageTuto,
    required this.isStrictSearchMode,
    required this.isIntroduced,
    required this.isSwapItAppIntroduced,
    required this.performedFirstSwipe,
    required this.performedFirstSwipeRight,
    required this.performedFirstSwipeLeft,
    required this.isSwapScreenShowCaseDone,
    required this.requestNotifyPermission,
    required this.appLanguage,
    required this.lightMode,
    required this.dialCode,
    required this.isoCode,
    required this.phoneNumber,
    required this.appCountry,
    required this.currency,
  });

  @override
  List<Object?> get props => [
        distance,
        userLocationLastChangeTime,
        latitude,
        longitude,
        businessLatitude,
        businessLongitude,
        keywords,
        showUserItemsPageTuto,
        showSearchPageTuto,
        isStrictSearchMode,
        isIntroduced,
        isSwapItAppIntroduced,
        performedFirstSwipe,
        performedFirstSwipeRight,
        performedFirstSwipeLeft,
        isSwapScreenShowCaseDone,
        requestNotifyPermission,
        appLanguage,
        lightMode,
        dialCode,
        isoCode,
        phoneNumber,
        appCountry,
        currency,
      ];

  factory AppSettings.fromSharedPreferences(SharedPreferences prefs) {
    return AppSettings(
      distance: prefs.getDouble('distance') ?? 100,
      userLocationLastChangeTime: prefs.getDouble('userLocationLastChangeTime'),
      latitude: prefs.getDouble('latitude'),
      longitude: prefs.getDouble('longitude'),
      businessLatitude: prefs.getDouble('businessLatitude'),
      businessLongitude: prefs.getDouble('businessLongitude'),
      keywords: prefs.getStringList('keywords') ?? [],
      showUserItemsPageTuto: prefs.getBool('showUserItemsPageTuto') ?? true,
      showSearchPageTuto: prefs.getBool('showSearchPageTuto') ?? true,
      isStrictSearchMode: prefs.getBool('isStrictSearchMode') ?? false,
      isIntroduced: prefs.getBool('isIntroduced') ?? false,
      isSwapItAppIntroduced: prefs.getBool('isSwapItAppIntroduced') ?? false,
      performedFirstSwipe: prefs.getBool('performedFirstSwipe') ?? false,
      performedFirstSwipeRight: prefs.getBool('performedFirstSwipeRight') ?? false,
      performedFirstSwipeLeft: prefs.getBool('performedFirstSwipeLeft') ?? false,
      isSwapScreenShowCaseDone: prefs.getBool('isSwapScreenShowCaseDone') ?? false,
      requestNotifyPermission: prefs.getBool('requestNotifyPermission') ?? true,
      appLanguage: prefs.getString('appLanguage'),
      lightMode: prefs.getString('lightMode'),
      dialCode: prefs.getString('dialCode'),
      isoCode: prefs.getString('isoCode'),
      phoneNumber: prefs.getString('phoneNumber'),
      appCountry: prefs.getString('appCountry'),
      currency: prefs.getString('currency'),
    );
  }

  factory AppSettings.initial() {
    return AppSettings(
      distance: 100,
      userLocationLastChangeTime: null,
      latitude: null,
      longitude: null,
      businessLatitude: null,
      businessLongitude: null,
      keywords: [],
      showUserItemsPageTuto: true,
      showSearchPageTuto: true,
      isStrictSearchMode: false,
      isIntroduced: false,
      isSwapItAppIntroduced: false,
      performedFirstSwipe: false,
      performedFirstSwipeRight: false,
      performedFirstSwipeLeft: false,
      isSwapScreenShowCaseDone: false,
      requestNotifyPermission: true,
      appLanguage: Get.deviceLocale?.languageCode ?? 'en',
      lightMode: null,
      dialCode: '+1',
      isoCode: Get.deviceLocale?.countryCode ?? 'US',
      phoneNumber: null,
      appCountry: null,
      currency: null,
    );
  }
}
