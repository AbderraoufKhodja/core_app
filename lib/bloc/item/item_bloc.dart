import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/d_l_params.dart';
import 'package:fibali/fibali_core/models/favorite.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/models/like.dart';
import 'package:fibali/fibali_core/models/order_event.dart';
import 'package:fibali/fibali_core/models/shopping_order.dart';
import 'package:fibali/fibali_core/models/store.dart';
import 'package:fibali/fibali_core/models/view_item.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';

part 'item_event.dart';

part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  bool isSubmitting = false;

  ItemBloc() : super(ItemInitial()) {
    on<ItemEvent>((event, emit) {
      if (event is LoadItem) {
        emit(ItemLoading());

        final item = Item.ref.doc(event.itemID).snapshots();

        emit(ItemLoaded(item: BehaviorSubject()..addStream(item)));
      }
    });
  }

  Future<void> handleSubmitOrder(
    context, {
    required AppUser currentUser,
    required Item item,
    required Map<String, dynamic> attributes,
    required num price,
    required String variantPhoto,
    required num finalPrice,
    required num variantPrice,
    required String? note,
  }) {
    final writeBatch = FirebaseFirestore.instance.batch();

    final orderRef = ShoppingOrder.ref.doc();
    final orderEventRef = OrderEvent.ref(orderID: orderRef.id).doc();

    final orderEvent = OrderEvent(
      type: OrEvTypes.newOrder.name,
      orderID: orderRef.id,
      orderEventID: orderEventRef.id,
      itemID: item.itemID,
      geopoint: null,
      senderName: currentUser.name,
      senderPhoto: currentUser.photoUrl,
      senderID: currentUser.uid,
      receiverID: item.storeOwnerID,
      storeID: item.storeID,
      text: null,
      photoUrls: null,
      rating: null,
      timestamp: FieldValue.serverTimestamp(),
    );
    final order = ShoppingOrder(
      usersID: [currentUser.uid, item.storeOwnerID],
      orderID: orderRef.id,
      lastOrderEvent: orderEvent.toFirestore(),
      clientID: currentUser.uid,
      clientName: currentUser.name,
      clientPhoneNumber: currentUser.phoneNumber,
      storeOwnerID: item.storeOwnerID,
      storeID: item.storeID,
      storeName: item.storeName,
      storePhoneNumber: item.storePhoneNumber,
      itemID: item.itemID,
      itemTitle: item.title,
      itemDescription: item.description,
      attributes: attributes,
      variantPhoto: variantPhoto,
      itemPhoto: item.itemPhotoUrl,
      finalPrice: finalPrice,
      note: note,
      currency: item.currency,
      isConfirmed: false,
      deliveryAddress: currentUser.deliveryAddress,
      storeLogo: item.storeLogo,
      clientPhoto: currentUser.photoUrl,
      isSeen: {item.storeOwnerID!: false},
      timestamp: FieldValue.serverTimestamp(),
    );
    writeBatch
      ..set(
        orderRef,
        order,
      )
      ..set(orderEventRef, orderEvent);

    isSubmitting = true;
    EasyLoading.dismiss();
    EasyLoading.show(status: RCCubit.instance.getText(R.submittingOrder), dismissOnTap: true);

    return writeBatch.commit().then((value) {
      isSubmitting = false;
      EasyLoading.dismiss();
      EasyLoading.showSuccess(RCCubit.instance.getText(R.success));

      Future.delayed(const Duration(seconds: 1)).then((value) {
        Get.back();
        Get.back();
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      isSubmitting = false;
      EasyLoading.dismiss();
      EasyLoading.showError(RCCubit.instance.getText(R.failed));
    });
  }

  Future<void> handleLikeItem(
    context, {
    required Item item,
    required String currentUserID,
  }) {
    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(dismissOnTap: true);
      return _likeItem(
        item: item,
        currentUserID: currentUserID,
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

  Future<void> _likeItem({
    required Item item,
    required String currentUserID,
  }) {
    // TODO: adding friends and followers
    final itemRef = Item.ref.doc(item.itemID);
    final storeRef = Store.ref.doc(item.storeID);

    final writeBatch = FirebaseFirestore.instance.batch();
    writeBatch
      ..set<Like>(
          Like.ref.doc('like_$currentUserID${item.itemID!}'),
          Like(
            type: LiTypes.shoppingItem.name,
            followers: [],
            friends: [],
            uid: currentUserID,
            itemID: item.itemID,
            itemOwnerID: item.storeOwnerID,
            timestamp: FieldValue.serverTimestamp(),
          ))
      ..update(itemRef, {ItemLabels.numLikes.name: FieldValue.increment(1)})
      ..update(storeRef, {StoreLabels.numLikes.name: FieldValue.increment(1)});

    return writeBatch.commit();
  }

  Future<void> handleRemoveLikeItem(
    context, {
    required Item item,
    required String currentUserID,
  }) {
    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(dismissOnTap: true);
      return _removeLikeItem(
        item: item,
        currentUserID: currentUserID,
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

  Future<void> _removeLikeItem({
    required Item item,
    required String currentUserID,
  }) {
    final itemRef = Item.ref.doc(item.itemID);
    final storeRef = Store.ref.doc(item.storeID);

    final writeBatch = FirebaseFirestore.instance.batch();
    writeBatch
      ..delete(Like.ref.doc('like_$currentUserID${item.itemID!}'))
      ..update(itemRef, {ItemLabels.numLikes.name: FieldValue.increment(-1)})
      ..update(storeRef, {StoreLabels.numLikes.name: FieldValue.increment(-1)});

    return writeBatch.commit();
  }

  Future<void> handleAddFavoriteItem(
    context, {
    required Item item,
    required String currentUserID,
  }) {
    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(dismissOnTap: true);
      return _addFavoriteItem(
        item: item,
        currentUserID: currentUserID,
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

  Future<void> _addFavoriteItem({
    required Item item,
    required String currentUserID,
  }) {
    final itemRef = Item.ref.doc(item.itemID);
    final storeRef = Store.ref.doc(item.storeID);

    final writeBatch = FirebaseFirestore.instance.batch();
    writeBatch
      ..set<Favorite>(
          Favorite.ref.doc('favorite_$currentUserID${item.itemID!}'),
          Favorite(
            photo: item.photoUrls?[0],
            type: VTypes.shoppingItem.name,
            uid: currentUserID,
            itemID: item.itemID,
            timestamp: FieldValue.serverTimestamp(),
          ))
      ..update(itemRef, {ItemLabels.numFavorites.name: FieldValue.increment(1)})
      ..update(storeRef, {StoreLabels.numFavorites.name: FieldValue.increment(1)});

    return writeBatch.commit();
  }

  Future<void> handleRemoveFavoriteItem(
    context, {
    required Item item,
    required String currentUserID,
  }) {
    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.dismiss(animation: true);
      EasyLoading.show(dismissOnTap: true);
      return _removeFavoriteItem(
        item: item,
        currentUserID: currentUserID,
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

  Future<void> _removeFavoriteItem({
    required Item item,
    required String currentUserID,
  }) {
    final itemRef = Item.ref.doc(item.itemID);
    final storeRef = Store.ref.doc(item.storeID);

    final writeBatch = FirebaseFirestore.instance.batch();
    writeBatch
      ..delete(Favorite.ref.doc('favorite_$currentUserID${item.itemID!}'))
      ..update(itemRef, {ItemLabels.numFavorites.name: FieldValue.increment(-1)})
      ..update(storeRef, {StoreLabels.numFavorites.name: FieldValue.increment(-1)});

    return writeBatch.commit();
  }

  Future<void> addViewItem({
    required String? photo,
    required String itemID,
    required String storeID,
    required String uid,
  }) {
    final itemRef = Item.ref.doc(itemID);
    final storeRef = Store.ref.doc(storeID);

    final writeBatch = FirebaseFirestore.instance.batch();
    writeBatch
      ..set<ViewItem>(
          ViewItem.ref.doc('view_$uid$itemID'),
          ViewItem(
            uid: uid,
            itemID: itemID,
            photo: photo,
            type: VTypes.shoppingItem.name,
            timestamp: FieldValue.serverTimestamp(),
          ))
      ..update(itemRef, {ItemLabels.numViews.name: FieldValue.increment(1)})
      ..update(storeRef, {StoreLabels.numViews.name: FieldValue.increment(1)});

    return writeBatch.commit();
  }

  Future<void> _shareShoppingItem({
    required Item item,
    required String subject,
  }) async {
    final dynamicLinks = FirebaseDynamicLinks.instance;

    final parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: 'https://fibali.page.link',
      // The deep Link passed to your application which you can use to affect change
      link: Uri(
        scheme: 'https',
        host: 'mobile-fibali.web.app',
        path: DLTypes.shoppingItem.name,
        queryParameters: item.toLinkJson(),
      ),
      // Android application details needed for opening correct app on device/Play Store
      androidParameters: const AndroidParameters(
        packageName: "com.deepdev.fibali",
        minimumVersion: 1,
      ),

      // iOS application details needed for opening correct app on device/App Store
      iosParameters: const IOSParameters(
        bundleId: "com.deepdev.fibali",
        minimumVersion: '1',
      ),

      socialMetaTagParameters: SocialMetaTagParameters(
        title: item.title,
        description: item.description,
        imageUrl: Uri.parse(item.photoUrls![0]),
      ),
    );

    final uri = await dynamicLinks.buildShortLink(parameters);
    return Share.share(uri.shortUrl.toString());
  }

  Future<void> handleShareShoppingItem(context, {required Item item}) {
    FirebaseAnalytics.instance.logShare(
      contentType: 'shopping_item',
      itemId: item.itemID!,
      method: 'unknown',
    );
    //TODO: add share post message

    EasyLoading.show(dismissOnTap: true);
    return _shareShoppingItem(
      item: item,
      subject: RCCubit.instance.getText(R.checkOutThisPost),
    ).then((value) {
      EasyLoading.dismiss(animation: true);
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
    });
  }
}
