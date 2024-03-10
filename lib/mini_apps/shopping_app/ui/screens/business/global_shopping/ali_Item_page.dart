import 'dart:ui';

import 'package:ae_api/ae_api.dart';
import 'package:badges/badges.dart' as bd;
import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AeProductPage extends StatefulWidget {
  final Product product;

  const AeProductPage({
    super.key,
    required this.product,
  });

  static Future<dynamic>? show({required Product product}) {
    return Get.to(() => AeProductPage(product: product));
  }

  @override
  AeProductPageState createState() => AeProductPageState();
}

class AeProductPageState extends State<AeProductPage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  String _shippingOption = 'Priority Shipping';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white70,
        elevation: 0,
        child: const PopButton(),
      ),
      body: Stack(
        children: [
          PhotoWidgetNetwork(
            label: null,
            photoUrl: widget.product.productMainImageUrl,
            fit: BoxFit.cover,
            height: Get.height,
            width: Get.width,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0),
              ),
            ),
          ),
          Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: _buildItemContent(product: widget.product),
            bottomNavigationBar: _buildBottomBar(widget.product),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Product item) {
    return BottomAppBar(
      padding: const EdgeInsets.all(8.0),
      color: Get.theme.bottomAppBarTheme.color?.withOpacity(0.8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // IconButton(
              //   onPressed: () {
              //     showStorePage(context, storeID: _item.storeID!);
              //   },
              //   icon: FaIcon(
              //     FontAwesomeIcons.store,
              //     color: Colors.grey,
              //   ),
              // ),
              IconButton(
                onPressed: () {
                  if (_currentUser != null) {
                    // final typeChatID = '${ChatTypes.shopping.name}_${Utils.getUniqueID(
                    //   firstID: _currentUser!.uid,
                    //   secondID: item.storeOwnerID!,
                    // )}';
                    // showMessagingPage(
                    //   chatID: typeChatID,
                    //   type: ChatTypes.shopping,
                    //   otherUserID: item.storeOwnerID!,
                    // );
                  } else {
                    Get.snackbar(
                      'Not logged in',
                      'Please log in first',
                      onTap: (_) => () {},
                      duration: const Duration(seconds: 4),
                      animationDuration: const Duration(milliseconds: 800),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                icon: const FaIcon(
                  FontAwesomeIcons.solidComments,
                  color: Colors.grey,
                ),
              ),
              // FavoriteButton(item: widget.item),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                // ElevatedButton(
                //   onPressed: () {},
                //   child: FaIcon(FontAwesomeIcons.cartPlus),
                //   style: ElevatedButton.styleFrom(
                //     fixedSize: Size(Get.width / 4, Get.height / 18),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(30.0),
                //         bottomLeft: Radius.circular(30.0),
                //       ),
                //     ),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    // CheckOrderPage.show(item: widget.item);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(Get.width / 4, Get.height / 18),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text(RCCubit.instance.getText(R.order)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemContent({required Product product}) {
    final widgets = ListView(children: [
      Card(
        color: Get.theme.cardColor.withOpacity(0.8),
        elevation: 0,
        child: SizedBox(
          height: Get.height / 2.5,
          child: bd.Badge(
            position: bd.BadgePosition.custom(bottom: 10),
            badgeStyle: const bd.BadgeStyle(
              shape: bd.BadgeShape.circle,
              badgeColor: Colors.transparent,
              elevation: 0,
            ),
            showBadge: true,
            badgeContent: const TabPageSelector(
              selectedColor: Colors.white70,
              indicatorSize: 10,
            ),
            child: TabBarView(
              children: [
                PhotoWidgetNetwork(
                  label: null,
                  photoUrl: product.productMainImageUrl,
                  fit: BoxFit.fitHeight,
                  canDisplay: true,
                )
              ],
            ),
          ),
        ),
      ),
      Column(
        children: [
          Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              color: Get.theme.cardColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              product.productTitle ?? '',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 50,
                                  color: Colors.transparent,
                                  // child: LikeButton(item: widget.item),
                                ),
                                Container(
                                  width: 50,
                                  height: 30,
                                  color: Colors.grey.shade200,
                                  // child: FittedBox(
                                  //   child: Text(item.numLikes?.toString() ?? '',
                                  //       style: const TextStyle(color: Colors.grey)),
                                  // ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      subtitle: Text(
                        product.productTitle ?? '',
                        maxLines: 6,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 64.0),
                      child: Divider(height: 0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (double.tryParse(product.evaluateRate ?? '') != null)
                          Row(
                            children: [
                              Chip(
                                label: Text(
                                  (product.evaluateRate!),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              RatingBarIndicator(
                                rating: double.parse(product.evaluateRate!),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 25.0,
                              ),
                            ],
                          ),
                        if (!kIsWeb)
                          IconButton(
                              onPressed: () {
                                // _itemBloc.handleShareShoppingItem(context, item: widget.item);
                              },
                              icon: const Icon(Icons.share)),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '${product.originalPrice} ${product.originalPriceCurrency}',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.red.shade300,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildShippingMethods()
        ],
      ),
    ]);
    return DefaultTabController(
      initialIndex: 0,
      length: 1,
      child: widgets,
    );
  }

  // Widget _buildShippingOptions(AliItem item) {
  //   return Card(
  //     margin: const EdgeInsets.all(4.0),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Text(
  //             'Shipping Method:  ',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 8.0),
  //           Text('Shipping Company: ${item.shippingCompany}'),
  //           SizedBox(height: 8.0),
  //           Text('Shipping Cost: ${item.shippingCost}'),
  //           SizedBox(height: 8.0),
  //           Text('Estimated Delivery Time: ${item.estimatedDeliveryTime}'),
  //           SizedBox(height: 8.0),
  //           Text('Shipping From: ${item.shippingFrom}'),
  //           SizedBox(height: 8.0),
  //           Text('Shipping To: ${item.shippingTo}'),
  //           SizedBox(height: 8.0),
  //           Text('Tracking Information: ${item.trackingInformation}'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Container _buildFAQ(AliItem item) {
  //   return Container(
  //         margin: const EdgeInsets.all(4.0),
  //         decoration: BoxDecoration(
  //           color: Colors.white70,
  //           borderRadius: BorderRadius.circular(30),
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(30),
  //           child: BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
  //             child: item.frequentlyAQ != null
  //                 ? Column(
  //                     children: [
  //                       ListTile(
  //                         leading: Text(RCCubit.instance.getText(R.frequentlyAskedQuestions),
  //                             style: const TextStyle(fontSize: 20)),
  //                         trailing: Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Text(
  //                               '(${item.frequentlyAQ!.entries.length})',
  //                               style: const TextStyle(color: Colors.grey),
  //                             ),
  //                             GestureDetector(
  //                               onTap: _showFrequentlyAQ,
  //                               child: const Icon(Icons.arrow_forward_ios_rounded),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 16.0),
  //                         child: Divider(height: 0),
  //                       ),
  //                       Column(
  //                         children: item.frequentlyAQ!.entries.map((entry) {
  //                           return ListTile(
  //                             visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
  //                             title: Text(entry.key),
  //                             subtitle: Text(entry.value),
  //                             horizontalTitleGap: 0,
  //                             dense: true,
  //                           );
  //                         }).toList(),
  //                       ),
  //                     ],
  //                   )
  //                 : const SizedBox(),
  //           ),
  //         ),
  //       );
  // }

  Widget _buildShippingMethods() {
    return Card(
      margin: const EdgeInsets.all(4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Shipping Method:  ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Priority Shipping'),
              leading: Radio<String>(
                value: 'Priority Shipping',
                groupValue: _shippingOption,
                onChanged: (String? value) {
                  setState(() {
                    _shippingOption = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('AliExpress Shipping'),
              leading: Radio<String>(
                value: 'AliExpress Shipping',
                groupValue: _shippingOption,
                onChanged: (String? value) {
                  setState(() {
                    _shippingOption = value!;
                  });
                },
              ),
            ),
            // Rest of the code...
          ],
        ),
      ),
    );
  }
}

class ApiResponse {
  final Status status;
  final Settings settings;
  final List<Result> resultList;

  ApiResponse({
    required this.status,
    required this.settings,
    required this.resultList,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: Status.fromJson(json['status']),
      settings: Settings.fromJson(json['settings']),
      resultList: (json['resultList'] as List).map((i) => Result.fromJson(i)).toList(),
    );
  }
}

class Status {
  final String data;
  final int code;
  final String executionTime;
  final String requestTime;
  final String requestId;
  final String endpoint;
  final String apiVersion;
  final String functionsVersion;
  final String la;
  final int pmu;
  final int mu;

  Status({
    required this.data,
    required this.code,
    required this.executionTime,
    required this.requestTime,
    required this.requestId,
    required this.endpoint,
    required this.apiVersion,
    required this.functionsVersion,
    required this.la,
    required this.pmu,
    required this.mu,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      data: json['data'],
      code: json['code'],
      executionTime: json['executionTime'],
      requestTime: json['requestTime'],
      requestId: json['requestId'],
      endpoint: json['endpoint'],
      apiVersion: json['apiVersion'],
      functionsVersion: json['functionsVersion'],
      la: json['la'],
      pmu: json['pmu'],
      mu: json['mu'],
    );
  }
}

class Settings {
  final String itemId;
  final String quantity;
  final String region;
  final String currency;
  final String locale;

  Settings({
    required this.itemId,
    required this.quantity,
    required this.region,
    required this.currency,
    required this.locale,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      itemId: json['itemId'],
      quantity: json['quantity'],
      region: json['region'],
      currency: json['currency'],
      locale: json['locale'],
    );
  }
}

class Result {
  final String shippingFrom;
  final String shippingFromCode;
  final String shippingTo;
  final String shippingToCode;
  final String shippingFee;
  final String shippingCompany;
  final String shippingTime;
  final String serviceName;
  final String estimateDelivery;
  final String estimateDeliveryDate;
  final bool trackingAvailable;
  final List<String> note;

  Result({
    required this.shippingFrom,
    required this.shippingFromCode,
    required this.shippingTo,
    required this.shippingToCode,
    required this.shippingFee,
    required this.shippingCompany,
    required this.shippingTime,
    required this.serviceName,
    required this.estimateDelivery,
    required this.estimateDeliveryDate,
    required this.trackingAvailable,
    required this.note,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      shippingFrom: json['shippingFrom'],
      shippingFromCode: json['shippingFromCode'],
      shippingTo: json['shippingTo'],
      shippingToCode: json['shippingToCode'],
      shippingFee: json['shippingFee'],
      shippingCompany: json['shippingCompany'],
      shippingTime: json['shippingTime'],
      serviceName: json['serviceName'],
      estimateDelivery: json['estimateDelivery'],
      estimateDeliveryDate: json['estimateDeliveryDate'],
      trackingAvailable: json['trackingAvailable'],
      note: List<String>.from(json['note']),
    );
  }
}
