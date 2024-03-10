import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:fibali/fibali_core/algeria_location.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_dropdown_field.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/fibali_core/ui/widgets/space.dart';

class LocationSelection extends StatefulWidget {
  const LocationSelection({super.key});

  @override
  State<LocationSelection> createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  final _streetAddressController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  PhoneNumber? _phoneNumber;

  TranslatorDashboardCubit get _dashboardCubit =>
      BlocProvider.of<TranslatorDashboardCubit>(context);
  @override
  void initState() {
    if (_dashboardCubit.dialCode != null) {
      _phoneNumber = PhoneNumber(
        dialCode: _dashboardCubit.dialCode,
        isoCode: _dashboardCubit.isoCode,
        phoneNumber: _dashboardCubit.phoneNumber,
      );
      _phoneNumberController.text = _phoneNumberWithoutDialCode();
    }
    super.initState();
  }

  String _phoneNumberWithoutDialCode() {
    if (_dashboardCubit.dialCode != null) {
      return _dashboardCubit.phoneNumber?.split(_dashboardCubit.dialCode!)[1] ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Space.Y(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Space.X(20),
              const Text(
                'Select Location',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey),
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
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: widgets
                .map(
                  (widget) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> get widgets => <Widget>[
        InternationalPhoneNumberInput(
          initialValue: _phoneNumber,
          countries: const ['DZ'],
          onInputChanged: (PhoneNumber value) {
            _dashboardCubit.phoneNumber = value.phoneNumber;
            _dashboardCubit.isoCode = value.isoCode;
            _dashboardCubit.dialCode = value.dialCode;
          },
          validator: (value) =>
              _dashboardCubit.phoneNumber == null ? RCCubit.instance.getText(R.checkPhone) : null,
          textFieldController: _phoneNumberController,
          formatInput: true,
          inputDecoration:
              const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
        ),
        Row(
          children: [
            Flexible(
              child: CustomDropdownField(
                elements: _dashboardCubit.provinces,
                label: RCCubit.instance.getText(R.province),
                value: _dashboardCubit.province,
                onChanged: (value) {
                  if (value != null) {
                    setState(
                      () {
                        _dashboardCubit.subProvince = null;
                        _dashboardCubit.subProvinces = [];
                        _dashboardCubit.subSubProvince = null;
                        _dashboardCubit.subSubProvinces = [];
                        _dashboardCubit.subProvinces =
                            AlgeriaCities.getSubProvinces(province: value);
                        _dashboardCubit.province = value;
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: CustomDropdownField(
                  elements: _dashboardCubit.subProvinces,
                  label: RCCubit.instance.getText(R.subProvince),
                  value: _dashboardCubit.subProvince,
                  onChanged: (value) {
                    if (value != null) {
                      _dashboardCubit.subSubProvince = null;
                      _dashboardCubit.subSubProvinces = [];
                      _dashboardCubit.subSubProvinces = AlgeriaCities.getSubSubProvinces(
                        subProvince: value,
                        province: _dashboardCubit.province!,
                      );

                      _dashboardCubit.subProvince = value;
                      setState(() {});
                    }
                  }),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: CustomDropdownField(
                  elements: _dashboardCubit.subSubProvinces,
                  label: RCCubit.instance.getText(R.subSubProvince),
                  value: _dashboardCubit.subSubProvince,
                  onChanged: (value) {
                    if (value != null) {
                      _dashboardCubit.subSubProvince = value;
                      setState(() {});
                    }
                  }),
            ),
          ],
        ),
        CustomTextField(
          controller: _streetAddressController,
          maxLines: 3,
          hint: RCCubit.instance.getText(R.streetAddressHint),
          title: RCCubit.instance.getText(R.streetAddress),
          onChanged: (value) {
            _dashboardCubit.streetAddress = value;
          },
          validator: (value) => _addressValidator(value),
        ),
      ];

  String? _addressValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please add the legal address of your store';
    }
    return null;
  }
}

showSelectLocationBottomSheet(context) {
  showBottomSheet(
    context: context,
    backgroundColor: Colors.grey.shade100,
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
    builder: (context) => BlocProvider.value(
      value: BlocProvider.of<TranslatorDashboardCubit>(context),
      child: const LocationSelection(),
    ),
  );
}
