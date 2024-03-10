import 'package:badges/badges.dart';
import 'package:fibali/bloc/business/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class BusinessLocationWidget extends StatefulWidget {
  const BusinessLocationWidget({super.key});

  @override
  State<BusinessLocationWidget> createState() => _BusinessLocationWidgetState();
}

class _BusinessLocationWidgetState extends State<BusinessLocationWidget> {
  BusinessCubit get _searchCubit => BlocProvider.of<BusinessCubit>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessCubit, BusinessState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: InternationalPhoneNumberInput(
            initialValue: PhoneNumber(isoCode: _searchCubit.countryCode ?? 'US'),
            onInputChanged: (PhoneNumber phoneNumber) {
              if (phoneNumber.isoCode != null) {
                _searchCubit.countryCode = phoneNumber.isoCode;
                _searchCubit.refreshSearchRef();
              }
            },
            searchBoxDecoration: InputDecoration(
                fillColor: Colors.grey.shade200,
                hintText: RCCubit.instance.getText(R.search),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                )),
            hasField: false,
            leadingWidget: _searchCubit.countryCode != null
                ? Badge(
                    position: BadgePosition.bottomEnd(end: -10),
                    badgeContent: Text(
                      _searchCubit.countryCode!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                          letterSpacing: 0),
                    ),
                    badgeStyle: const BadgeStyle(
                      padding: EdgeInsets.all(0),
                      elevation: 0,
                      badgeColor: Colors.transparent,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.black,
                      size: 30,
                    ),
                  )
                : Badge(
                    position: BadgePosition.bottomEnd(end: -18),
                    badgeContent: Text(
                      RCCubit.instance.getText(R.select),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    badgeStyle: const BadgeStyle(
                      padding: EdgeInsets.all(0),
                      elevation: 0,
                      badgeColor: Colors.transparent,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.DIALOG,
            ),
          ),
        );
      },
    );
  }

  Text buildLocationText(List<Placemark> placeMarks) {
    return Text(
      checkAddressField(str: placeMarks[0].administrativeArea) +
          checkAddressField(str: placeMarks[0].country, isLast: true),
      style: const TextStyle(color: Colors.white70),
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
