import 'package:fibali/bloc/post_factory/bloc.dart';
import 'package:fibali/ui/pages/live_post_factory/fill_live_post_listing_tab_one.dart';
import 'package:fibali/ui/pages/live_post_factory/fill_live_post_listing_tab_two.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/module/multiple_image_selector.dart.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/uil.dart';

class UpdateLivePostPage extends StatefulWidget {
  const UpdateLivePostPage({Key? key}) : super(key: key);

  @override
  State<UpdateLivePostPage> createState() => _UpdateLivePostPageState();
}

class _UpdateLivePostPageState extends State<UpdateLivePostPage> {
  PostFactoryBloc get _postFactory => BlocProvider.of<PostFactoryBloc>(context);

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _postFactory.formKey,
      child: Scaffold(
        key: _key,
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          backgroundColor: Get.theme.highlightColor,
          child: const PopButton(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        bottomNavigationBar: BottomAppBar(
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: () {
                  _postFactory
                      .handleUpdatePost(
                    context,
                    post: _postFactory.postFromBloc,
                    currentUser: _postFactory.currentUser,
                  )
                      .then((value) {
                    setState(() {});
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Iconify(Uil.image_upload, size: 30, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text(
                      RCCubit.instance.getText(R.update).toUpperCase(),
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
            MultipleImageSelector(
              images: _postFactory.postFromBloc.photoUrls,
              onSave: (imageChanges) {
                _postFactory.postFromBloc.photoUrls = imageChanges;
              },
              heightRation: 1.5,
            ),
            const FillLivePostListingTabOne(),
            const FillLivePostListingTabTwo(),
          ],
        ),
      ),
    );
  }
}
