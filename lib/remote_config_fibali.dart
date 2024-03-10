import 'dart:convert';

import 'package:fibali/r_c_EN.dart';
import 'package:fibali/r_c_CN.dart';
import 'package:fibali/r_c_AR.dart';
import 'package:fibali/r_c_FR.dart';

final defaultRemoteConfigValue = {
  "appLocEN": jsonEncode(appLocEN),
  "appLocCN": jsonEncode(appLocCN),
  "appLocAR": jsonEncode(appLocAR),
  "appLocFR": jsonEncode(appLocFR),
  "translatorGuideLinesCN": jsonEncode({"01": "Be a nice guy"}),
  "completeTranslationGuideLinesFR":
      jsonEncode({"complete translation guide lines": "coming soon"}),
  "completeTranslationGuideLinesAR":
      jsonEncode({"complete translation guide lines": "coming soon"}),
  "xiaoYiRegistrationIntroAR": jsonEncode({}),
  "xiaoYiRegistrationIntroFR": jsonEncode({}),
  "completeTranslationGuideLinesEN":
      jsonEncode({"complete translation guide lines": "coming soon"}),
  "xiaoYiRegistrationIntroEN": jsonEncode({}),
  "translatorGuideLinesEN": jsonEncode({"01": "Be a nice guy"}),
  "supportedTranslationLanguages": jsonEncode(
      {"fr": "French", "ar": "Arabic", "zh_Hans": "Chinese", "en": "English"}),
  "BusinessScreenABs": "initialBusinessScreen",
  "translatorGuideLinesFR": jsonEncode({"01": "Be a nice guy"}),
  "completeTranslationGuideLinesCN":
      jsonEncode({"complete translation guide lines": "coming soon"}),
  "translatorGuideLinesAR": jsonEncode({"01": "Be a nice guy"}),
  "xiaoYiRegistrationIntroCN": jsonEncode({}),
};
