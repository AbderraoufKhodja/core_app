import 'package:fibali/bloc/video_post_factory/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/video_post_factory/fill_video_post_listing_tab_one.dart';
import 'package:fibali/ui/pages/video_post_factory/fill_video_post_listing_tab_two.dart';
import 'package:fibali/ui/widgets/chewie_video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'dart:io';

class CreateVideoPostPage extends StatefulWidget {
  const CreateVideoPostPage({Key? key, required this.video}) : super(key: key);

  final File video;

  @override
  State<CreateVideoPostPage> createState() => _CreateVideoPostPageState();
}

class _CreateVideoPostPageState extends State<CreateVideoPostPage> {
  VideoPostFactoryBloc get _videoPostFactory => BlocProvider.of<VideoPostFactoryBloc>(context);

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    _videoPostFactory.post.videoUrl = widget.video;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _videoPostFactory.formKey,
      child: Scaffold(
        key: _key,
        floatingActionButton: const FloatingActionButton(
          onPressed: null,
          child: PopButton(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        bottomNavigationBar: BottomAppBar(
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: () {
                  _videoPostFactory
                      .handleCreateVideoPost(
                    context,
                    post: _videoPostFactory.post,
                    currentUser: _videoPostFactory.currentUser,
                  )
                      .then((value) {
                    setState(() {});
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Iconify(
                      Uil.image_upload,
                      size: 30,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      RCCubit.instance.getText(R.upload).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 0),
          children: [
            ChewieVideoWidget(video: widget.video),
            const Divider(),
            const FillVideoPostListingTabOne(),
            const FillVideoPostListingTabTwo(),
          ],
        ),
      ),
    );
  }
}
