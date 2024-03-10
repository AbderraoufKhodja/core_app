import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/r_c_AR.dart';
import 'package:fibali/r_c_CN.dart';
import 'package:fibali/r_c_EN.dart';
import 'package:fibali/r_c_FR.dart';
import 'package:fibali/remote_config_fibali.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

export 'package:fibali/fibali_core/utils/strings.dart';

part 'remote_config_state.dart';

class RCCubit extends Cubit<RemoteConfigState> {
  final remoteConfig = FirebaseRemoteConfig.instance;

  RCCubit() : super(RemoteConfigInitial());
  static RCCubit get instance => BlocProvider.of<RCCubit>(Get.context!);

  static String getT(R string) {
    final settings = BlocProvider.of<SettingsCubit>(Get.context!);
    late Map<String, dynamic> text;
    final key = string.toString().substring(2);

    switch (settings.state.appLanguage) {
      case 'fr':
        text = appLocFR;
        break;
      case 'ar':
        text = appLocAR;
        break;
      case 'zh_Hans':
        text = appLocCN;
        break;
      default:
        text = appLocEN;
    }

    return text.containsKey(key) == true ? text[key] : key;
  }

  String getText(R string) {
    final settings = BlocProvider.of<SettingsCubit>(Get.context!);
    late Map<String, dynamic> text;
    final key = string.toString().substring(2);

    switch (settings.state.appLanguage) {
      case 'fr':
        text = appLocFR;
        break;
      case 'ar':
        text = appLocAR;
        break;
      case 'zh_Hans':
        text = appLocCN;
        break;
      default:
        text = appLocEN;
    }

    return text.containsKey(key) == true ? text[key] : key;
  }

  String getCloudText(context, String label) {
    final settings = BlocProvider.of<SettingsCubit>(context);
    late Map<String, dynamic> text;

    switch (settings.state.appLanguage) {
      case 'fr':
        text = json.decode(remoteConfig.getValue('appLocFR').asString())
            as Map<String, dynamic>;
        break;
      case 'ar':
        text = json.decode(remoteConfig.getValue('appLocAR').asString())
            as Map<String, dynamic>;
        break;
      case 'zh_Hans':
        text = json.decode(remoteConfig.getValue('appLocCN').asString())
            as Map<String, dynamic>;
        break;
      default:
        text = json.decode(remoteConfig.getValue('appLocEN').asString())
            as Map<String, dynamic>;
    }

    return text.containsKey(label) == true ? text[label] : label;
  }

  String getBackText(SettingsCubit settings, String label) {
    late Map<String, dynamic> text;

    switch (settings.state.appLanguage) {
      case 'fr':
        text = json.decode(remoteConfig.getValue('appLocFR').asString())
            as Map<String, dynamic>;
        break;
      case 'ar':
        text = json.decode(remoteConfig.getValue('appLocAR').asString())
            as Map<String, dynamic>;
        break;
      case 'zh_Hans':
        text = json.decode(remoteConfig.getValue('appLocCN').asString())
            as Map<String, dynamic>;
        break;
      default:
        text = json.decode(remoteConfig.getValue('appLocEN').asString())
            as Map<String, dynamic>;
    }

    return text.containsKey(label) == true ? text[label] : label;
  }

  Map<String, dynamic> getTranslatorGuideLines(context) {
    final settings = BlocProvider.of<SettingsCubit>(context);
    late Map<String, dynamic> text;

    switch (settings.state.appLanguage) {
      case 'fr':
        text = json.decode(
                remoteConfig.getValue('translatorGuideLinesFR').asString())
            as Map<String, dynamic>;
        break;
      case 'ar':
        text = json.decode(
                remoteConfig.getValue('translatorGuideLinesAR').asString())
            as Map<String, dynamic>;
        break;
      case 'zh_Hans':
        text = json.decode(
                remoteConfig.getValue('translatorGuideLinesCN').asString())
            as Map<String, dynamic>;
        break;
      default:
        text = json.decode(
                remoteConfig.getValue('translatorGuideLinesEN').asString())
            as Map<String, dynamic>;
    }
    return text;
  }

  Map<String, dynamic> getCompleteTranslationGuideLines(context) {
    final settings = BlocProvider.of<SettingsCubit>(context);
    late Map<String, dynamic> text;

    switch (settings.state.appLanguage) {
      case 'fr':
        text = json.decode(remoteConfig
            .getValue('completeTranslationGuideLinesFR')
            .asString()) as Map<String, dynamic>;
        break;
      case 'ar':
        text = json.decode(remoteConfig
            .getValue('completeTranslationGuideLinesAR')
            .asString()) as Map<String, dynamic>;
        break;
      case 'zh_Hans':
        text = json.decode(remoteConfig
            .getValue('completeTranslationGuideLinesCN')
            .asString()) as Map<String, dynamic>;
        break;
      default:
        text = json.decode(remoteConfig
            .getValue('completeTranslationGuideLinesEN')
            .asString()) as Map<String, dynamic>;
    }
    return text;
  }

  Map<String, dynamic> getSupportedTranslationLanguages(context) {
    late Map<String, dynamic> text;

    text = json.decode(
            remoteConfig.getValue('supportedTranslationLanguages').asString())
        as Map<String, dynamic>;

    return text;
  }

  Map<String, dynamic> getXiaoYiRegistrationIntro(context) {
    final settings = BlocProvider.of<SettingsCubit>(context);
    late Map<String, dynamic> text;

    switch (settings.state.appLanguage) {
      case 'fr':
        text = json.decode(
                remoteConfig.getValue('xiaoYiRegistrationIntroFR').asString())
            as Map<String, dynamic>;
        break;
      case 'ar':
        text = json.decode(
                remoteConfig.getValue('xiaoYiRegistrationIntroAR').asString())
            as Map<String, dynamic>;
        break;
      case 'zh_Hans':
        text = json.decode(
                remoteConfig.getValue('xiaoYiRegistrationIntroCN').asString())
            as Map<String, dynamic>;
        break;
      default:
        text = json.decode(
                remoteConfig.getValue('xiaoYiRegistrationIntroEN').asString())
            as Map<String, dynamic>;
    }
    return text;
  }

  Text getTextWidget(context, R string) {
    final settings = BlocProvider.of<SettingsCubit>(context);
    late Map<String, dynamic> text;
    final key = string.name;

    switch (settings.state.appLanguage) {
      case 'fr':
        text = appLocFR;
        break;
      case 'ar':
        text = appLocAR;
        break;
      case 'zh_Hans':
        text = appLocCN;
        break;
      default:
        text = appLocEN;
    }

    return Text(text[key] ?? '');
  }

  Future<void> setupRemoteConfig() async {
    debugPrint('setupRemoteConfig');
    remoteConfig.setDefaults(defaultRemoteConfigValue);
    try {
      remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    await remoteConfig.fetchAndActivate();
  }

  String getRemoteABTestValue({required String key}) {
    return remoteConfig.getString(key);
  }
}

enum SettingLanguages {
  en,
  fr,
  ar,
  zh_Hans,
}

enum BusinessScreenABs {
  initialBusinessScreen,
  swapBusinessScreenMerged1,
  swapBusinessScreenMerged2,
}
