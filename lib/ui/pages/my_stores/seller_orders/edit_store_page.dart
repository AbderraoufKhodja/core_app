import 'dart:io';

import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';

class EditStorePage extends StatefulWidget {
  const EditStorePage({super.key, required this.store});
  final Store store;

  static Future<void> show({required Store store}) async {
    return Get.to(() => EditStorePage(store: store));
  }

  @override
  EditStorePageState createState() => EditStorePageState();
}

class EditStorePageState extends State<EditStorePage> {
  final _nameController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? _photoFile;
  bool _isFilled = false;
  final bool _isSubmitting = false;

  Size get _size => MediaQuery.of(context).size;
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.store.name ?? '';
    _nameController.addListener(() {
      setState(() {
        checkIsFilled();
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.editStore)),
        elevation: 0,
        centerTitle: true,
        leading: const PopButton(),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => widgets[index],
        separatorBuilder: (context, index) => const PaddedDivider(hight: 8.0),
        itemCount: widgets.length,
      ),
    );
  }

  List<Widget> get widgets => <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: GestureDetector(
                onTap: () async {
                  final imageFile = await picker.pickImage(
                    maxHeight: 512,
                    maxWidth: 512,
                    source: ImageSource.gallery,
                  );
                  if (imageFile != null) {
                    _photoFile = imageFile;
                    setState(() {
                      checkIsFilled();
                    });
                  }
                },
                child: Row(
                  children: [
                    _photoFile != null
                        ? PhotoWidget.file(
                            file: File(_photoFile!.path),
                            boxShape: BoxShape.circle,
                            height: _size.width * 0.25,
                            width: _size.width * 0.25,
                          )
                        : PhotoWidget.network(
                            photoUrl: widget.store.logo,
                            boxShape: BoxShape.circle,
                            height: _size.width * 0.25,
                            width: _size.width * 0.25,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
        buildListTile(
          title: RCCubit.instance.getText(R.name),
          trailing: widget.store.name ?? '',
        ),
        buildListTile(
          title: RCCubit.instance.getText(R.location),
          trailing: widget.store.country != null
              ? RCCubit.instance.getCloudText(context, widget.store.country!)
              : RCCubit.instance.getText(R.selectCountry),
          isEmpty: widget.store.country == null,
        ),
        buildListTile(
          title: RCCubit.instance.getText(R.description),
          trailing: widget.store.description ?? RCCubit.instance.getText(R.addDescription),
          isEmpty: widget.store.description == null,
        ),
        buildListTile(
          title: RCCubit.instance.getText(R.currency),
          trailing: widget.store.currency != null
              ? RCCubit.instance.getCloudText(context, widget.store.currency!)
              : RCCubit.instance.getText(R.selectCurrency),
          isEmpty: widget.store.currency == null,
        ),
      ];

  ListTile buildListTile({
    required String title,
    required String trailing,
    bool? isEmpty,
    Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      title: Text(title),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
                child: Text(
              trailing,
              style: isEmpty == true ? const TextStyle(color: Colors.grey) : null,
            )),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  bool checkIsFilled() {
    return _isFilled =
        (_nameController.text.isNotEmpty && _nameController.text != widget.store.name) ||
                _photoFile != null
            ? true
            : false;
  }

  get isButtonEnabled => _isFilled && !_isSubmitting;
}
