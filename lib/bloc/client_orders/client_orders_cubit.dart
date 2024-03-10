import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/fibali_core/utils/utils.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/models/order_event.dart';
import 'package:fibali/fibali_core/models/shopping_review.dart';

part 'client_orders_state.dart';

class ClientOrdersCubit extends Cubit<ClientOrdersState> {
  final _db = FirebaseFirestore.instance;
  bool isSubmitting = false;

  ClientOrdersCubit() : super(ClientOrdersDisplay());

  Future<void> handleReminder(context, {required ShoppingOrder order}) {
    FAC.logEvent(FAEvent.shopping_reminder);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(status: RCCubit.instance.getText(R.sendingReminder), dismissOnTap: true);
      return _reminder(
        order: order,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showToast(RCCubit.instance.getText(R.sellerReminderSent), dismissOnTap: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> handleReceiveOrder(context, {required ShoppingOrder order}) {
    FAC.logEvent(FAEvent.shopping_receive_order);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.show(dismissOnTap: true);
      return _receiveOrder(
        order: order,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showError(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> handleRefund(context, {required ShoppingOrder order}) {
    FAC.logEvent(FAEvent.shopping_refund);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.show(status: RCCubit.instance.getText(R.applyingRefund), dismissOnTap: true);
      return _refund(
        order: order,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showError(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> handleAddReview(
    context, {
    required ShoppingOrder order,
    required String? reviewText,
    required num rating,
    required List<XFile>? photoFiles,
  }) {
    FAC.logEvent(FAEvent.shopping_add_review);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.show(status: RCCubit.instance.getText(R.addingReview), dismissOnTap: true);
      return _addReview(
        order: order,
        reviewText: reviewText,
        rating: rating,
        photoFiles: photoFiles,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.sellerReminderSent), dismissOnTap: true);
      });
    } else {
      EasyLoading.showError(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> _reminder({required ShoppingOrder order}) {
    final orderRef = ShoppingOrder.ref.doc(order.orderID);
    final orderEventRef = OrderEvent.ref(orderID: order.orderID!).doc();

    final orderEvent = OrderEvent(
      type: OrEvTypes.remindSeller.name,
      orderID: order.orderID,
      orderEventID: orderEventRef.id,
      itemID: order.itemID,
      geopoint: null,
      senderName: order.clientName,
      senderPhoto: order.clientPhoto,
      senderID: order.clientID,
      receiverID: order.storeOwnerID,
      storeID: order.storeID,
      text: null,
      photoUrls: null,
      rating: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    final writeBatch = _db.batch();
    writeBatch
      ..set<OrderEvent>(orderEventRef, orderEvent)
      ..update(orderRef, {
        SOLabels.lastOrderEvent.name: orderEvent.toFirestore(),
        '${SOLabels.isSeen.name}.${order.storeOwnerID!}': false,
      });

    return writeBatch.commit();
  }

  Future<void> _receiveOrder({required ShoppingOrder order}) {
    final orderRef = ShoppingOrder.ref.doc(order.orderID);
    final orderEventRef = OrderEvent.ref(orderID: order.orderID!).doc();

    final orderEvent = OrderEvent(
      type: OrEvTypes.orderReceived.name,
      orderID: order.orderID,
      orderEventID: orderEventRef.id,
      itemID: order.itemID,
      geopoint: null,
      senderName: order.clientName,
      senderPhoto: order.clientPhoto,
      senderID: order.clientID,
      receiverID: order.storeOwnerID,
      storeID: order.storeID,
      text: null,
      photoUrls: null,
      rating: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    final writeBatch = _db.batch();
    writeBatch
      ..set<OrderEvent>(orderEventRef, orderEvent)
      ..update(orderRef, {
        SOLabels.lastOrderEvent.name: orderEvent.toFirestore(),
        '${SOLabels.isSeen.name}.${order.storeOwnerID!}': false,
      });

    return writeBatch.commit();
  }

  Future<void> _refund({required ShoppingOrder order}) {
    final orderRef = ShoppingOrder.ref.doc(order.orderID);
    final orderEventRef = OrderEvent.ref(orderID: order.orderID!).doc();

    final orderEvent = OrderEvent(
      type: OrEvTypes.refundApplication.name,
      orderID: order.orderID,
      orderEventID: orderEventRef.id,
      itemID: order.itemID,
      geopoint: null,
      senderName: order.clientName,
      senderPhoto: order.clientPhoto,
      senderID: order.clientID,
      receiverID: order.storeOwnerID,
      storeID: order.storeID,
      text: null,
      photoUrls: null,
      rating: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    final writeBatch = _db.batch();
    writeBatch
      ..set<OrderEvent>(orderEventRef, orderEvent)
      ..update(orderRef, {
        SOLabels.lastOrderEvent.name: orderEvent.toFirestore(),
        '${SOLabels.isSeen.name}.${order.storeOwnerID!}': false,
      });

    return writeBatch.commit();
  }

  Future<void> _addReview({
    required ShoppingOrder order,
    required String? reviewText,
    required num rating,
    required List<XFile>? photoFiles,
  }) async {
    final orderRef = ShoppingOrder.ref.doc(order.orderID);
    final orderEventsRef = OrderEvent.ref(orderID: order.orderID!).doc();
    final reviewRef = ShoppingReview.ref.doc(order.orderID);
    final reviewDoc = await reviewRef.get();

    if (reviewDoc.exists) throw Exception("Already reviewed!");

    List<String>? photoUrls;
    if (photoFiles != null) {
      photoUrls = await Utils.uploadPhotos(
        ref: ShoppingReview.storageRef(reviewID: reviewDoc.id),
        files: photoFiles,
      );
    }

    final review = ShoppingReview(
      uid: order.clientID,
      itemID: order.itemID,
      storeID: order.storeID,
      orderID: order.orderID,
      userName: order.clientName,
      reviewText: reviewText,
      rating: rating,
      photoUrls: photoUrls,
      timestamp: FieldValue.serverTimestamp(),
    );

    final orderEvent = OrderEvent(
      type: OrEvTypes.addReview.name,
      orderID: order.orderID,
      orderEventID: orderEventsRef.id,
      itemID: order.itemID,
      geopoint: null,
      senderName: order.clientName,
      senderPhoto: order.clientPhoto,
      senderID: order.clientID,
      receiverID: order.storeOwnerID,
      storeID: order.storeID,
      text: review.reviewText,
      photoUrls: review.photoUrls,
      rating: review.rating,
      timestamp: FieldValue.serverTimestamp(),
    );

    final batch = _db.batch()
      ..set<ShoppingReview>(reviewRef, review)
      ..set<OrderEvent>(orderEventsRef, orderEvent)
      ..update(orderRef, {
        SOLabels.lastOrderEvent.name: orderEvent.toFirestore(),
        '${SOLabels.isSeen.name}.${order.storeOwnerID!}': false,
      });

    return batch.commit();
  }
}
