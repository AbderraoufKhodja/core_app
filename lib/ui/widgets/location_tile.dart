import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';

class LocationTile extends StatefulWidget {
  const LocationTile({super.key});

  @override
  State<LocationTile> createState() => _LocationTileState();
}

class _LocationTileState extends State<LocationTile> {
  @override
  Widget build(BuildContext context) {
    final settingsCubit = BlocProvider.of<SettingsCubit>(context);
    return ListTile(
      title: FutureBuilder<List<Placemark>?>(
        future: settingsCubit.getAddress(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Text(RCCubit.instance.getText(R.selectLocation));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white70,
              child: const Text('...'),
            );
          }

          if (snapshot.hasData) {
            final placeMarks = snapshot.data!;

            if (placeMarks.isNotEmpty == true) {
              return Text(placeMarks[0].toString());
            }
          }
          return Text(RCCubit.instance.getText(R.selectLocation));
        },
      ),
    );
  }

  Text buildLocationText(List<Placemark> placeMarks) {
    return Text(
      checkAddressField(str: placeMarks[0].street) +
          checkAddressField(str: placeMarks[0].subLocality) +
          checkAddressField(str: placeMarks[0].locality) +
          checkAddressField(str: placeMarks[0].subAdministrativeArea) +
          checkAddressField(str: placeMarks[0].administrativeArea) +
          checkAddressField(str: placeMarks[0].country, isLast: true),
    );
  }

  String checkAddressField({String? str, bool isLast = false}) => str != null
      ? str.isNotEmpty
          ? isLast
              ? str
              : "$str, "
          : ""
      : "";
}
