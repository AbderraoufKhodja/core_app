import 'dart:io';

import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/video_post_factory/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/ui/pages/video_post_factory/create_video_post_page.dart';
import 'package:fibali/ui/pages/video_post_factory/update_video_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class VideoPostFactoryPage extends StatefulWidget {
  const VideoPostFactoryPage({super.key, required this.postID, required this.videoFile});

  final String? postID;
  final File? videoFile;

  static Future<void> show({required AppUser currentUser, required String? postID}) async {
    final needLogIn = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
    if (needLogIn) {
      return;
    }

    if (postID == null) {
      await SettingsCubit.handlePickMedia(
        title: RCCubit().getText(R.chooseSource),
        maxNumWarning: RCCubit().getText(R.sixImagesMax),
        onFilesSelected: (file) {
          if (file is File) {
            Get.to(
              () => BlocProvider(
                create: (context) => VideoPostFactoryBloc(currentUser: currentUser),
                child: VideoPostFactoryPage(postID: postID, videoFile: file),
              ),
            );
          }
        },
      );
    } else {
      Get.to(
        () => BlocProvider(
          create: (context) => VideoPostFactoryBloc(currentUser: currentUser),
          child: VideoPostFactoryPage(postID: postID, videoFile: null),
        ),
      );
    }
  }

  @override
  State<VideoPostFactoryPage> createState() => _VideoPostFactoryPageState();
}

class _VideoPostFactoryPageState extends State<VideoPostFactoryPage>
    with AutomaticKeepAliveClientMixin<VideoPostFactoryPage> {
  @override
  bool get wantKeepAlive => true;

  VideoPostFactoryBloc get _videoPostFactoryBloc => BlocProvider.of<VideoPostFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<VideoPostFactoryBloc, VideoPostFactoryState>(
      builder: (context, state) {
        if (state is PostFactoryInitial) {
          _videoPostFactoryBloc.add(LoadPost(postID: widget.postID, video: widget.videoFile));
        }

        if (state is PostFactoryLoading) {
          return const LoadingGrid();
        }

        if (state is ExistingPost) return const UpdateVideoPostPage();

        if (state is NewPost) return CreateVideoPostPage(video: state.file);

        return const SizedBox();
      },
    );
  }
}
