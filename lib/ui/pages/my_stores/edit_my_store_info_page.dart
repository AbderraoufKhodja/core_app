import 'dart:io';

import 'package:fibali/algeria_location.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/store_factory/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_dropdown_field.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditMyStoreInfoPage extends StatefulWidget {
  final Store store;
  final void Function() onSubmitted;

  static Future<dynamic>? show({
    required Store store,
    required void Function() onSubmitted,
  }) {
    return Get.to(
      () => BlocProvider(
        create: (context) => StoreFactoryBloc(),
        child: EditMyStoreInfoPage(store: store, onSubmitted: onSubmitted),
      ),
    );
  }

  const EditMyStoreInfoPage({Key? key, required this.store, required this.onSubmitted})
      : super(key: key);
  @override
  EditMyStoreInfoPageState createState() => EditMyStoreInfoPageState();
}

class EditMyStoreInfoPageState extends State<EditMyStoreInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _keywordsController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _authorFirstNameController = TextEditingController();
  final _authorLastNameController = TextEditingController();

  final _streetAddressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _picker = ImagePicker();

  XFile? _logoFile;
  XFile? _backgroundFile;
  List<String> _keywords = [];
  final _countries = CountriesIso.values.map((country) => country.name).toList();
  final List<String> _currencies = ['DZD', 'EUR'];
  String? _currency;
  String? _country;
  final _provinces = AlgeriaCities.getProvinces();
  List<String> _subProvinces = [];
  String? _province;
  String? _subProvince;
  String? _subSubProvince;
  String? _phoneNumber;
  String? _dialCode;

  Size get _size => MediaQuery.of(context).size;
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  StoreFactoryBloc get _userStoresBloc => BlocProvider.of<StoreFactoryBloc>(context);
  @override
  void initState() {
    _descriptionController.text = widget.store.description!;
    _keywords = widget.store.keywords?.map((keyword) => keyword.toString()).toList() ?? [];
    _storeNameController.text = widget.store.name!;
    _authorFirstNameController.text = widget.store.name!;
    _authorLastNameController.text = widget.store.name!;

    _streetAddressController.text = widget.store.streetAddress!;
    _phoneNumberController.text =
        widget.store.phoneNumber!.replaceFirst(widget.store.dialCode!, '');
    _country = widget.store.country;
    _province = widget.store.province;
    if (widget.store.subProvince != null) {
      _subProvinces = AlgeriaCities.getSubProvinces(province: widget.store.province!);
    }
    _currency = widget.store.currency;
    _subProvince = widget.store.subProvince;
    _phoneNumber = widget.store.phoneNumber;
    _dialCode = widget.store.dialCode;

    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _keywordsController.dispose();
    _storeNameController.dispose();
    _authorFirstNameController.dispose();
    _authorLastNameController.dispose();
    _streetAddressController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.editStore)),
        leading: const PopButton(),
      ),
      body: Form(
        key: _formKey,
        child: ListView.separated(
          itemCount: widgets.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (BuildContext context, int index) => widgets[index],
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _onSubmitted,
                child: Text(RCCubit.instance.getText(R.updateInfo)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get widgets => <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final imageFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                  maxHeight: 512,
                  maxWidth: 512,
                );
                if (imageFile != null) {
                  setState(() {
                    _logoFile = imageFile;
                  });
                }
              },
              child: _logoFile != null
                  ? PhotoWidget.file(
                      file: File(_logoFile!.path),
                      width: _size.width * 0.4,
                      height: _size.width * 0.4,
                      boxShape: BoxShape.circle,
                    )
                  : PhotoWidget.network(
                      photoUrl: widget.store.logo,
                      width: _size.width * 0.4,
                      height: _size.width * 0.4,
                      boxShape: BoxShape.circle,
                    ),
            ),
          ],
        ),
        CustomTextField(
          controller: _storeNameController,
          title: RCCubit.instance.getText(R.storeName),
          hint: RCCubit.instance.getText(R.storeNameHint),
          validator: (value) => _nameValidator(value),
        ),
        CustomTextField(
          controller: _authorFirstNameController,
          title: RCCubit.instance.getText(R.firstName),
          hint: RCCubit.instance.getText(R.firstNameHint),
          validator: (value) => _nameValidator(value),
        ),
        CustomTextField(
          controller: _authorLastNameController,
          title: RCCubit.instance.getText(R.lastName),
          hint: RCCubit.instance.getText(R.lastNameHint),
          validator: (value) => _nameValidator(value),
        ),
        CustomTextField(
          controller: _descriptionController,
          title: RCCubit.instance.getText(R.description),
          hint: RCCubit.instance.getText(R.descriptionHint),
          validator: (value) => _descriptionValidator(value),
        ),
        GestureDetector(
          onTap: () async {
            final imageFile = await _picker.pickImage(
              source: ImageSource.gallery,
              maxHeight: 512,
              maxWidth: 512,
            );
            if (imageFile != null) {
              setState(() {
                _backgroundFile = imageFile;
              });
            }
          },
          child: _backgroundFile != null
              ? PhotoWidget.file(
                  file: File(_backgroundFile!.path),
                  height: _size.width * 0.4,
                  width: _size.width * 0.95,
                  fit: BoxFit.cover,
                )
              : PhotoWidget.network(
                  height: _size.width * 0.4,
                  width: _size.width * 0.95,
                  photoUrl: widget.store.background,
                ),
        ),
        Row(
          children: [
            Flexible(
              child: CustomTextField(
                controller: _keywordsController,
                title: RCCubit.instance.getText(R.keywords),
                hint: RCCubit.instance.getText(R.keywordsHint),
              ),
            ),
            IconButton(
              onPressed: () {
                if (_keywordsController.text.isNotEmpty) {
                  setState(() {
                    _keywords.add(_keywordsController.text);
                    _keywords = _keywords.toSet().toList();
                    _keywordsController.clear();
                  });
                }
              },
              icon: const Icon(Icons.add_circle),
            )
          ],
        ),
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.start,
          children: _keywords
              .map((label) => Chip(
                    label: Text(label),
                    onDeleted: () {
                      setState(() {
                        _keywords.remove(label);
                      });
                    },
                  ))
              .toList(),
        ),
        InternationalPhoneNumberInput(
          countries: [CountriesIso.DZ.name],
          initialValue: PhoneNumber(
            phoneNumber: widget.store.phoneNumber,
            dialCode: widget.store.dialCode,
          ),
          onInputChanged: (PhoneNumber value) {
            _phoneNumber = value.phoneNumber;
            _dialCode = value.dialCode;
          },
          validator: (value) =>
              _phoneNumber == null ? RCCubit.instance.getText(R.checkPhone) : null,
          textFieldController: _phoneNumberController,
          formatInput: true,
        ),
        if (_currency != null)
          CustomDropdownField(
              elements: _currencies,
              value: _currency,
              label: RCCubit.instance.getText(R.currency),
              onChanged: (value) {
                if (value != null) _currency = value;
              }),
        if (_country != null)
          CustomDropdownField(
              elements: [CountriesIso.DZ.name],
              label: RCCubit.instance.getText(R.country),
              value: _country,
              onChanged: (value) {
                if (value != null) {
                  setState(
                    () {
                      _country = value;
                    },
                  );
                }
              }),
        if (_provinces.isNotEmpty || _subProvinces.isNotEmpty)
          Row(
            children: [
              if (_provinces.isNotEmpty)
                Flexible(
                  child: CustomDropdownField(
                    elements: _provinces,
                    label: RCCubit.instance.getText(R.province),
                    value: _province,
                    onChanged: (value) {
                      if (value != null) {
                        setState(
                          () {
                            _subProvince = null;
                            _subProvinces = [];
                            _subProvinces =
                                _subProvinces = AlgeriaCities.getSubProvinces(province: value);
                            _province = value;
                          },
                        );
                      }
                    },
                  ),
                ),
              const SizedBox(width: 8),
              if (_subProvinces.isNotEmpty)
                Flexible(
                  child: CustomDropdownField(
                    elements: _subProvinces,
                    label: RCCubit.instance.getText(R.subProvince),
                    value: _subProvince,
                    onChanged: (value) {
                      if (value != null) _subProvince = value;
                      setState(() {});
                    },
                  ),
                ),
            ],
          ),
        // CustomTextField(
        //   controller: _streetAddressController,
        //   title: RCCubit.instance.getText(R.streetAddress),
        //   hint: RCCubit.instance.getText(R.streetAddressHint),
        //   validator: (value) => _nameValidator(value),
        // ),
      ];

  Future<void> _onSubmitted() async {
    if (_currentUser != null && _formKey.currentState!.validate()) {
      await _userStoresBloc.handleUpdateStore(
        context,
        previousStore: widget.store,
        storeOwnerID: _currentUser!.uid,
        description: _descriptionController.text,
        storeName: _storeNameController.text,
        authorFirstName: _authorFirstNameController.text,
        authorLastName: _authorLastNameController.text,
        phoneNumber: _phoneNumber!,
        dialCode: _dialCode!,
        logoFile: _logoFile,
        backgroundFile: _backgroundFile,
        currency: _currency!,
        country: _country!,
        province: _province!,
        subProvince: _subProvince!,
        subSubProvince: _subSubProvince,
        keywords: _keywords.isNotEmpty ? _keywords : null,
        streetAddress: _streetAddressController.text,
      );
      widget.onSubmitted();
    }
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please choose a field';
    }
    return null;
  }

  String? _descriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please choose a field';
    }
    return null;
  }
}
