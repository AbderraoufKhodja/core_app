import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/ui/widgets/location_tile.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/app_settings.dart';
import 'package:fibali/fibali_core/ui/pages/google_map_page.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  AppSettingsPageState createState() => AppSettingsPageState();
}

class AppSettingsPageState extends State<AppSettingsPage> {
  late AppSettings previousSettings;

  SettingsCubit get _settingsCubit => BlocProvider.of<SettingsCubit>(context);

  AppUser? get currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  void initState() {
    super.initState();
    previousSettings = _settingsCubit.state;
  }

  @override
  Widget build(BuildContext context) {
    AppSettings currentSettings = previousSettings;
    return WillPopScope(
      onWillPop: () async {
        // if (previousSettings != currentSettings) {
        //   BlocProvider.of<SwapSearchBloc>(context).add(
        //     LoadItems(user: currentUser, filter: Filter.empty()),
        //   );
        // }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(RCCubit.instance.getText(R.searchSettings),
              style: GoogleFonts.fredokaOne(color: Colors.grey)),
          leading: const PopButton(),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<SettingsCubit, AppSettings>(
                builder: (_, state) {
                  currentSettings = state;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            RCCubit.instance.getText(R.distance),
                          ),
                          Text(
                            '${state.distance.toInt()}km',
                          ),
                        ],
                      ),
                      Card(
                        elevation: 0,
                        child: SizedBox(
                          child: Column(
                            children: [
                              Slider(
                                min: 1,
                                max: 200,
                                activeColor: Theme.of(context).primaryColor,
                                inactiveColor: Theme.of(context).colorScheme.secondaryContainer,
                                value: state.distance,
                                onChanged: (value) {
                                  _settingsCubit.updateRadius(distance: value);
                                  currentSettings = state;
                                },
                              ),
                              SwitchListTile(
                                title: Text(RCCubit.instance.getText(R.strictSearchMode)),
                                value: _settingsCubit.state.isStrictSearchMode,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (bool result) =>
                                    _settingsCubit.setStrictSearchMode(result),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Text(RCCubit.instance.getText(R.location)),
              Card(
                elevation: 0,
                child: BlocBuilder<SettingsCubit, AppSettings>(
                  buildWhen: (previous, current) =>
                      current.latitude != previous.latitude ||
                      current.longitude != previous.longitude,
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () async {
                        final location = await showGoogleMaps();

                        if (location?.containsKey('geopoint') == true) {
                          final geopoint = location!['geopoint'] as GeoPoint;

                          _settingsCubit.updateLocation(
                            latitude: geopoint.latitude,
                            longitude: geopoint.longitude,
                          );
                        }
                      },
                      child: const LocationTile(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showAppSettingsPage(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AppSettingsPage()),
  );
}
