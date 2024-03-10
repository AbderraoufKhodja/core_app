import 'dart:io';

import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/post/post_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/uim.dart';
import 'package:image_picker/image_picker.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({
    super.key,
    required this.post,
    this.fillColor,
  });

  final Color? fillColor;
  final Post post;

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _textController = TextEditingController();

  List<XFile>? imageFiles;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  PostBloc get _postBloc => BlocProvider.of<PostBloc>(context);

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (imageFiles?.isNotEmpty == true)
          SizedBox(
            height: kBottomNavigationBarHeight * 1.5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 8),
                    children: imageFiles!.map(
                      (image) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: kIsWeb
                                ? PhotoWidgetNetwork(
                                    label: null,
                                    photoUrl: image.path,
                                    fit: BoxFit.fitWidth,
                                    height: 50,
                                    width: 50,
                                  )
                                : PhotoWidget.file(
                                    file: File(image.path),
                                    fit: BoxFit.fitWidth,
                                    height: 50,
                                    width: 50,
                                  ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      imageFiles = null;
                    });
                  },
                  child: Text(RCCubit.instance.getText(R.cancel)),
                ),
              ],
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                autofocus: false,
                maxLength: 500,
                decoration: InputDecoration(
                  counterStyle: const TextStyle(
                    height: double.minPositive,
                  ),
                  fillColor: widget.fillColor,
                  counterText: "",
                  suffixIcon: IconButton(
                    onPressed: () {
                      SettingsCubit.handlePickMultiGalleryCamera(
                          maxNumWarning: RCCubit().getText(R.sixImagesMax),
                          onImagesSelected: (images) {
                            setState(() {
                              imageFiles = images;
                            });
                          });
                    },
                    icon: const Iconify(
                      Uim.image_v,
                      color: Colors.black54,
                      size: 30,
                    ),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  labelText: RCCubit.instance.getText(R.addComment),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                keyboardType: TextInputType.text,
                onSubmitted: (commentText) {
                  if (commentText.trim().isNotEmpty) {
                    _postBloc.handleAddComment(
                      context,
                      currentUser: _currentUser!,
                      post: widget.post,
                      photos: imageFiles,
                      commentText: commentText.trim(),
                    );
                    _textController.clear();
                  }

                  if (imageFiles != null) {
                    setState(() {
                      imageFiles = null;
                    });
                  }
                },
                maxLines: 4,
                minLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
