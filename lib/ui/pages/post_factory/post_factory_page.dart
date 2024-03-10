import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/post_factory/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/ui/pages/post_factory/create_post_page.dart';
import 'package:fibali/ui/pages/post_factory/update_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostFactoryPage extends StatefulWidget {
  const PostFactoryPage({super.key, required this.postID, required this.imageFiles});

  final String? postID;
  final List<XFile>? imageFiles;

  @override
  State<PostFactoryPage> createState() => _PostFactoryPageState();
}

class _PostFactoryPageState extends State<PostFactoryPage>
    with AutomaticKeepAliveClientMixin<PostFactoryPage> {
  @override
  bool get wantKeepAlive => true;

  PostFactoryBloc get _postFactoryBloc => BlocProvider.of<PostFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PostFactoryBloc, PostFactoryState>(
      builder: (context, state) {
        if (state is PostFactoryInitial) {
          _postFactoryBloc.add(LoadPost(postID: widget.postID, images: widget.imageFiles));
        }

        if (state is LivePostFactoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ExistingLivePost) return const UpdatePostPage();

        if (state is NewLivePost) return CreatePostPage(images: state.images);

        return const SizedBox();
      },
    );
  }
}

Future<void> showPostFactoryPage({
  required AppUser currentUser,
  required String? postID,
}) async {
  final needLogIn = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
  if (needLogIn) {
    return;
  }

  List<XFile>? imageFiles;
  if (postID == null) {
    await SettingsCubit.handlePickMultiGalleryCamera(
      title: RCCubit().getText(R.chooseSource),
      maxNumWarning: RCCubit().getText(R.sixImagesMax),
      onImagesSelected: (images) {
        imageFiles = images;
        if (imageFiles?.isNotEmpty == true) {
          Get.to(
            () => BlocProvider(
              create: (context) => PostFactoryBloc(currentUser: currentUser),
              child: PostFactoryPage(postID: postID, imageFiles: imageFiles),
            ),
          );
        }
      },
    );
  } else {
    Get.to(
      () => BlocProvider(
        create: (context) => PostFactoryBloc(currentUser: currentUser),
        child: PostFactoryPage(postID: postID, imageFiles: imageFiles),
      ),
    );
  }
}
