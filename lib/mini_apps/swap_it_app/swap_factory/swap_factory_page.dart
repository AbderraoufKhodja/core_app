import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/swap_factory/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/create_swap_page.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_factory/update_swap_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SwapFactoryPage extends StatefulWidget {
  const SwapFactoryPage({super.key, required this.swapID, required this.images});

  final String? swapID;
  final List<XFile>? images;

  static Future<void> show({required AppUser currentUser, required String? itemID}) async {
    final result = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();

    if (result == false) {
      List<XFile>? imageFiles;
      if (itemID == null) {
        await SettingsCubit.handlePickMultiGalleryCamera(
          title: RCCubit().getText(R.chooseSource),
          maxNumWarning: RCCubit().getText(R.sixImagesMax),
          onImagesSelected: (images) {
            imageFiles = images;

            if (imageFiles?.isNotEmpty == true) {
              Get.to(() => BlocProvider(
                    create: (context) => SwapFactoryBloc(currentUser: currentUser),
                    child: SwapFactoryPage(swapID: itemID, images: imageFiles),
                  ));
            }
          },
        );
      } else {
        Get.to(() => BlocProvider(
              create: (context) => SwapFactoryBloc(currentUser: currentUser),
              child: SwapFactoryPage(swapID: itemID, images: imageFiles),
            ));
      }
    }
  }

  @override
  State<SwapFactoryPage> createState() => _SwapFactoryPageState();
}

class _SwapFactoryPageState extends State<SwapFactoryPage>
    with AutomaticKeepAliveClientMixin<SwapFactoryPage> {
  @override
  bool get wantKeepAlive => true;

  SwapFactoryBloc get _swapFactoryBloc => BlocProvider.of<SwapFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<SwapFactoryBloc, SwapFactoryState>(
      builder: (context, state) {
        if (state is SwapFactoryInitial) {
          _swapFactoryBloc.add(LoadSwap(itemID: widget.swapID, images: widget.images));
        }

        if (state is SwapFactoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ExistingSwap) return const UpdateSwapPage();

        if (state is NewSwap) return CreateSwapPage(images: state.images);

        return const SizedBox();
      },
    );
  }
}
