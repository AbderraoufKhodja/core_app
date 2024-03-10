import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/bloc/messaging/bloc.dart';
import 'package:fibali/fibali_core/models/swap_review.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/models/swap.dart';
import 'package:fibali/fibali_core/models/swap_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

part 'swap_events_state.dart';

class SwapEventsCubit extends Cubit<SwapEventsState> {
  final _db = FirebaseFirestore.instance;
  final swapsRef = Swap.ref;
  bool isSubmitting = false;

  SwapEventsCubit() : super(SwapEventsDisplay());

  Future<void> handleSubmitSwap({
    required AppUser currentUser,
    required String receiverID,
    required String receiverName,
    required String? receiverPhoto,
    required Map<String, dynamic> senderItemsID,
    required Map<String, dynamic> receiverItemsID,
    required num? price,
    required num? finalPrice,
    required String? note,
  }) {
    FAC.logEvent(FAEvent.send_new_swap_proposition);
    final writeBatch = _db.batch();

    final swapRef = Swap.ref.doc();

    final swapEventRef = SwapEvent.ref(swapID: swapRef.id).doc();

    final swapEvent = SwapEvent(
      type: SETypes.newSwap.name,
      swapID: swapRef.id,
      senderItemsID: senderItemsID,
      receiverItemsID: receiverItemsID,
      geopoint: null,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      senderID: currentUser.uid,
      receiverID: receiverID,
      text: null,
      photoUrls: null,
      rating: null,
      isSeen: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    final swap = Swap(
      usersID: [currentUser.uid, receiverID],
      swapID: swapRef.id,
      receiverItemsID: receiverItemsID,
      senderItemsID: senderItemsID,
      lastSwapEvent: swapEvent.toFirestore(),
      senderID: currentUser.uid,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      receiverID: receiverID,
      receiverName: receiverName,
      receiverPhoto: receiverPhoto,
      finalPrice: finalPrice,
      note: note,
      currency: null,
      isSeen: {receiverID: false},
      timestamp: FieldValue.serverTimestamp(),
    );

    final chatID = '${ChatTypes.swapIt.name}_${Utils.getUniqueID(
      firstID: currentUser.uid,
      secondID: receiverID,
    )}';

    MessagingBloc.sendMessage(
      message: Message(
          messageID: null,
          chatID: chatID,
          type: MessageTypes.newSwap.name,
          text: null,
          senderID: currentUser.uid,
          senderName: currentUser.name,
          receiverID: receiverID,
          location: null,
          senderItems: senderItemsID,
          otherItems: receiverItemsID,
          photoUrl: null,
          item: null,
          order: null,
          swap: swap.toFirestore(),
          timestamp: FieldValue.serverTimestamp(),
          appointmentID: null,
          channelName: null,
          createAt: null,
          receiverName: null,
          receiverPhoto: null,
          senderPhoto: currentUser.photoUrl,
          status: null,
          token: null,
          photoUrls: null),
      type: ChatTypes.swapIt,
      senderID: currentUser.uid,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      receiverID: receiverID,
      receiverName: receiverName,
      receiverPhoto: receiverPhoto,
      chatID: chatID,
      photoFiles: null,
    );

    writeBatch
      ..set(swapRef, swap)
      ..set(swapEventRef, swapEvent);

    isSubmitting = true;
    EasyLoading.show(dismissOnTap: true);

