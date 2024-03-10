import 'dart:io';

import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class PackageSendingPage extends StatefulWidget {
  final dynamic Function(
    num rating,
    String? ratingText,
    List<XFile>? photoFiles,
  ) onSubmitted;

  const PackageSendingPage({super.key, required this.onSubmitted});

  @override
  _PackageSendingPageState createState() => _PackageSendingPageState();
}

class _PackageSendingPageState extends State<PackageSendingPage> {
  final _commentController = TextEditingController();
  final num _rating = 3;

  Size get _size => MediaQuery.of(context).size;

  List<XFile>? photoFiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              SettingsCubit.handlePickMultiGalleryCamera(
                  maxNumWarning: RCCubit().getText(R.sixImagesMax),
                  onImagesSelected: (images) {
                    setState(() {
                      photoFiles = images;
                    });
                  });
            },
            child: (photoFiles is List<dynamic> && photoFiles?.isNotEmpty == true)
                ? GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: _size.height / 8,
                      childAspectRatio: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    key: UniqueKey(),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final dynamicPhoto = photoFiles![index];
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: PhotoWidget.file(
                            file: File(dynamicPhoto.path),
                            fit: BoxFit.cover,
                          ));
                    },
                    itemCount: photoFiles!.length,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(RCCubit.instance.getText(R.addImages)),
                      FaIcon(
                        FontAwesomeIcons.images,
                        color: Colors.grey.shade200,
                        size: _size.height / 8,
                      ),
                    ],
                  ),
          ),
          TextField(
            controller: _commentController,
            maxLines: 7,
            decoration: InputDecoration(hintText: RCCubit.instance.getText(R.additionalInfo)),
          ),
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        child: Text(RCCubit.instance.getText(R.submit)),
        onPressed: () => widget.onSubmitted(
          _rating,
          _commentController.text.isNotEmpty ? _commentController.text : null,
          photoFiles,
        ),
      ),
    );
  }
}

showPackageSendingPage(
  context, {
  required dynamic Function(num rating, String? ratingText, List<XFile>? photoFiles) onSubmitted,
}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PackageSendingPage(onSubmitted: onSubmitted),
    ),
  );
}
