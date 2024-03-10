import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/space.dart';

class PhoneSelection extends StatefulWidget {
  const PhoneSelection({super.key});

  @override
  State<PhoneSelection> createState() => _PhoneSelectionState();
}

class _PhoneSelectionState extends State<PhoneSelection> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Space.Y(10),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Add Phone Number',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: TextButton(
                  onPressed: () {
                    _dashboardCubit.closeWidgetShowed();
                  },
                  child: const Text('SAVE'),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.blueGrey.withOpacity(0.2),
          ),
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
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

  String _phoneNumberWithoutDialCode() {
    if (_dashboardCubit.dialCode != null) {
      return _dashboardCubit.phoneNumber?.split(_dashboardCubit.dialCode!)[1] ?? '';
    }
    return '';
  }

  List<Widget> get widgets => <Widget>[
        InternationalPhoneNumberInput(
          initialValue: _phoneNumber,
          countries: const ['DZ', 'CN'],
          onInputChanged: (PhoneNumber value) {
            _dashboardCubit.phoneNumber = value.phoneNumber;
            _dashboardCubit.isoCode = value.isoCode;
            _dashboardCubit.dialCode = value.dialCode;
            _dashboardCubit.updateUI();
          },
          validator: (value) =>
              _dashboardCubit.phoneNumber == null ? RCCubit.instance.getText(R.checkPhone) : null,
          textFieldController: _phoneNumberController,
          formatInput: true,
          inputDecoration:
              const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16.0)),
        ),
      ];
}

showSelectPhoneBottomSheet(context) {
  showBottomSheet(
    context: context,
    backgroundColor: Colors.grey.shade100,
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
    builder: (context) => BlocProvider.value(
      value: BlocProvider.of<TranslatorDashboardCubit>(context),
      child: const PhoneSelection(),
    ),
  );
}
