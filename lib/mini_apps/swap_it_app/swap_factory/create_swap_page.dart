import 'package:fibali/mini_apps/swap_it_app/bloc/swap_factory/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/fill_swap_listing_tab_one.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/fill_swap_listing_tab_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/module/multiple_image_selector.dart.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';

class CreateSwapPage extends StatefulWidget {
  const CreateSwapPage({Key? key, required this.images}) : super(key: key);

  final List<XFile> images;

  @override
  State<CreateSwapPage> createState() => _CreateSwapPageState();
}

class _CreateSwapPageState extends State<CreateSwapPage> {
  SwapFactoryBloc get _swapFactory => BlocProvider.of<SwapFactoryBloc>(context);

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    _swapFactory.swapItem.photoUrls = widget.images;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _swapFactory.formKey,
      child: Scaffold(
        key: _key,
        floatingActionButton: const FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.white70,
          child: PopButton(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        bottomNavigationBar: BottomAppBar(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    onPressed: () {
                      _swapFactory
                          .handleCreateSwapItem(
                        context,
                        swap: _swapFactory.swapItem,
                        currentUser: _swapFactory.currentUser,
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
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 0),
          children: [
            MultipleImageSelector(
              images: _swapFactory.swapItem.photoUrls,
              onSave: (imageChanges) {
                _swapFactory.swapItem.photoUrls = imageChanges;
              },
              heightRation: 1.5,
            ),
            const FillSwapListingTabOne(),
            const FillSwapListingTabTwo(),
          ],
        ),
      ),
    );
  }
}
