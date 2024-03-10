import 'dart:io';

import 'package:fibali/algeria_location.dart';
import 'package:fibali/bloc/item_factory/bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/ui/widgets/divider_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_dropdown_field.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

//TODO: check images picker missmatch images
class FillItemSourcePage extends StatefulWidget {
  const FillItemSourcePage({super.key});

  @override
  FillItemSourcePageState createState() => FillItemSourcePageState();
}

class FillItemSourcePageState extends State<FillItemSourcePage>
    with AutomaticKeepAliveClientMixin<FillItemSourcePage> {
  final _nameController = TextEditingController();
  final _otherInfoController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _linkController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _picker = ImagePicker();

  Map<String, dynamic> _source = {};
  List<String> _provinces = AlgeriaCities.getProvinces();
  List<String> _subProvinces = [];
  String? _province;
  String? _subProvince;

  @override
  bool get wantKeepAlive => true;

  Size get _size => MediaQuery.of(context).size;

  ItemFactoryBloc get _itemFactoryBloc => BlocProvider.of<ItemFactoryBloc>(context);

  @override
  void dispose() {
    _emailController.dispose();
    _phoneNumberController.dispose();
    _nameController.dispose();
    _linkController.dispose();
    _otherInfoController.dispose();
    _streetAddressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (_itemFactoryBloc.item.source != null) {
      _source = _itemFactoryBloc.item.source!;
    } else {
      _itemFactoryBloc.item.source = {};
    }
    _nameController.text = _itemFactoryBloc.item.source?['name'] ?? '';
    _emailController.text = _itemFactoryBloc.item.source?['email'] ?? '';
    _otherInfoController.text = _itemFactoryBloc.item.source?['otherInfo'] ?? '';
    _linkController.text = _itemFactoryBloc.item.source?['link'] ?? '';

    _getAddress();
    _getPhoneNumber();
    super.initState();
  }

  void _getAddress() {
    _province = _itemFactoryBloc.item.source?['province'] ?? null;
    _subProvinces = _itemFactoryBloc.item.source?['province'] != null
        ? AlgeriaCities.getSubProvinces(province: _itemFactoryBloc.item.source?['province'])
        : [];
    _subProvince = _itemFactoryBloc.item.source?['subProvince'] ?? null;
    _streetAddressController.text = _itemFactoryBloc.item.source?['streetAddress'] ?? '';
  }

  void _getPhoneNumber() {
    _phoneNumberController.text = _itemFactoryBloc.item.source?['phoneNumber'] != null
        ? _itemFactoryBloc.item.source!['phoneNumber']
            .replaceFirst(_itemFactoryBloc.item.source?['dialCode'], '')
        : '';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: widgets
            .map(
              (widget) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: widget,
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> get widgets => <Widget>[
        DividerTile(
          title: RCCubit.instance.getText(R.supplierInfo),
          subtitle: RCCubit.instance.getText(R.pleaseAddSupplierInfo),
        ),
        Card(
          elevation: 0,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                title: RCCubit.instance.getText(R.name),
                hint: RCCubit.instance.getText(R.nameHint),
                onChanged: (value) {
                  _itemFactoryBloc.item.source = _source
                    ..update(
                      'name',
                      (val) => value,
                      ifAbsent: () => value,
                    );
                },
              ),
              CustomTextField(
                controller: _emailController,
                title: RCCubit.instance.getText(R.email),
                hint: RCCubit.instance.getText(R.emailHint),
                onChanged: (value) {
                  _itemFactoryBloc.item.source = _source
                    ..update(
                      'email',
                      (val) => value,
                      ifAbsent: () => value,
                    );
                },
              ),
              CustomTextField(
                controller: _linkController,
                title: RCCubit.instance.getText(R.link),
                hint: RCCubit.instance.getText(R.linkHint),
                onChanged: (value) {
                  _itemFactoryBloc.item.source = _source
                    ..update(
                      'link',
                      (val) => value,
                      ifAbsent: () => value,
                    );
                },
              ),
            ],
          ),
        ),
        _buildAddImagesCard(),
        InternationalPhoneNumberInput(
          initialValue: PhoneNumber(
            phoneNumber: _itemFactoryBloc.item.source?['phoneNumber'],
            dialCode: _itemFactoryBloc.item.source?['dialCode'],
            isoCode: _itemFactoryBloc.item.source?['isoCode'],
          ),
          onInputChanged: (PhoneNumber value) {
            _itemFactoryBloc.item.source = _source
              ..update(
                'phoneNumber',
                (val) => value.phoneNumber,
                ifAbsent: () => value.phoneNumber,
              );

            _itemFactoryBloc.item.source = _source
              ..update(
                'dialCode',
                (val) => value.dialCode,
                ifAbsent: () => value.dialCode,
              );

            _itemFactoryBloc.item.source = _source
              ..update(
                'isoCode',
                (val) => value.isoCode,
                ifAbsent: () => value.isoCode,
              );
          },
          textFieldController: _phoneNumberController,
          formatInput: true,
          validator: (value) => null,
        ),
        Row(
          children: [
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
                        _itemFactoryBloc.item.source = _source
                          ..update(
                            'province',
                            (val) => value,
                            ifAbsent: () => value,
                          );
                        _itemFactoryBloc.item.source = _source..remove('subProvince');
                      },
                    );
                  }
                },
                validator: (value) => null,
              ),
            ),
            SizedBox(width: _size.width / 20),
            Flexible(
              child: CustomDropdownField(
                elements: _subProvinces,
                label: RCCubit.instance.getText(R.subProvince),
                value: _subProvince,
                onChanged: (value) {
                  if (value != null) {
                    _subProvince = value;
                    _itemFactoryBloc.item.source = _source
                      ..update(
                        'subProvince',
                        (val) => value,
                        ifAbsent: () => value,
                      );
                    setState(() {});
                  }
                },
                validator: (value) => null,
              ),
            ),
          ],
        ),
        CustomTextField(
          controller: _streetAddressController,
          title: RCCubit.instance.getText(R.streetAddress),
          hint: RCCubit.instance.getText(R.streetAddressHint),
          onChanged: (value) {
            _itemFactoryBloc.item.source = _source
              ..update(
                'streetAddress',
                (val) => value,
                ifAbsent: () => value,
              );
          },
        ),
        CustomTextField(
          controller: _otherInfoController,
          title: RCCubit.instance.getText(R.otherInfo),
          hint: RCCubit.instance.getText(R.otherInfoHint),
          onChanged: (value) {
            _itemFactoryBloc.item.source = _source
              ..update(
                'otherInfo',
                (val) => value,
                ifAbsent: () => value,
              );
          },
        ),
      ];

  Widget _buildAddImagesCard() {
    return TextField(
      cursorHeight: 0,
      onTap: () async {
        final imageFiles = await _picker.pickMultiImage();
        if (imageFiles != null) {
          if (imageFiles.length > 6) {
            Get.showSnackbar(
                GetSnackBar(messageText: Text(RCCubit.instance.getText(R.sixImagesMax))));
            _itemFactoryBloc.item.sourcePhotos = imageFiles.sublist(0, 6);
          } else {
            _itemFactoryBloc.item.sourcePhotos = imageFiles;
          }
          setState(() {});
        }
      },
      readOnly: true,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: RCCubit.instance.getText(R.addImages),
        suffixIcon: (_itemFactoryBloc.item.sourcePhotos is List<dynamic> &&
                _itemFactoryBloc.item.sourcePhotos?.isNotEmpty == true)
            ? GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: _size.width / 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                key: UniqueKey(),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final _dynamicPhoto = _itemFactoryBloc.item.sourcePhotos![index];

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _dynamicPhoto is XFile
                        ? PhotoWidget.file(file: File(_dynamicPhoto.path))
                        : PhotoWidget.network(photoUrl: _dynamicPhoto),
                  );
                },
                itemCount: _itemFactoryBloc.item.sourcePhotos!.length,
              )
            : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FaIcon(
                  FontAwesomeIcons.images,
                  color: Colors.grey.shade400,
                  size: _size.height / 8,
                ),
              ),
      ),
    );
  }
}
