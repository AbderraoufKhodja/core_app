import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/app_user.dart';
import 'package:fibali/fibali_core/models/appreciation.dart';
import 'package:fibali/fibali_core/models/d_l_params.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/models/view_item.dart';
import 'package:fibali/mini_apps/swap_it_app/repository/swap_search_repository.dart';
import 'package:fibali/fibali_core/models/app_notification.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';

part 'swap_item_event.dart';
part 'swap_item_state.dart';

class SwapItemBloc extends Bloc<SwapItemEvent, SwapItemState> {
  final _db = FirebaseFirestore.instance;
  bool isSubmitting = false;

  SwapItemBloc() : super(SwapItemInitial()) {
    on<SwapItemEvent>((event, emit) {
      if (event is LoadSwapItem) {
        emit(SwapItemLoading());

        final swapItem = SwapItem.ref.doc(event.itemID).snapshots();

        emit(SwapItemLoaded(swapItem: BehaviorSubject()..addStream(swapItem)));
      }
    });
  }

  Future<void> addViewSwapItem(
      {required String? photo,
      required String itemID,
      required String uid,
      required SwapItem swapItem}) {
    final db = FirebaseFirestore.instance;
    final viewsRef = ViewItem.ref;
    final swapItemRef = SwapItem.ref.doc(itemID);
    final writeBatch = db.batch();
    FAC.logEvent(FAEvent.view_swap_item);

    writeBatch
      ..set<ViewItem>(
          viewsRef.doc('view_$uid$itemID'),
          ViewItem(
            uid: uid,
            itemID: itemID,
            photo: photo,
            type: VTypes.swapItem.name,
            timestamp: FieldValue.serverTimestamp(),
          ))
      ..update(swapItemRef, {SILabels.numViews.name: FieldValue.increment(1)});

    return writeBatch.commit();
  }

  Future<void> handleLikeSwapItem(
    context, {
    required SwapItem swapItem,
    required AppUser currentUser,
  }) {
    FAC.logEvent(FAEvent.like_swap_item);

    if (!isSubmitting) {
      isSubmitting = true;
      EasyLoading.show(dismissOnTap: true);
      return _likeSwapItem(
        swapItem: swapItem,
        currentUser: currentUser,
      ).then((value) {
        isSubmitting = false;
        EasyLoading.dismiss(animation: true);
      }).onError((error, stackTrace) {
        isSubmitting = false;
        EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
      });
    } else {
      EasyLoading.showInfo(RCCubit.instance.getText(R.alreadySubmitting), dismissOnTap: true);
      return Future.value(null);
    }
  }

  Future<void> _likeSwapItem({
    required SwapItem swapItem,
    required AppUser currentUser,
  }) {
    // TODO: adding friends and followers
    final writeBatch = _db.batch();
    final swapItemRef = SwapItem.ref.doc(swapItem.itemID);
    final userNotifCollection = AppNotification.ref(userID: swapItem.uid!).doc();
    final swapAppreciationListsRef = SwapAppreciationList.ref(currentUser.uid);

    final swapAppreciationList = SwapAppreciationList(
      listID: 'swapAppreciationList',
      items: [
        SwapAppreciationRecord(
          uid: swapItem.uid,
          itemID: swapItem.itemID,
          timestamp: Timestamp.now(),
        ).toFirestore(),
      ],
      timestamp: FieldValue.serverTimestamp(),
    );

    final appreciation = Appreciation(
      uid: swapItem.uid,
      itemID: swapItem.itemID,
      interestBy: currentUser.uid,
      state: ApTypes.like.name,
      timestamp: FieldValue.serverTimestamp(),
    );

    writeBatch
      ..set(swapAppreciationListsRef, swapAppreciationList, SetOptions(merge: true))
      ..set<Appreciation>(
          Appreciation.ref.doc('swap_${currentUser.uid}${swapItem.itemID!}'), appreciation)
      ..update(swapItemRef, {SILabels.numLikes.name: FieldValue.increment(1)});

    if (swapItem.uid != currentUser.uid) {
      writeBatch.set(
        userNotifCollection,
        AppNotification(
          notificationType: AppNotTypes.swap.name,
          type: SwapNotTypes.newSwapItemLike.name,
          commentType: null,
          callStatus: null,
          callID: null,
          notificationID: userNotifCollection.id,
          chatID: null,
          itemID: swapItem.itemID,
          orderID: null,
          storeID: null,
          order: null,
          item: null,
          senderItems: null,
          otherItems: null,
          location: null,
          senderName: currentUser.name,
          senderPhoto: currentUser.photoUrl,
          senderID: currentUser.uid,
          receiverID: swapItem.uid,
          isSeen: {swapItem.uid!: false},
          description: null,
          text: null,
          title: null,
          photoUrl: currentUser.photoUrl,
          timestamp: FieldValue.serverTimestamp(),
          postID: null,
          messageID: null,
        ),
      );
    }

    return writeBatch.commit();
  }

  Future<void> _shareSwapItem({
    required SwapItem swapItem,
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
        path: DLTypes.swapItem.name,
        queryParameters: swapItem.toLinkJson(),
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
        title: swapItem.ownerName,
        description: swapItem.description,
        imageUrl: Uri.parse(swapItem.photoUrls![0]),
      ),
    );

    final uri = await dynamicLinks.buildShortLink(parameters);
    return Share.share(uri.shortUrl.toString());
  }

  Future<void> handleShareSwapItem(context, {required SwapItem swapItem}) {
    //TODO: add share swapItem message
    FAC.logEvent(FAEvent.share_swap_item);

    FirebaseAnalytics.instance.logShare(
      contentType: 'share_swap_item',
      itemId: swapItem.itemID!,
      method: 'unknown',
    );

    EasyLoading.show(dismissOnTap: true);
    return _shareSwapItem(
      swapItem: swapItem,
      subject: RCCubit.instance.getText(R.checkOutThisSwapItem),
    ).then((value) {
      EasyLoading.dismiss(animation: true);
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
    });
  }
}
