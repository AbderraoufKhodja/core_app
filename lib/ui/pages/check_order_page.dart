import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/bloc/item/item_bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/ui/pages/delivery_addresses_page.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/delivery_address.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class CheckOrderPage extends StatefulWidget {
  final Item item;
  final Map<String, dynamic> attributes;
  final num orderQuantity;
  final num variantPrice;
  final String variantPhoto;

  const CheckOrderPage({
    Key? key,
    required this.item,
    required this.attributes,
    required this.orderQuantity,
    required this.variantPrice,
    required this.variantPhoto,
  }) : super(key: key);

  @override
  CheckOrderPageState createState() => CheckOrderPageState();
}

class CheckOrderPageState extends State<CheckOrderPage> {
  final _noteController = TextEditingController();

  num _orderQuantity = 1;

  Map<String, dynamic> get _attributes => widget.attributes;

  Item get _item => widget.item;
  num get _variantPrice => widget.variantPrice;
  String get _variantPhoto => widget.variantPhoto;
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;
  ItemBloc get _itemBloc => BlocProvider.of<ItemBloc>(context);

  @override
  void initState() {
    super.initState();

    _orderQuantity = widget.orderQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const PopButton(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) => Card(
          elevation: 0,
          child: _widget[index],
        ),
        itemCount: _widget.length,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                '${RCCubit.instance.getText(R.price)}: ${_variantPrice * _orderQuantity} ${widget.item.currency ?? ''}'),
            ElevatedButton(
              onPressed: _submitOrder,
              child: Text(RCCubit.instance.getText(R.order)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _widget => [
        _buildDeliveryAddressTile(),
        ExpansionTile(
          trailing: const Icon(Icons.add_circle_outline),
          title: Text(RCCubit.instance.getText(R.addNote)),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _noteController,
                maxLines: 3,
                maxLength: 400,
              ),
            )
          ],
        ),
        ListTile(
          leading: PhotoWidgetNetwork(
            label: null,
            photoUrl: _item.photoUrls![0],
            width: Get.width / 8,
            height: Get.width / 8,
          ),
          title: ReadMoreText(
            _item.description!,
            trimLines: 3,
            colorClickableText: Colors.grey,
            trimMode: TrimMode.Line,
            textAlign: TextAlign.start,
            trimCollapsedText: " ${RCCubit().getText(R.readMore)}",
            trimExpandedText: " ${RCCubit().getText(R.showLess)}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(widget.attributes.toString()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: ListTile(title: Text(RCCubit.instance.getText(R.quantity)))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ActionChip(
                    label: const FaIcon(FontAwesomeIcons.minus),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _orderQuantity.toString(),
                      style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ActionChip(
                    label: const FaIcon(FontAwesomeIcons.plus),
                    onPressed: () {
                      setState(() {
                        _orderQuantity += 1;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(title: Text(RCCubit.instance.getText(R.saleServices))),
            Column(
              children: kFaker.lorem
                  .sentences(3)
                  .map((sentence) => ListTile(
                        contentPadding: const EdgeInsets.only(left: 16),
                        dense: true,
                        title: Text(kFaker.lorem.word()),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(sentence),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(title: Text(RCCubit.instance.getText(R.paymentOptions))),
            Column(
              children: kFaker.lorem
                  .sentences(2)
                  .map((sentence) => ListTile(
                        dense: true,
                        title: Text(kFaker.lorem.word()),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(sentence),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ];

  Widget _buildDeliveryAddressTile() {
    if (_currentUser != null) {
      if (_currentUser!.deliveryAddress != null) {
        final address = DeliveryAddress.fromFirestore(_currentUser!.deliveryAddress!);
        return ListTile(
          title: Text('${address.name!} : ${address.phoneNumber!}'),
          subtitle:
              Text('${address.province!}, ${address.subProvince!}, ${address.streetAddress!}'),
          onTap: () async {
            await DeliveryAddressesPage.show(userID: _currentUser!.uid);
            setState(() {});
          },
          trailing: const FaIcon(FontAwesomeIcons.penToSquare),
        );
      } else {
        return ListTile(
          title: Text(RCCubit.instance.getText(R.missingAddress)),
          subtitle: Text(RCCubit.instance.getText(R.pleaseUpdateAddress)),
          onTap: () async {
            await DeliveryAddressesPage.show(userID: _currentUser!.uid);
            setState(() {});
          },
          trailing: const FaIcon(FontAwesomeIcons.circleInfo),
        );
      }
    } else {
      return ListTile(
        title: Text(RCCubit.instance.getText(R.pleaseLogIn)),
      );
    }
  }

  Future<void> _submitOrder() async {
    if (_currentUser == null) {
      Get.snackbar('Missing user', 'please log in first');
    } else if (_currentUser!.uid == _item.storeOwnerID) {
      showOwnUserItem();
    } else if (_currentUser!.deliveryAddress == null) {
      showCheckAddressDialog();
    } else if (!DeliveryAddress.fromFirestore(_currentUser!.deliveryAddress!).isValid()) {
      showCheckAddressDialog();
    } else {
      _itemBloc.handleSubmitOrder(
        context,
        currentUser: _currentUser!,
        item: _item,
        attributes: _attributes,
        price: _variantPrice,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        finalPrice: _variantPrice * _orderQuantity,
        variantPrice: _variantPrice,
        variantPhoto: _variantPhoto,
      );
    }
  }

  Future<dynamic> showCheckAddressDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.clear),
            ),
            Text(RCCubit.instance.getText(R.checkAddress)),
            const Divider(),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                DeliveryAddressesPage.show(userID: _currentUser!.uid);
              },
              child: Text(RCCubit.instance.getText(R.updateInfo)))
        ],
      ),
    );
  }

  Future<dynamic> showOwnUserItem() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.clear),
            ),
            Text(RCCubit.instance.getText(R.ownedItem)),
            const Divider(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(RCCubit.instance.getText(R.ok)),
          )
        ],
      ),
    );
  }
}

Future<void> showCheckOrderPage(
  BuildContext context, {
  required Item item,
  required Map<String, dynamic> attributes,
  required num orderQuantity,
  required num variantPrice,
  required String variantPhoto,
}) {
  final analytics = FirebaseAnalytics.instance;

  analytics.logBeginCheckout(
    items: [
      AnalyticsEventItem(
        affiliation: item.storeName,
        currency: item.currency,
        itemCategory: item.category1,
        itemCategory2: item.category2,
        itemCategory3: item.category3,
        itemCategory4: item.category4,
        itemCategory5: item.category5,
        itemName: item.title,
        price: item.price,
        quantity: orderQuantity.toInt(),
        itemId: item.itemID,
        itemVariant: attributes.toString(),
      )
    ],
    currency: item.currency,
  );

  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: BlocProvider.of<AuthBloc>(context)),
          BlocProvider.value(value: BlocProvider.of<ItemBloc>(context)),
          BlocProvider.value(value: BlocProvider.of<SettingsCubit>(context)),
        ],
        child: CheckOrderPage(
          item: item,
          attributes: attributes,
          orderQuantity: orderQuantity,
          variantPhoto: variantPhoto,
          variantPrice: variantPrice,
        ),
      ),
    ),
  );
}
