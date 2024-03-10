import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/check_order_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CheckOrderPage extends StatefulWidget {
  const CheckOrderPage({
    super.key,
    required Item item,
  }) : _item = item;

  final Item _item;

  static show({required Item item}) => Get.to(() => CheckOrderPage(item: item));

  @override
  State<CheckOrderPage> createState() => _CheckOrderPageState();
}

class _CheckOrderPageState extends State<CheckOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _attributes = <String, dynamic>{};

  int _orderQuantity = 1;
  num _variantPrice = 0;
  String _variantDescription = '';

  Item get _item => widget._item;

  late String _variantPhoto;

  List<Widget> get _widgets => [
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget._item.photoUrls?.isNotEmpty == true)
                  PhotoWidget.network(
                    photoUrl: widget._item.photoUrls![0],
                    loadingHeight: 150,
                    loadingWidth: 150,
                    height: 150,
                    width: 150,
                    fit: BoxFit.fitHeight,
                    boxShape: BoxShape.rectangle,
                  ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    children: [
                      if (widget._item.title?.isNotEmpty == true)
                        Text(
                          widget._item.title!,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      const Divider(),
                      if (widget._item.description?.isNotEmpty == true)
                        Text(
                          widget._item.description!,
                          maxLines: 5,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        _item.attributes != null
            ? Column(
                children: _item.attributes!.entries.map((element) {
                dynamic selectedValue;
                return DropdownButtonFormField<dynamic>(
                  value: selectedValue,
                  hint: Text(RCCubit.instance.getCloudText(context, element.key)),
                  isExpanded: true,
                  decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      hintStyle: TextStyle(color: Colors.black)),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                      _attributes[element.key] = value;
                      _updateInfo();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "can't be empty";
                    } else {
                      return null;
                    }
                  },
                  items: (element.value as List<dynamic>)
                      .toSet()
                      .map((val) => DropdownMenuItem(
                            value: val,
                            child: Text(val),
                          ))
                      .toList(),
                );
              }).toList())
            : const SizedBox(),
      ];

  @override
  void initState() {
    _updateInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.checkOrder)),
        leading: const PopButton(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(RCCubit.instance.getText(R.total),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  )),
                          Text(
                            '${_variantPrice * _orderQuantity} ${_item.currency ?? ''}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrangeAccent,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('${RCCubit.instance.getText(R.quantity)}: ',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  )),
                          Text(
                            _orderQuantity.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ActionChip(
                        label: const FaIcon(
                          FontAwesomeIcons.minus,
                          size: 10,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_orderQuantity <= 1) {
                              _orderQuantity = 1;
                            } else {
                              _orderQuantity -= 1;
                            }
                          });
                        },
                      ),
                      ActionChip(
                        label: const FaIcon(
                          FontAwesomeIcons.plus,
                          size: 10,
                        ),
                        onPressed: () {
                          setState(() {
                            _orderQuantity += 1;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showCheckOrderPage(context,
                            item: _item,
                            attributes: _attributes,
                            orderQuantity: _orderQuantity,
                            variantPhoto: _variantPhoto,
                            variantPrice: _variantPrice);
                      }
                    },
                    child: Text(RCCubit.instance.getText(R.checkOrder)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, index) => _widgets[index],
          itemCount: _widgets.length,
        ),
      ),
    );
  }

  void _updateInfo() {
    _variantDescription = _attributes.entries.map((entry) => entry.value).toList().toString();

    try {
      _variantPrice = _item.variants?[_variantDescription]?['price'] ?? _item.price!;
    } catch (_) {
      _variantPrice = _item.price!;
    }

    try {
      _variantPhoto = _item.variants?[_variantDescription]?['photo'] ?? _item.itemPhotoUrl!;
    } catch (_) {
      _variantPhoto = _item.itemPhotoUrl!;
    }

    setState(() {});
  }
}
