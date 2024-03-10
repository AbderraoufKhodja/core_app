import 'package:fibali/bloc/item_factory/bloc.dart';
import 'package:fibali/ui/pages/item_factory_page/add_item_variants_page.dart';
import 'package:fibali/ui/pages/item_factory_page/fill_item_listing_tab_one.dart';
import 'package:fibali/ui/pages/item_factory_page/fill_item_listing_tab_two.dart';
import 'package:fibali/ui/pages/item_factory_page/fill_item_source_page.dart';
import 'package:fibali/ui/pages/item_factory_page/item_upload_photos_tab.dart';
import 'package:fibali/ui/pages/item_factory_page/return_policy_item_form_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:get/get.dart';

class AddNewItemPage extends StatefulWidget {
  const AddNewItemPage({super.key});

  @override
  State<AddNewItemPage> createState() => _AddNewItemPageState();
}

class _AddNewItemPageState extends State<AddNewItemPage> with TickerProviderStateMixin {
  ItemFactoryBloc get _itemFactory => BlocProvider.of<ItemFactoryBloc>(context);

  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 6)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        appBar: AppBar(
          elevation: 0.5,
          title: Text(RCCubit.instance.getText(R.createNewItem)),
          leading: const PopButton(),
          bottom: TabBar(
            controller: _controller,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            tabs: [
              Tab(
                child: FaIcon(FontAwesomeIcons.alignCenter,
                    size: 24, color: _itemFactory.isKeyValid1 == false ? Colors.red : null),
              ),
              Tab(
                child: FaIcon(FontAwesomeIcons.photoFilm,
                    size: 24, color: _itemFactory.isKeyValid2 == false ? Colors.red : null),
              ),
              Tab(
                child: FaIcon(FontAwesomeIcons.paintbrush,
                    size: 24, color: _itemFactory.isKeyValid3 == false ? Colors.red : null),
              ),
              Tab(
                child: FaIcon(FontAwesomeIcons.diagramProject,
                    size: 24, color: _itemFactory.isKeyValid4 == false ? Colors.red : null),
              ),
              Tab(
                child: FaIcon(FontAwesomeIcons.link,
                    size: 24, color: _itemFactory.isKeyValid5 == false ? Colors.red : null),
              ),
              Tab(
                child: FaIcon(FontAwesomeIcons.recycle,
                    size: 24, color: _itemFactory.isKeyValid6 == false ? Colors.red : null),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            Form(
              key: _itemFactory.formKey1,
              child: const FillItemListingTabOne(),
            ),
            Form(
              key: _itemFactory.formKey2,
              child: const AddItemPhotosTab(),
            ),
            Form(
              key: _itemFactory.formKey3,
              child: const AddItemVariantsPage(),
            ),
            Form(
              key: _itemFactory.formKey4,
              child: const FillItemListingTabTwo(),
            ),
            Form(
              key: _itemFactory.formKey5,
              child: const FillItemSourcePage(),
            ),
            FormBuilder(
              key: _itemFactory.formKey6,
              child: const ReturnPolicyItemFormTab(),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Get.theme.cardColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  style: _controller.index == _controller.length - 1
                      ? ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ))
                      : null,
                  onPressed: _controller.index == _controller.length - 1
                      ? () {
                          _itemFactory
                              .handleUploadNewItem(
                            context,
                            item: _itemFactory.item,
                            store: _itemFactory.store,
                          )
                              .then((value) {
                            setState(() {});
                          });
                        }
                      : () {
                          if (_controller.index < _controller.length) {
                            _controller.animateTo(_controller.index + 1);
                          }
                        },
                  child: _controller.index == _controller.length - 1
                      ? Text(RCCubit.instance.getText(R.createNewItem))
                      : const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
