import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/delivery_address/delivery_address_cubit.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/delivery_address.dart';
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

class EditDeliveryAddressPage extends StatefulWidget {
  final DeliveryAddress address;

  const EditDeliveryAddressPage({super.key, required this.address});

  @override
  EditDeliveryAddressPageState createState() => EditDeliveryAddressPageState();
}

class EditDeliveryAddressPageState extends State<EditDeliveryAddressPage> {
  final _nameController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
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
    _nameController.text = widget.address.name!;
    _province = widget.address.province;
    _subProvinces = communeLatinNameList[provinceLatinNameList.indexOf(_province!)];
    _subProvince = widget.address.subProvince;
    _streetAddressController.text = widget.address.streetAddress!;
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.editProfile)),
        leading: PopButton(onPressed: () {
          _delAddCubit.showDisplayPage();
          Navigator.pop(context);
        }),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: _addDeliveryAddress,
        child: Text(RCCubit.instance.getText(R.updateAddress)),
      ),
      body: Form(
        key: _formKey,
        child: ListView.separated(
          itemBuilder: (context, index) => fieldWidgets[index],
          itemCount: fieldWidgets.length,
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }

  List<Widget> get fieldWidgets => <Widget>[
        CustomTextField(
          controller: _nameController,
          title: RCCubit.instance.getText(R.name),
          hint: RCCubit.instance.getText(R.nameHint),
          validator: (value) =>
              value?.isNotEmpty == true ? null : RCCubit.instance.getText(R.pleaseFillName),
        ),
        InternationalPhoneNumberInput(
          countries: const ['DZ'],
          initialValue: PhoneNumber(
            phoneNumber: widget.address.phoneNumber!,
            dialCode: widget.address.dialCode!,
            isoCode: widget.address.isoCode!,
          ),
          textFieldController: _phoneNumberController,
          onInputChanged: (PhoneNumber value) {
            _phoneNumber = value;
          },
          validator: (value) =>
              (value?.length ?? 0) > 5 ? null : RCCubit.instance.getText(R.addPhoneNumber),
        ),
        Column(
          children: [
            ListTile(
              title: Text(_country ?? RCCubit.instance.getText(R.country)),
              subtitle: _geopoint != null
                  ? Text(
                      'Lat:${_geopoint!.latitude.toStringAsFixed(2)} | Long:${_geopoint!.longitude.toStringAsFixed(2)}')
                  : Text(RCCubit.instance.getText(R.geoLocation)),
              trailing: const FaIcon(FontAwesomeIcons.locationDot),
              onTap: () async {
                final location = await showGoogleMaps(
                  initGeoPoint: widget.address.geopoint,
                );
                if (location?['geopoint'] is GeoPoint && location?['country'] is String) {
                  _geopoint = location?['geopoint'];
                  _country = location?['country'];
                  setState(() {});
                }
              },
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
                    if (_country == 'Algeria') {
                      return null;
                    } else {
                      return RCCubit.instance.getText(R.onlyAlgeria);
                    }
                  } else {
                    return RCCubit.instance.getText(R.addMapLocation);
                  }
                }),
          ],
        ),
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
                        _subProvinces = communeLatinNameList[provinceLatinNameList.indexOf(value)];
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
        CustomTextField(
          controller: _streetAddressController,
          hint: RCCubit.instance.getText(R.streetAddressHint),
          title: RCCubit.instance.getText(R.streetAddress),
          validator: (value) =>
              value?.isNotEmpty == true ? null : RCCubit.instance.getText(R.addStreetAddress),
        ),
      ];

  _addDeliveryAddress() {
    //TODO: implement geopoint widget field
    if (_formKey.currentState!.validate()) {
      if (!_isSubmitting) {
        _isSubmitting = true;
        EasyLoading.dismiss(animation: true);
        EasyLoading.show(status: RCCubit.instance.getText(R.updatingAddress), dismissOnTap: true);
        final address = DeliveryAddress(
          id: widget.address.id,
          name: _nameController.text,
          phoneNumber: _phoneNumber!.phoneNumber,
          dialCode: _phoneNumber!.dialCode,
          isoCode: _phoneNumber!.isoCode,
          country: _country,
          province: _province,
          subProvince: _subProvince,
          subSubProvince: null,
          streetAddress: _streetAddressController.text,
          geopoint: _geopoint,
        );
        _delAddCubit.updateDeliveryAddress(address: address).then((value) {
          _isSubmitting = false;
          EasyLoading.dismiss(animation: true);
          EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
          Future.delayed(const Duration(seconds: 2)).then((value) => Get.back());
        }).onError((error, stackTrace) {
          _isSubmitting = false;
          EasyLoading.dismiss(animation: true);
          EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
        });
      }
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
    }
  }
}
