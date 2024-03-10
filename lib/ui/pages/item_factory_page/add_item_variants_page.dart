import 'dart:io';

import 'package:fibali/bloc/item_factory/bloc.dart';
import 'package:fibali/ui/widgets/divider_tile.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

class AddItemVariantsPage extends StatefulWidget {
  const AddItemVariantsPage({super.key});

  @override
  State<AddItemVariantsPage> createState() => _AddItemVariantsPageState();
}

class _AddItemVariantsPageState extends State<AddItemVariantsPage>
    with AutomaticKeepAliveClientMixin<AddItemVariantsPage> {
  @override
  bool get wantKeepAlive => true;

  final _attributesController = TextEditingController();
  Map<String, List<dynamic>> _attributes = {};
  List<List<dynamic>> _variants = [];
  final _picker = ImagePicker();

  Size get _size => MediaQuery.of(context).size;
  ItemFactoryBloc get _itemFactoryBloc => BlocProvider.of<ItemFactoryBloc>(context);

  @override
  void initState() {
    if (_itemFactoryBloc.item.attributes is Map<String, dynamic>) {
      _attributes = _itemFactoryBloc.item.attributes!.cast<String, List<dynamic>>();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final widgets = [
      Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 18,
          top: 8.0,
        ),
        child: Text(
          RCCubit.instance.getText(R.pleaseAddOption),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      Card(
        elevation: 0,
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: CustomTextField(
                    controller: _attributesController,
                    title: RCCubit.instance.getText(R.options),
                    hint: RCCubit.instance.getText(R.optionsHint),
                    description: RCCubit.instance.getText(R.pleaseAddOption),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_attributesController.text.isNotEmpty) {
                      setState(() {
                        if (!_attributes.containsKey(_attributesController.text)) {
                          if (_attributes.length < 9) {
                            _attributes[_attributesController.text] = [];
                            _updateItemAttributes();
                            _attributesController.clear();
                          } else {
                            Get.showSnackbar(
                                GetSnackBar(message: RCCubit.instance.getText(R.nineMax)));
                          }
                        } else {
                          Get.showSnackbar(
                              GetSnackBar(message: RCCubit.instance.getText(R.existAlready)));
                        }
                      });
                    }
                  },
                  child: Text(RCCubit.instance.getText(R.add)),
                ),
              ],
            ),
          ],
        ),
      ),
      Card(
        child: Column(
          children: _attributes.keys.map((key) {
            final valuesController = TextEditingController();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DividerTile(
                  title: RCCubit.instance.getText(R.subOptions),
                  subtitle: RCCubit.instance.getText(R.pleaseAddSubOptions),
                ),
                Row(
                  children: [
                    Flexible(
                      child: CustomTextField(
                        controller: valuesController,
                        title: key,
                        hint: '',
                        validator: (value) => _attributes[key]!.isNotEmpty
                            ? null
                            : RCCubit.instance.getText(R.addValue) + key,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (valuesController.text.isNotEmpty) {
                          setState(
                            () {
                              if (!_attributes[key]!
                                  .any((value) => value == valuesController.text)) {
                                _attributes[key]!.add(valuesController.text);
                                _updateItemAttributes();
                                valuesController.clear();
                              } else {
                                Get.showSnackbar(
                                    GetSnackBar(message: RCCubit.instance.getText(R.existAlready)));
                              }
                            },
                          );
                        }
                      },
                      child: const Icon(Icons.add_circle),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _attributes.remove(key);
                          _updateItemAttributes();
                        });
                      },
                      icon: const Icon(Icons.delete),
                    )
                  ],
                ),
                Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.start,
                  children: _attributes[key]!
                      .map((value) => Chip(
                            label: Text(value),
                            onDeleted: () {
                              setState(() {
                                _attributes[key]!.remove(value);
                                _updateItemAttributes();
                              });
                            },
                          ))
                      .toList(),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      _buildAttributesVariants()
    ];
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: widgets,
      ),
    );
  }

  void _updateItemAttributes() => _itemFactoryBloc.item.attributes = _attributes;

  Widget _buildAttributesVariants() {
    final attributesValues = _attributes.values.where((value) => value.isNotEmpty).toList();
    _variants = [];
    if (attributesValues.length == 1) {
      _variants =
          attributesValues[0].cartesian([""]).map((tuple) => tuple.toList()..remove("")).toList();
    }

    if (attributesValues.length == 2) {
      _variants = attributesValues[0]
          .cartesian(attributesValues[1])
          .map((tuple) => tuple.toList()..remove(""))
          .toList();
    }

    if (attributesValues.length == 3) {
      _variants = attributesValues[0]
          .cartesian3(attributesValues[1], attributesValues[2])
          .map((tuple) => tuple.toList()..remove(""))
          .toList();
    }

    if (attributesValues.length == 4) {
      _variants = attributesValues[0]
          .cartesian4(
            attributesValues[1],
            attributesValues[2],
            attributesValues[3],
          )
          .map((tuple) => tuple.toList()..remove(""))
          .toList();
    }

    if (attributesValues.length == 5) {
      _variants = attributesValues[0]
          .cartesian5(
            attributesValues[1],
            attributesValues[2],
            attributesValues[3],
            attributesValues[4],
          )
          .map((tuple) => tuple.toList()..remove(""))
          .toList();
    }

    if (attributesValues.length == 6) {
      _variants = attributesValues[0]
          .cartesian6(
            attributesValues[1],
            attributesValues[2],
            attributesValues[3],
            attributesValues[4],
            attributesValues[5],
          )
          .map((tuple) => tuple.toList()..remove(""))
          .toList();
    }

    if (attributesValues.length == 7) {
      _variants = attributesValues[0]
          .cartesian7(
            attributesValues[1],
            attributesValues[2],
            attributesValues[3],
            attributesValues[4],
            attributesValues[5],
            attributesValues[6],
          )
          .map((tuple) => tuple.toList()..remove(""))
          .toList();
    }

    if (attributesValues.length == 8) {
      _variants = attributesValues[0]
          .cartesian8(
            attributesValues[1],
            attributesValues[2],
            attributesValues[3],
            attributesValues[4],
            attributesValues[5],
            attributesValues[6],
            attributesValues[7],
          )
          .map((tuple) => tuple.toList()..remove(""))
          .toList();
    }

    if (attributesValues.length == 9) {
      _variants = attributesValues[0]
          .cartesian9(
            attributesValues[1],
            attributesValues[2],
            attributesValues[3],
            attributesValues[4],
            attributesValues[5],
            attributesValues[6],
            attributesValues[7],
            attributesValues[8],
          )
          .map((tuple) => tuple.toList()..remove(""))
          .toList();
    }

    if (_variants.isEmpty) return const SizedBox();

    if (_itemFactoryBloc.item.variants == null) {
      _itemFactoryBloc.item.variants = {};
    } else {
      _itemFactoryBloc.item.variants
          ?.removeWhere((key, value) => !_variants.any((variant) => variant.toString() == key));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _variants.map((variant) {
        final variantWidgets =
            variant.map((variantValue) => Chip(label: Text(variantValue.toString()))).toList();
        final priceController = TextEditingController();
        priceController.text =
            (_itemFactoryBloc.item.variants?[variant.toString()]?['price'] ?? '').toString();
        final stockCountController = TextEditingController();
        stockCountController.text =
            (_itemFactoryBloc.item.variants?[variant.toString()]?['count'] ?? '').toString();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: _size.height / 18,
                child: ListView.separated(
                  itemBuilder: (context, index) => variantWidgets[index],
                  separatorBuilder: (context, index) => const SizedBox(width: 0.8),
                  itemCount: variantWidgets.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final imageFile = await _picker.pickImage(
                        maxHeight: 512,
                        maxWidth: 512,
                        source: ImageSource.gallery,
                      );
                      if (imageFile != null) {
                        setState(
                          () {
                            _updateVariants(
                              label: 'photo',
                              key: variant.toString(),
                              value: imageFile,
                            );
                          },
                        );
                      }
                    },
                    child: _itemFactoryBloc.item.variants?[variant.toString()]?['photo'] is XFile
                        ? PhotoWidget.file(
                            file: File(
                                _itemFactoryBloc.item.variants![variant.toString()]!['photo'].path),
                            fit: BoxFit.cover,
                            height: _size.height / 12,
                            width: _size.height / 12,
                          )
                        : _itemFactoryBloc.item.variants?[variant.toString()]?['photo'] is String
                            ? PhotoWidget.network(
                                photoUrl:
                                    _itemFactoryBloc.item.variants![variant.toString()]!['photo'],
                                height: _size.height / 12,
                                width: _size.height / 12,
                              )
                            : FaIcon(
                                FontAwesomeIcons.images,
                                color: Colors.grey.shade400,
                              ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      controller: priceController,
                      onChanged: (price) => _updateVariants(
                        label: 'price',
                        key: variant.toString(),
                        value: num.parse(price),
                      ),
                      title: RCCubit.instance.getText(R.price),
                      hint: RCCubit.instance.getText(R.priceHint),
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      controller: stockCountController,
                      onChanged: (count) => _updateVariants(
                        label: RCCubit.instance.getText(R.count),
                        key: variant.toString(),
                        value: num.parse(count),
                      ),
                      title: RCCubit.instance.getText(R.count),
                      hint: RCCubit.instance.getText(R.countHint),
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                    ),
                  )
                ],
              ),
              const Divider(),
            ],
          ),
        );
      }).toList(),
    );
  }

  _updateVariants({
    required String label,
    required String key,
    required dynamic value,
  }) {
    _itemFactoryBloc.item.variants!.update(
      key.toString(),
      (val) {
        val[label] = value;
        return val;
      },
      ifAbsent: () => {label: value},
    );
  }
}
