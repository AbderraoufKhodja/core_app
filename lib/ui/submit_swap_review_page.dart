import 'dart:io';

import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SubmitSwapReviewPage extends StatefulWidget {
  final dynamic Function(
    num rating,
    String? ratingText,
    List<XFile>? photoFiles,
  ) onSubmitted;
  const SubmitSwapReviewPage({super.key, required this.onSubmitted});

  static showPage({
    required dynamic Function(num rating, String? ratingText, List<XFile>? photoFiles) onSubmitted,
  }) {
    return Get.to(() => SubmitSwapReviewPage(onSubmitted: onSubmitted));
  }

  @override
  SubmitSwapReviewPageState createState() => SubmitSwapReviewPageState();
}

class SubmitSwapReviewPageState extends State<SubmitSwapReviewPage> {
  final _commentController = TextEditingController();
  final _picker = ImagePicker();

  num _rating = 3;
  List<XFile>? photoFiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                SettingsCubit.handlePickMultiGalleryCamera(
                  maxNumWarning: RCCubit().getText(R.sixImagesMax),
                  onImagesSelected: (images) {
                    setState(() {
                      photoFiles = images;
                    });
                  },
                );
              },
              child: (photoFiles is List<dynamic> && photoFiles?.isNotEmpty == true)
                  ? GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: Get.height / 8,
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
                          size: Get.height / 8,
                        ),
                      ],
                    ),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _rating = rating;
              },
            ),
            CustomTextField(
              controller: _commentController,
              hint: RCCubit.instance.getText(R.commentInfoHint),
              title: RCCubit.instance.getText(R.commentInfo),
            ),
          ],
        ),
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
