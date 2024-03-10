import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/delivery_address/delivery_address_cubit.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/delivery_address.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/pages/google_map_page.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/locations.dart';
import 'package:fibali/ui/widgets/custom_dropdown_field.dart';
import 'package:fibali/ui/widgets/log_in_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AddDeliveryAddressPage extends StatefulWidget {
  const AddDeliveryAddressPage({super.key});

  @override
  AddDeliveryAddressPageState createState() => AddDeliveryAddressPageState();
}

class AddDeliveryAddressPageState extends State<AddDeliveryAddressPage> {
  final _nameController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;
  PhoneNumber? _phoneNumber;
  final List<String> _provinces = provinceLatinNameList;
  List<String> _subProvinces = [];
  String? _province;
  String? _subProvince;
  GeoPoint? _geopoint;
  String? _country;

  DeliveryAddressCubit get _delAddCubit => BlocProvider.of<DeliveryAddressCubit>(context);
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  void initState() {
    super.initState();
    _nameController.text = _currentUser!.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) return const LogInWidget();
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.addDeliveryAddress)),
        leading: const PopButton(),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: _addDeliveryAddress,
          child: Text(RCCubit.instance.getText(R.saveNDefault)),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, index) => Card(
            elevation: 0,
            child: fieldWidgets[index],
          ),
          itemCount: fieldWidgets.length,
        ),
      ),
    );
  }

  List<Widget> get fieldWidgets => <Widget>[
        Column(
          children: [
            CustomTextField(
              controller: _nameController,
              title: RCCubit.instance.getText(R.name),
              hint: RCCubit.instance.getText(R.nameHint),
              validator: (value) =>
                  value?.isNotEmpty == true ? null : RCCubit.instance.getText(R.pleaseFillName),
            ),
            const Divider(),
            InternationalPhoneNumberInput(
              countries: const ['DZ'],
              onInputChanged: (PhoneNumber value) {
                _phoneNumber = value;
              },
              validator: (value) =>
                  (value?.length ?? 0) > 5 ? null : RCCubit.instance.getText(R.addPhoneNumber),
            ),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: CustomDropdownField(
                    elements: _provinces,
                    label: 'Province',
                    value: _province,
                    onChanged: (value) {
                      if (value != null) {
                        setState(
                          () {
                            _subProvince = null;
                            _subProvinces = [];
                            _subProvinces =
                                communeLatinNameList[provinceLatinNameList.indexOf(value)];
                            _province = value;
                          },
                        );
                      }
                    },
                  ),
                ),
                Flexible(
                  child: CustomDropdownField(
                    elements: _subProvinces,
                    label: 'Sub province',
                    value: _subProvince,
                    onChanged: (value) {
                      if (value != null) _subProvince = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            const Divider(),
            CustomTextField(
              controller: _streetAddressController,
              hint: RCCubit.instance.getText(R.streetAddressHint),
              title: RCCubit.instance.getText(R.streetAddress),
              validator: (value) =>
                  value?.isNotEmpty == true ? null : RCCubit.instance.getText(R.addStreetAddress),
            ),
            const Divider(),
            Column(
              children: [
                ListTile(
                  title: Text(_country ?? RCCubit.instance.getText(R.country)),
                  subtitle: _geopoint != null
                      ? Text(
                          'Lat:${_geopoint!.latitude.toStringAsFixed(2)} | Long:${_geopoint!.longitude.toStringAsFixed(2)}')
                      : Text(RCCubit.instance.getText(R.geoLocation)),
                  trailing: IconButton(
                      onPressed: () async {
                        final location = await showGoogleMaps();
                        if (location?['geopoint'] is GeoPoint && location?['country'] is String) {
                          _geopoint = location?['geopoint'];
                          _country = location?['country'];
                          setState(() {});
                        }
                      },
                      icon: const FaIcon(FontAwesomeIcons.locationDot)),
                ),
                TextFormField(
                    readOnly: true,
                    cursorHeight: 0,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(0),
                    ),
                    validator: (value) {
                      if (_geopoint is GeoPoint) {
                        if (_country == CountriesIso.DZ.name) {
                        } else {
                          return RCCubit.instance.getText(R.onlyAlgeria);
                        }
                      } else {
                        return RCCubit.instance.getText(R.addMapLocation);
                      }
                      return null;
                    }),
              ],
            ),
          ],
        ),
      ];

  _addDeliveryAddress() {
    if (_formKey.currentState!.validate()) {
      if (!_isSubmitting) {
        _isSubmitting = true;
        EasyLoading.show(status: RCCubit.instance.getText(R.updatingAddress), dismissOnTap: true);
        final address = DeliveryAddress(
          country: _country,
          id: null,
          name: _nameController.text,
          phoneNumber: _phoneNumber!.phoneNumber,
          dialCode: _phoneNumber!.dialCode,
          isoCode: _phoneNumber!.isoCode,
          province: _province,
          subProvince: _subProvince,
          subSubProvince: null,
          streetAddress: _streetAddressController.text,
          //TODO implement geopoint widget field
          geopoint: _geopoint,
        );
        _delAddCubit.addDeliveryAddress(address: address).then((value) {
          _isSubmitting = false;
          EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
          Future.delayed(const Duration(seconds: 2)).then((value) => Get.back());
        }).onError((error, stackTrace) {
          _isSubmitting = false;
          EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
        });
      }
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
    }
  }
}
