import 'dart:io';

import 'package:fibali/bloc/post_factory/bloc.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

class AddLivePostPhotosTab extends StatefulWidget {
  const AddLivePostPhotosTab({Key? key}) : super(key: key);

  @override
  AddLivePostPhotosTabState createState() => AddLivePostPhotosTabState();
}

class AddLivePostPhotosTabState extends State<AddLivePostPhotosTab>
    with AutomaticKeepAliveClientMixin<AddLivePostPhotosTab> {
  @override
  bool get wantKeepAlive => true;

  PostFactoryBloc get _postFactoryBloc => BlocProvider.of<PostFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildAddItemPhotosCard();
  }

  Widget _buildAddItemPhotosCard() {
    return FormField(
      builder: (field) => Positioned.fill(
        left: 0,
        right: 0,
        top: 0,
        bottom: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 33),
                  child: ListTile(
                    onTap: () {
                      SettingsCubit.handlePickMultiGalleryCamera(
                          maxNumWarning: RCCubit().getText(R.sixImagesMax),
                          onImagesSelected: (images) {
                            setState(() {
                              _postFactoryBloc.postFromBloc.photoUrls = images;
                            });
                          });
                    },
                    trailing: FaIcon(
                      FontAwesomeIcons.images,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
            if (_postFactoryBloc.postFromBloc.photoUrls is List<dynamic> &&
                _postFactoryBloc.postFromBloc.photoUrls?.isNotEmpty == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ReorderableWrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.end,
                    padding: const EdgeInsets.all(8),
                    children: _postFactoryBloc.postFromBloc.photoUrls!.asMap().entries.map(
                      (entry) {
                        final idx = entry.key;
                        final val = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _postFactoryBloc.currentImageIdx = idx;
                              _postFactoryBloc.pageController.jumpToPage(idx);
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: _postFactoryBloc.currentImageIdx == idx ? Colors.white : null,
                              padding: const EdgeInsets.all(2.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: val is XFile
                                    ? kIsWeb
                                        ? PhotoWidgetNetwork(
                                            label: null,
                                            photoUrl: val.path,
                                            fit: BoxFit.cover,
                                            height: (Get.width - 60) / 6,
                                            width: (Get.width - 60) / 6,
                                          )
                                        : PhotoWidget.file(
                                            file: File(val.path),
                                            fit: BoxFit.cover,
                                            height: (Get.width - 60) / 6,
                                            width: (Get.width - 60) / 6,
                                          )
                                    : PhotoWidgetNetwork(
                                        label: null,
                                        photoUrl: val,
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        final temp = _postFactoryBloc.postFromBloc.photoUrls!.removeAt(oldIndex);
                        _postFactoryBloc.postFromBloc.photoUrls!.insert(newIndex, temp);
                      });
                    },
                    onNoReorder: (int index) {},
                    onReorderStarted: (int index) {},
                  ),
                ],
              ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  field.errorText ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      validator: (value) => _postFactoryBloc.postFromBloc.photoUrls?.isNotEmpty == true
          ? null
          : RCCubit.instance.getText(R.addOneImage),
    );
  }
}