    return writeBatch.commit().then((value) {
      isSubmitting = false;
      EasyLoading.showSuccess('');
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      isSubmitting = false;
      EasyLoading.showError('');
    });
  }

  Future<void> handleAcceptSwap(
    context, {
    required String swapID,
    required AppUser currentUser,
    required String receiverID,
    required String receiverName,
    required String? receiverPhoto,
    required Map<String, dynamic>? senderItemsID,
    required Map<String, dynamic>? receiverItemsID,
  }) {
    FAC.logEvent(FAEvent.accept_swap_proposition);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(dismissOnTap: true);
      return _acceptSwap(
        currentUser: currentUser,
        swapID: swapID,
        receiverID: receiverID,
        receiverName: receiverName,
        receiverPhoto: receiverPhoto,
        receiverItemsID: receiverItemsID,
        senderItemsID: senderItemsID,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
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

  Future<void> handleDeclineSwap(
    context, {
    required AppUser currentUser,
    required String swapID,
    required String receiverID,
    required String receiverName,
    required String? receiverPhoto,
  }) {
    FAC.logEvent(FAEvent.decline_swap_proposition);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(dismissOnTap: true);
      return _declineSwap(
        currentUser: currentUser,
        swapID: swapID,
        receiverID: receiverID,
        receiverName: receiverName,
        receiverPhoto: receiverPhoto,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
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

  Future<void> handleCancel(
    context, {
    required AppUser currentUser,
    required String swapID,
    required String receiverID,
    required String receiverName,
    required String? receiverPhoto,
  }) {
    FAC.logEvent(FAEvent.cancel_swap_proposition);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(status: RCCubit.instance.getText(R.applyingRefund), dismissOnTap: true);
      return _swapCanceled(
        currentUser: currentUser,
        swapID: swapID,
        receiverID: receiverID,
        receiverName: receiverName,
        receiverPhoto: receiverPhoto,
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
      EasyLoading.showError(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> handleAddSwapReview(
    context, {
    required AppUser currentUser,
    required String swapID,
    required Map<String, dynamic>? senderItemsID,
    required Map<String, dynamic>? receiverItemsID,
    required String receiverID,
    required String receiverName,
    required String? receiverPhoto,
    required String? reviewText,
    required num rating,
    required List<XFile>? photoFiles,
  }) {
    FAC.logEvent(FAEvent.add_swap_review);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(status: RCCubit.instance.getText(R.addingReview), dismissOnTap: true);
      return _addSwapReview(
        currentUser: currentUser,
        swapID: swapID,
        receiverID: receiverID,
        receiverName: receiverName,
        receiverPhoto: receiverPhoto,
        reviewText: reviewText,
        rating: rating,
        photoFiles: photoFiles,
        receiverItemsID: receiverItemsID,
        senderItemsID: senderItemsID,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showSuccess(RCCubit.instance.getText(R.success), dismissOnTap: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
        EasyLoading.showError('', dismissOnTap: true);
      });
    } else {
      EasyLoading.dismiss(animation: true);
      EasyLoading.showError(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> _acceptSwap({
    required AppUser currentUser,
    required String swapID,
    required String receiverID,
    required String receiverName,
    required String? receiverPhoto,
    required Map<String, dynamic>? senderItemsID,
    required Map<String, dynamic>? receiverItemsID,
  }) {
    final swapRef = Swap.ref.doc(swapID);
    final swapEventRef = SwapEvent.ref(swapID: swapID).doc();

    final swapEvent = SwapEvent(
      type: SETypes.swapAccepted.name,
      swapID: swapID,
      receiverItemsID: receiverItemsID,
      senderItemsID: senderItemsID,
      senderID: currentUser.uid,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      receiverID: receiverID,
      text: null,
      photoUrls: null,
      isSeen: false,
      rating: null,
      timestamp: FieldValue.serverTimestamp(),
      geopoint: null,
    );

    final swap = Swap(
      usersID: [currentUser.uid, receiverID],
      swapID: swapID,
      receiverItemsID: receiverItemsID,
      senderItemsID: senderItemsID,
      lastSwapEvent: swapEvent.toFirestore(),
      senderID: currentUser.uid,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      receiverID: receiverID,
      receiverName: receiverName,
      receiverPhoto: receiverPhoto,
      finalPrice: null,
      note: null,
      currency: null,
      isSeen: {receiverID: false},
      timestamp: FieldValue.serverTimestamp(),
    );

    final chatID = '${ChatTypes.swapIt.name}_${Utils.getUniqueID(
      firstID: currentUser.uid,
      secondID: receiverID,
    )}';

    MessagingBloc.sendMessage(
      message: Message(
          messageID: null,
          chatID: chatID,
          type: MessageTypes.newSwap.name,
          text: null,
          senderID: currentUser.uid,
          senderName: currentUser.name,
          receiverID: receiverID,
          location: null,
          senderItems: senderItemsID,
          otherItems: receiverItemsID,
          photoUrl: null,
          item: null,
          order: null,
          swap: swap.toFirestore(),
          timestamp: FieldValue.serverTimestamp(),
          appointmentID: null,
          channelName: null,
          createAt: null,
          receiverName: null,
          receiverPhoto: null,
          senderPhoto: currentUser.photoUrl,
          status: null,
          token: null,
          photoUrls: null),
      type: ChatTypes.swapIt,
      senderID: currentUser.uid,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      receiverID: receiverID,
      receiverName: receiverName,
      receiverPhoto: receiverPhoto,
      chatID: chatID,
      photoFiles: null,
    );

    final writeBatch = _db.batch();
    writeBatch
      ..set<SwapEvent>(swapEventRef, swapEvent)
      ..update(swapRef, {
        SwLabels.lastSwapEvent.name: swapEvent.toFirestore(),
        '${SwLabels.isSeen.name}.$receiverID': false,
      });

    return writeBatch.commit();
  }

  Future<void> _declineSwap({
    required AppUser currentUser,
    required String swapID,
    required String receiverID,
    required String receiverName,
    required String? receiverPhoto,
  }) {
    final swapRef = Swap.ref.doc(swapID);
    final swapEventRef = SwapEvent.ref(swapID: swapID).doc();

    final swapEvent = SwapEvent(
      type: SETypes.swapDeclined.name,
      swapID: swapID,
      receiverItemsID: null,
      senderItemsID: null,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      senderID: currentUser.uid,
      receiverID: receiverID,
      text: null,
      photoUrls: null,
      isSeen: false,
      rating: null,
      timestamp: FieldValue.serverTimestamp(),
      geopoint: null,
    );

    final writeBatch = _db.batch();
    writeBatch
      ..set<SwapEvent>(swapEventRef, swapEvent)
      ..update(swapRef, {
        SwLabels.lastSwapEvent.name: swapEvent.toFirestore(),
        '${SwLabels.isSeen.name}.$receiverID': false,
      });

    return writeBatch.commit();
  }

  Future<void> _swapCanceled({
    required AppUser currentUser,
    required String swapID,
    required String receiverID,
    required String receiverName,
    required String? receiverPhoto,
  }) {
    final swapRef = Swap.ref.doc(swapID);
    final swapEventRef = SwapEvent.ref(swapID: swapID).doc();

    final swapEvent = SwapEvent(
      type: SETypes.swapCanceled.name,
      swapID: swapID,
      receiverItemsID: null,
      senderItemsID: null,
      geopoint: null,
      senderID: currentUser.uid,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      receiverID: receiverID,
      text: null,
      photoUrls: null,
      isSeen: false,
      rating: null,
      timestamp: FieldValue.serverTimestamp(),
    );

    final writeBatch = _db.batch();
    writeBatch
      ..set<SwapEvent>(swapEventRef, swapEvent)
      ..update(swapRef, {
        SwLabels.lastSwapEvent.name: swapEvent.toFirestore(),
        '${SwLabels.isSeen.name}.$receiverID': false,
      });

    return writeBatch.commit();
  }

  Future<void> _addSwapReview({
    required AppUser currentUser,
    required Map<String, dynamic>? senderItemsID,
    required Map<String, dynamic>? receiverItemsID,
    required String swapID,
    required String receiverID,
    required String receiverName,
    required String? receiverPhoto,
    required String? reviewText,
    required num rating,
    required List<XFile>? photoFiles,
  }) async {
    final swapRef = Swap.ref.doc(swapID);
    final swapEventsRef = SwapEvent.ref(swapID: swapID).doc();
    final swapReviewRef = SwapReview.ref(userID: receiverID).doc(swapID);
    final reviewDoc = await swapReviewRef.get();

    if (reviewDoc.exists) throw Exception("Already reviewed!");

    List<String>? photoUrls;
    if (photoFiles != null) {
      photoUrls = await Utils.uploadPhotos(
        ref: SwapReview.storageRef(swapID: swapID),
        files: photoFiles,
      );
    }

    final review = SwapReview(
      uid: currentUser.uid,
      receiverItemsID: receiverItemsID,
      senderItemsID: senderItemsID,
      swapID: swapID,
      userName: currentUser.name,
      reviewText: reviewText,
      rating: rating,
      photoUrls: photoUrls,
      timestamp: FieldValue.serverTimestamp(),
    );

    final swapEvent = SwapEvent(
      type: SETypes.addSwapReview.name,
      swapID: swapID,
      receiverItemsID: receiverItemsID,
      senderItemsID: senderItemsID,
      geopoint: null,
      senderName: currentUser.name,
      senderID: currentUser.uid,
      receiverID: receiverID,
      text: review.reviewText,
      photoUrls: review.photoUrls,
      rating: review.rating,
      isSeen: false,
      timestamp: FieldValue.serverTimestamp(),
      senderPhoto: currentUser.photoUrl,
    );

    final batch = _db.batch()
      ..set<SwapReview>(swapReviewRef, review)
      ..set<SwapEvent>(swapEventsRef, swapEvent)
      ..update(swapRef, {
        SwLabels.lastSwapEvent.name: swapEvent.toFirestore(),
        '${SwLabels.isSeen.name}.$receiverID': false,
      });

    return batch.commit();
  }
}
