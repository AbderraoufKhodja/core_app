import 'package:fibali/mini_apps/translator_app/ui/home/widgets/language_picker_dialog.dart';
import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/home_page.dart';
import 'package:badges/badges.dart' as bd;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:language_picker/languages.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/space.dart';
import 'package:get/get.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  TranslatorDashboardCubit get _dashboardCubit =>
      BlocProvider.of<TranslatorDashboardCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Space.Y(20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Space.X(20),
            Text(
              RCCubit.instance.getText(R.selectLanguages),
              style: GoogleFonts.fredokaOne(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                _dashboardCubit.closeWidgetShowed();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0.0),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              ),
              child: Text(RCCubit.instance.getText(R.save)),
            ),
            const Space.X(20),
          ],
        ),
        const Space.Y(10),
        Divider(
          thickness: 1,
          color: Colors.blueGrey.withOpacity(0.2),
        ),
        BlocBuilder<TranslatorDashboardCubit, dynamic>(
          builder: (context, state) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              bd.Badge(
                badgeStyle: const bd.BadgeStyle(
                  shape: bd.BadgeShape.instagram,
                  badgeColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.all(0.0),
                ),
                badgeContent: _dashboardCubit.translateFrom.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _dashboardCubit.translateFrom.clear();
                          });
                        },
                        icon: const Iconify(
                          Ic.baseline_clear,
                          color: Colors.grey,
                          size: 20,
                        ))
                    : null,
                child: GestureDetector(
                  onTap: () {
                    _dashboardCubit.changeWidgetLanguage(widget: Itinerary.FROM);
                  },
                  child: Container(
                    width: Get.width / 2.5,
                    padding: const EdgeInsets.all(16),
                    decoration: _dashboardCubit.airportState == Itinerary.FROM
                        ? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          )
                        : null,
                    child: SizedBox.square(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            RCCubit.instance.getText(R.from).toUpperCase(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: _dashboardCubit.airportState == Itinerary.FROM
                                    ? textColor
                                    : textColor.withOpacity(0.3)),
                          ),
                          _dashboardCubit.translateFrom.isNotEmpty == true
                              ? Column(
                                  children: _dashboardCubit.translateFrom
                                      .map((language) => Text(
                                            language.name,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.deepOrangeAccent),
                                          ))
                                      .toList(),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bd.Badge(
                badgeStyle: const bd.BadgeStyle(
                  shape: bd.BadgeShape.instagram,
                  badgeColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.all(0.0),
                ),
                badgeContent: _dashboardCubit.translateTo.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _dashboardCubit.translateTo.clear();
                          });
                        },
                        icon: const Iconify(
                          Ic.baseline_clear,
                          color: Colors.grey,
                          size: 20,
                        ))
                    : null,
                child: GestureDetector(
                  onTap: () {
                    _dashboardCubit.changeWidgetLanguage(widget: Itinerary.TO);
                  },
                  child: Container(
                    width: Get.width / 2.5,
                    padding: const EdgeInsets.all(16),
                    decoration: _dashboardCubit.airportState == Itinerary.TO
                        ? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          )
                        : null,
                    child: SizedBox.square(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            RCCubit.instance.getText(R.to).toUpperCase(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: _dashboardCubit.airportState == Itinerary.TO
                                    ? textColor
                                    : textColor.withOpacity(0.3)),
                          ),
                          _dashboardCubit.translateTo.isNotEmpty == true
                              ? Column(
                                  children: _dashboardCubit.translateTo
                                      .map((language) => Text(
                                            language.name,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.deepOrangeAccent),
                                          ))
                                      .toList(),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            // )
          ),
        ),
        Divider(
          thickness: 1,
          color: textColor.withOpacity(0.2),
        ),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: LanguagePickerDialog(
              languages: RCCubit.instance
                  .getSupportedTranslationLanguages(context)
                  .keys
                  .map((lan) =>
                      Languages.defaultLanguages.firstWhere((language) => language.isoCode == lan))
                  .toList(),
              contentPadding: const EdgeInsets.all(0.0),
              titlePadding: const EdgeInsets.all(0.0),
              searchCursorColor: Colors.pinkAccent,
              onValuePicked: (Language language) => setState(() {
                if (_dashboardCubit.airportState == Itinerary.TO) {
                  if (!_dashboardCubit.translateFrom.contains(language) &&
                      !_dashboardCubit.translateTo.contains(language)) {
                    if (_dashboardCubit.translateTo.isEmpty) {
                      _dashboardCubit.closeWidgetShowed();
                      _dashboardCubit.translateTo.add(language);
                    }
                    // if (_dashboardCubit.translateTo.isEmpty) {
                    //   _dashboardCubit.translateTo.add(language);
                    // }
                  }
                }
                if (_dashboardCubit.airportState == Itinerary.FROM) {
                  if (!_dashboardCubit.translateFrom.contains(language) &&
                      !_dashboardCubit.translateTo.contains(language)) {
                    if (_dashboardCubit.translateFrom.isEmpty) {
                      _dashboardCubit.changeWidgetLanguage(widget: Itinerary.TO);
                      _dashboardCubit.translateFrom.add(language);
                    }
                    // if (_dashboardCubit.translateFrom.isEmpty) {
                    //   _dashboardCubit.translateFrom.add(language);
                    // }
                  }
                }
              }),
            ),
          ),
        )
      ],
    );
  }
}

showSelectLanguageBottomSheet(context) {
  showBottomSheet(
    context: context,
    backgroundColor: Colors.grey.shade100,
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
    builder: (context) => BlocProvider.value(
      value: BlocProvider.of<TranslatorDashboardCubit>(context),
      child: const SelectLanguage(),
    ),
  );
}
