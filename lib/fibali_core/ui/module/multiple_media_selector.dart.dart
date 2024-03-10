import 'dart:io';

import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/module/edit_upload_media_page.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MultipleMediaSelector extends StatefulWidget {
  const MultipleMediaSelector({
    Key? key,
    required this.images,
    required this.video,
    required this.onSave,
    this.heightRation = 1.5,
  }) : super(key: key);

  final void Function(List<dynamic>? images, dynamic video) onSave;
  final List<dynamic>? images;
  final dynamic video;
  final double heightRation;

  @override
  State<MultipleMediaSelector> createState() => _MultipleMediaSelectorState();
}

class _MultipleMediaSelectorState extends State<MultipleMediaSelector> {
  late MediaSelectorCubit _mediaSelectorCubit;

  @override
  void initState() {
    _mediaSelectorCubit = MediaSelectorCubit(widget.images, widget.video);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _mediaSelectorCubit,
      child: Builder(
        builder: (context) {
          return DefaultTabController(
            length: _mediaSelectorCubit.images?.length ?? 0,
            child: Stack(
              children: [
                SizedBox(
                  width: Get.width,
                  height: Get.height / widget.heightRation,
                  child: TabBarView(
                    children: _mediaSelectorCubit.images?.map((dynamicImage) {
                          if (dynamicImage is XFile) {
                            return PhotoWidget.file(
                              file: File(dynamicImage.path),
                              fit: BoxFit.cover,
                              height: (Get.width - 60) / 6,
                              width: (Get.width - 60) / 6,
                            );
                          } else if (dynamicImage is String) {
                            return PhotoWidget.network(
                              photoUrl: dynamicImage,
                              photoUrl100x100: null,
                              photoUrl250x375: null,
                              photoUrl500x500: null,
                              fit: BoxFit.cover,
                              width: Get.width,
                              height: Get.height / 2,
                            );
                          }
                          return const SizedBox();
                        }).toList() ??
                        [],
                  ),
                ),
                FormField(
                  builder: (field) => Positioned.fill(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(),
                        _buildMediasTabBar(),
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
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
                  validator: (value) => _mediaSelectorCubit.images?.isNotEmpty == true
                      ? null
                      : RCCubit.instance.getText(R.addOneImage),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Container _buildMediasTabBar() {
    return Container(
      color: Colors.black26,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_mediaSelectorCubit.images is List<dynamic> &&
              _mediaSelectorCubit.images?.isNotEmpty == true)
            Expanded(
              child: TabBar(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.transparent,
                  isScrollable: true,
                  padding: const EdgeInsets.only(right: 8.0),
                  labelPadding: const EdgeInsets.only(
                    right: 4.0,
                    left: 4.0,
                    bottom: 2.0,
                    top: 4.0,
                  ),
                  indicator:
                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
                  tabs: _mediaSelectorCubit.images!.asMap().entries.map(
                    (entry) {
                      final idx = entry.key;
                      final val = entry.value;
                      return Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: val is XFile
                              ? PhotoWidget.file(
                                  file: File(val.path),
                                  fit: BoxFit.cover,
                                  height: (Get.width - 60) / 6,
                                  width: (Get.width - 60) / 6,
                                )
                              : PhotoWidget.network(
                                  photoUrl: val,
                                  photoUrl100x100: null,
                                  photoUrl250x375: null,
                                  photoUrl500x500: null,
                                  fit: BoxFit.cover,
                                  height: (Get.width - 60) / 6,
                                  width: (Get.width - 60) / 6,
                                ),
                        ),
                      );
                    },
                  ).toList()),
            )
          else
            const Spacer(),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(0.0),
            onPressed: () {
              Get.to(
                () => BlocProvider.value(
                  value: _mediaSelectorCubit,
                  child: EditUploadMediaPage(onSave: widget.onSave),
                ),
              )?.then((value) {
                setState(() {});
              });
            },
            icon: Icon(
              FluentIcons.image_edit_24_filled,
              color: Colors.white70,
              size: (Get.width - 60) / 8,
            ),
          ),
        ],
      ),
    );
  }
}

class MediaSelectorCubit extends Cubit<List<dynamic>?> {
  MediaSelectorCubit(this.images, this.video) : super(null);
  List<dynamic>? images;
  dynamic video;
}
