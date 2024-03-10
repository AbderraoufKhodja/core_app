import 'dart:io';

import 'package:fibali/bloc/store_factory/store_factory_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/ui/pages/register_store/store_tags_list_generator.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class FillStoreInfoTab extends StatefulWidget {
  const FillStoreInfoTab({super.key});

  @override
  FillStoreInfoTabState createState() => FillStoreInfoTabState();
}

class FillStoreInfoTabState extends State<FillStoreInfoTab>
    with AutomaticKeepAliveClientMixin<FillStoreInfoTab> {
  @override
  bool get wantKeepAlive => true;

  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _nameController = TextEditingController();
  final _picker = ImagePicker();

  Size get _size => MediaQuery.of(context).size;

  StoreFactoryBloc get _storeFactory => BlocProvider.of<StoreFactoryBloc>(context);

  @override
  void dispose() {
    _descriptionController.dispose();
    _tagsController.dispose();
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _storeFactory.formKey1,
      child: Scaffold(
        body: ListView(children: widgets),
      ),
    );
  }

  List<Widget> get widgets => <Widget>[
        ListTile(
          title: Text(RCCubit.instance.getText(R.fillStoreInfoDescription)),
        ),
        Card(
          child: Column(
            children: [
              _buildAddLogoImageCard(),
              if (_storeFactory.logoFile is XFile)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PhotoWidget.file(
                      file: File(_storeFactory.logoFile!.path),
                      boxShape: BoxShape.circle,
                      height: _size.height / 6,
                      width: _size.height / 6,
                    ),
                  ],
                ),
              const PaddedDivider(hight: 8),
              _buildAddBackgroundImageCard(),
              if (_storeFactory.backgroundFile is XFile)
                PhotoWidget.file(
                  file: File(_storeFactory.backgroundFile!.path),
                  boxShape: BoxShape.rectangle,
                  height: _size.height / 4,
                  width: _size.width,
                  fit: BoxFit.fill,
                ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                title: RCCubit.instance.getText(R.storeName),
                hint: RCCubit.instance.getText(R.storeNameHint),
                onChanged: (value) {
                  _storeFactory.storeName = value;
                },
                validator: (value) => _nameValidator(value),
              ),
              const PaddedDivider(hight: 8),
              CustomTextField(
                controller: _descriptionController,
                onChanged: (value) {
                  _storeFactory.description = value;
                },
                title: RCCubit.instance.getText(R.description),
                hint: RCCubit.instance.getText(R.descriptionHint),
                validator: (value) => _descriptionValidator(value),
              ),
              const PaddedDivider(hight: 8),
              StoreTagsListCreator(
                controller: _tagsController,
                hint: RCCubit.instance.getText(R.tagsHint),
                title: RCCubit.instance.getText(R.tag),
                onAdd: () {
                  if (_tagsController.text.isNotEmpty) {
                    final theseTags = _tagsController.text.toLowerCase().split(' ').toList();
                    _storeFactory.keywords.addAll(theseTags);
                    _storeFactory.keywords = _storeFactory.keywords.toSet().toList();
                    _storeFactory.keywords.remove('');
                    _tagsController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ];

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please add your legal name';
    }
    return null;
  }

  String? _descriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return RCCubit.instance.getText(R.pleaseAddDescription);
    }
    return null;
  }

  Widget _buildAddLogoImageCard() {
    return TextFormField(
      initialValue: RCCubit.instance.getText(R.addLogo),
      cursorHeight: 0,
      onTap: () async {
        final imageFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 512,
          maxWidth: 512,
        );
        if (imageFile != null) {
          _storeFactory.logoFile = imageFile;
          setState(() {});
        }
      },
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        isDense: true,
        suffixIcon: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
      ),
      validator: (value) =>
          _storeFactory.logoFile is XFile ? null : RCCubit.instance.getText(R.pleaseAddLogo),
    );
  }

  Widget _buildAddBackgroundImageCard() {
    return TextFormField(
      initialValue: RCCubit.instance.getText(R.addBackgroundImage),
      cursorHeight: 0,
      onTap: () async {
        final imageFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 512,
          maxWidth: 512,
        );
        if (imageFile != null) {
          _storeFactory.backgroundFile = imageFile;
          setState(() {});
        }
      },
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        isDense: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        suffixIcon: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
      ),
      validator: (value) => _storeFactory.backgroundFile is XFile
          ? null
          : RCCubit.instance.getText(R.pleaseAddBackground),
    );
  }
}
