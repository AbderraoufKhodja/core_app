import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/order_event.dart';
import 'package:uuid/uuid.dart';

part 'seller_orders_state.dart';

class SellerOrdersCubit extends Cubit<SellerOrdersState> {
  final _db = FirebaseFirestore.instance;

  final ordersRef = ShoppingOrder.ref;

  bool isSubmitting = false;

  late Stream<QuerySnapshot<ShoppingOrder>> orders;

  SellerOrdersCubit() : super(SellerOrdersDisplay());

  Future<void> markAsSeen({
    required String currentUserID,
    required String orderID,
  }) {
    return _db.collection('orders').doc(orderID).update({
      'isSeen.' + currentUserID: true,
    });
  }

  Future<void> _itemPackaged({required ShoppingOrder order}) {
    final _orderRef = _db.collection('orders').doc(order.orderID);

    final _orderEventRef = OrderEvent.ref(orderID: order.orderID!).doc();

    final _orderEvent = OrderEvent(
      orderEventID: _orderEventRef.id,
      senderPhoto: order.clientPhoto,
      type: "itemPackaged",
      orderID: order.orderID,
      itemID: order.itemID,
      geopoint: null,
      senderName: order.clientName,
      senderID: order.clientID,
      receiverID: order.storeOwnerID,
      storeID: order.storeID,
      text: null,
      photoUrls: null,
      // isSeen: false,
      rating: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    final writeBatch = _db.batch();
    writeBatch
      ..set<OrderEvent>(_orderEventRef, _orderEvent)
      ..update(_orderRef, {
        'lastOrderEvent': _orderEvent.toFirestore(),
        'isSeen.' + order.clientID!: false,
      });

    return writeBatch.commit();
  }

  Future<void> _acceptRefund({required ShoppingOrder order}) {
    final _orderRef = _db.collection('orders').doc(order.orderID);

    final _orderEventRef = OrderEvent.ref(orderID: order.orderID!).doc();

    final _orderEvent = OrderEvent(
      orderEventID: _orderEventRef.id,
      type: "acceptRefund",
      orderID: order.orderID,
      itemID: order.itemID,
      geopoint: null,
      senderName: order.clientName,
      senderPhoto: order.clientPhoto,
      senderID: order.clientID,
      receiverID: order.storeOwnerID,
      storeID: order.storeID,
      text: null,
      photoUrls: null,
      // isSeen: false,
      rating: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    final writeBatch = _db.batch();
    writeBatch
      ..set<OrderEvent>(_orderEventRef, _orderEvent)
      ..update(_orderRef, {
        'lastOrderEvent': _orderEvent.toFirestore(),
        'isSeen.' + order.clientID!: false,
      });

    return writeBatch.commit();
  }

  Future<void> _declineRefund({required ShoppingOrder order}) {
    final _orderRef = _db.collection('orders').doc(order.orderID);

    final _orderEventRef = OrderEvent.ref(orderID: order.orderID!).doc();

    final _orderEvent = OrderEvent(
      orderEventID: _orderEventRef.id,
      type: "declineRefund",
      orderID: order.orderID,
      itemID: order.itemID,
      geopoint: null,
      senderName: order.clientName,
      senderPhoto: order.clientPhoto,
      senderID: order.clientID,
      receiverID: order.storeOwnerID,
      storeID: order.storeID,
      text: null,
      photoUrls: null,
      // isSeen: false,
      rating: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    final writeBatch = _db.batch();
    writeBatch
      ..set<OrderEvent>(_orderEventRef, _orderEvent)
      ..update(
        _orderRef,
        {
          'lastOrderEvent': _orderEvent.toFirestore(),
          'isSeen.' + order.clientID!: false,
        },
      );

    return writeBatch.commit();
  }

  Future<void> _sendPackage({
    required ShoppingOrder order,
    required String? comment,
    required List<XFile>? photoFiles,
  }) async {
    final _photoUrls = <String>[];

    final _orderRef = _db.collection('orders').doc(order.orderID);

    final _itemRef = _db.collection('items').doc(order.itemID);

    final _storeRef = _db.collection('stores').doc(order.storeID);

    final _itemsStorageRef = FirebaseStorage.instance
        .ref()
        .child('stores')
        .child(order.storeID!)
        .child('orders')
        .child(_orderRef.id);

    final _orderEventRef = OrderEvent.ref(orderID: order.orderID!).doc();

    if (photoFiles != null) {
      await Future.wait(
        photoFiles.map(
          (photo) async {
            final _photoID = Uuid().v4();
            final _photosRef = _itemsStorageRef.child(_photoID);
            if (kIsWeb) {
              final photoBytes = await photo.readAsBytes();
              return _photosRef.putData(photoBytes).then(
                    (value) => _photosRef.getDownloadURL().then(
                          (url) => _photoUrls.add(url),
                        ),
                  );
            } else {
              return _photosRef.putFile(File(photo.path)).then(
                    (value) => _photosRef.getDownloadURL().then(
                          (url) => _photoUrls.add(url),
                        ),
                  );
            }
          },
        ),
      );
    }

    final photoUrls = _photoUrls.isNotEmpty ? _photoUrls : null;

    final _orderEvent = OrderEvent(
      orderEventID: _orderEventRef.id,
      type: "packageSent",
      orderID: order.orderID,
      itemID: order.itemID,
      geopoint: null,
      senderName: order.clientName,
      senderPhoto: order.clientPhoto,
      senderID: order.clientID,
      receiverID: order.storeOwnerID,
      storeID: order.storeID,
      text: comment,
      photoUrls: photoUrls,
      rating: null,
      // isSeen: false,
      timestamp: FieldValue.serverTimestamp(),
    );

    final _batch = _db.batch()
      ..set<OrderEvent>(_orderEventRef, _orderEvent)
      ..update(_orderRef, {
        'lastOrderEvent': _orderEvent.toFirestore(),
        'isSeen.' + order.clientID!: false,
      })
      ..update(_itemRef, {'numPackagesSent': FieldValue.increment(1)})
      ..update(_storeRef, {'numPackagesSent': FieldValue.increment(1)});

    return _batch.commit();
  }

  Future<void> handleItemPackaged(context, {required ShoppingOrder order}) {
    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(dismissOnTap: true);
      return _itemPackaged(
        order: order,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> handleAcceptRefund(context, {required ShoppingOrder order}) {
    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(dismissOnTap: true);
      return _acceptRefund(
        order: order,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> handleDeclineRefund(context, {required ShoppingOrder order}) {
    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(status: RCCubit.instance.getText(R.uploadingItem), dismissOnTap: true);
      return _declineRefund(
        order: order,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        // EasyLoading.showSuccess(rc.getDisplayText(context,'success), dismissOnTap: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> handleSendPackage(
    context, {
    required ShoppingOrder order,
    required String? reviewText,
    required List<XFile>? photoFiles,
  }) {
    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(dismissOnTap: true);
      return _sendPackage(
        order: order,
        comment: reviewText,
        photoFiles: photoFiles,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
        Get.back();
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }
}
