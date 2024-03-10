import 'dart:io';

import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/swap_factory/bloc.dart';
import 'package:fibali/ui/widgets/categories_dropdown.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

//TODO: check images picker missmatch images
class SwapInfoPage extends StatefulWidget {
  const SwapInfoPage({super.key});

  @override
  SwapInfoPageState createState() => SwapInfoPageState();
}

class SwapInfoPageState extends State<SwapInfoPage>
    with AutomaticKeepAliveClientMixin<SwapInfoPage> {
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _categoriesDropdown = const CategoriesDropdown();

  List<String> _keywords = [];

  @override
  bool get wantKeepAlive => true;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  SwapFactoryBloc get _swapFactoryBloc => BlocProvider.of<SwapFactoryBloc>(context);

  @override
  void dispose() {
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _descriptionController.text = _swapFactoryBloc.swapItem.description ?? '';
    _keywords = _swapFactoryBloc.swapItem.tags?.cast<String>() ?? [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: widgets
              .map(
                (widget) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: widget,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  List<Widget> get widgets => <Widget>[
        _swapFactoryBloc.swapItem.isActive == false
            ? ListTile(
                title: Text(RCCubit.instance.getText(R.restoreItem)),
                trailing: const FaIcon(FontAwesomeIcons.circleInfo),
                onTap: () {
                  _swapFactoryBloc.handleRestoreStoreSwap(
                    context,
                    itemID: _swapFactoryBloc.swapItem.itemID!,
                  );
                },
                tileColor: Colors.amberAccent,
              )
            : const SizedBox(),
        _buildAddImagesCard(),
        CustomTextField(
          controller: _descriptionController,
          hint: RCCubit.instance.getText(R.descriptionHint),
          title: RCCubit.instance.getText(R.description),
          onChanged: (value) => _swapFactoryBloc.swapItem.description = value,
          validator: (value) =>
              value?.isNotEmpty == true ? null : RCCubit.instance.getText(R.fillDescription),
        ),
        _categoriesDropdown,
        ListTile(
          title: Text(
            RCCubit.instance.getText(R.titleInfo),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: IconButton(
            icon: const FaIcon(FontAwesomeIcons.circleInfo),
            onPressed: () {},
          ),
          dense: true,
        ),
        Row(
          children: [
            Flexible(
              child: CustomTextField(
                controller: _tagsController,
                hint: RCCubit.instance.getText(R.keywordsHint),
                title: RCCubit.instance.getText(R.keywords),
                validator: (value) =>
                    _keywords.isNotEmpty ? null : RCCubit.instance.getText(R.addKeyword),
              ),
            ),
            IconButton(
              onPressed: () {
                if (_tagsController.text.isNotEmpty) {
                  setState(() {
                    _keywords.add(_tagsController.text);
                    _keywords = _keywords.toSet().toList();
                    _swapFactoryBloc.swapItem.tags = _keywords;
                    _tagsController.clear();
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
              .map(
                (label) => Chip(
                  label: Text(label),
                  onDeleted: () {
                    setState(() {
                      _keywords.remove(label);
                    });
                  },
                ),
              )
              .toList(),
        ),
      ];

  Widget _buildAddImagesCard() {
    return TextFormField(
      cursorHeight: 0,
      onTap: () {
        SettingsCubit.handlePickMultiGalleryCamera(
            maxNumWarning: RCCubit().getText(R.sixImagesMax),
            onImagesSelected: (images) {
              setState(() {
                _swapFactoryBloc.swapItem.photoUrls = images;
              });
            });
      },
      readOnly: true,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: RCCubit.instance.getText(R.addImages),
        suffixIcon: (_swapFactoryBloc.swapItem.photoUrls is List<dynamic> &&
                _swapFactoryBloc.swapItem.photoUrls?.isNotEmpty == true)
            ? GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: Get.width / 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                key: UniqueKey(),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final dynamicPhoto = _swapFactoryBloc.swapItem.photoUrls![index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: dynamicPhoto is XFile
                        ? kIsWeb
                            ? Image.network(
                                dynamicPhoto.path,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(dynamicPhoto.path),
                                fit: BoxFit.cover,
                              )
                        : PhotoWidgetNetwork(
                            label: null,
                            photoUrl: dynamicPhoto,
                          ),
                  );
                },
                itemCount: _swapFactoryBloc.swapItem.photoUrls!.length,
              )
            : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FaIcon(
                  FontAwesomeIcons.images,
                  color: Colors.grey.shade400,
                  size: Get.height / 8,
                ),
              ),
      ),
      validator: (value) => _swapFactoryBloc.swapItem.photoUrls?.isNotEmpty == true
          ? null
          : RCCubit.instance.getText(R.addOneImage),
    );
  }
}
