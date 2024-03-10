import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:darq/darq.dart';
import 'package:fibali/mini_apps/swap_it_app/repository/swap_search_repository.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/models/swap_item.dart';
import 'package:fibali/fibali_core/ui/pages/google_map_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import './bloc.dart';

class SwapSearchBloc extends Bloc<SwapSearchEvent, SwapSearchState> {
  final _searchRepository = SwapSearchRepository();

  bool showRail = false;
  GeoPoint? currentUserGeoPoint;
  Map<String, dynamic>? geoQueryData;
  String? geohashDocID;
  List<String>? locationHashes;
  List<SwapItemRecord>? fetchedSwapItemsRecords;
  List<SwapItemRecord>? controlSwapRecordList;
  List<SwapItem>? swapItemBatch;
  List<SwapAppreciationRecord> previousSwapAppreciations = [];
  double selectedDistance = 300;

  int? displayedItemsCount;

  bool get hasMore => controlSwapRecordList?.isNotEmpty == true;

  SwapSearchBloc() : super(SwapSearchInitialState()) {
    on<LoadSwapItemEvent>((event, emit) async {
      emit(SwapItemLoadingState());

      swapItemBatch = await _searchRepository.getSwapItems(
        swapItemsRecords: event.itemBatch,
        swapItemRecordRef: geohashDocID!,
      );

      if (swapItemBatch!.isEmpty && hasMore) {
        loadMore();
        return;
      }

      if (swapItemBatch!.isEmpty && !hasMore) {
        emit(NoSwapAroundState());
        return;
      }

      emit(SwapItemLoadedState(
        swapItems: swapItemBatch!,
      ));
    });

    on<LikeSwapItemEvent>((event, emit) async {
      previousSwapAppreciations.add(SwapAppreciationRecord(
        uid: event.selectedUserId,
        itemID: event.selectedItemId,
        timestamp: Timestamp.now(),
      ));
      // displayedSwapItems?.removeWhere((item) => item.itemID == event.selectedItemId);
      await _searchRepository.likeItem(
        currentUserId: event.currentUserId,
        selectedItemId: event.selectedItemId,
        selectedUserId: event.selectedUserId,
      );
    });

    on<SkipSwapItemEvent>((event, emit) async {
      previousSwapAppreciations.add(SwapAppreciationRecord(
        uid: event.selectedItemId,
        itemID: event.selectedItemId,
        timestamp: Timestamp.now(),
      ));
      // displayedSwapItems?.removeWhere((item) => item.itemID == event.selectedItemId);
      await _searchRepository.passItem(
        currentUserId: event.currentUserId,
        selectedItemId: event.selectedItemId,
        selectedUserId: event.selectedUserId,
      );
    });

    on<NoSwapItemsEvent>((event, emit) {
      emit(NoSwapAroundState());
    });
  }

  void rewindSwapItems({required String userID}) {
    EasyLoading.show(dismissOnTap: true);
    SwapAppreciationList.ref(userID).delete().then((value) {
      return loadingSwapItems(
        userGeopoint: currentUserGeoPoint!,
        userID: userID,
      );
    }).whenComplete(() => EasyLoading.dismiss());
  }

  void changeSwapLocation({required String userID}) async {
    final result = await showGoogleMaps();
    final geopoint = result?['geopoint'];

    if (currentUserGeoPoint is GeoPoint && geopoint is GeoPoint) {
      final selectedLocation = getGeohash(geopoint);
      final previousLocation = getGeohash(currentUserGeoPoint!);
      if (selectedLocation == previousLocation) return;
    }

    if (geopoint is GeoPoint) {
      loadingSwapItems(
        userGeopoint: geopoint,
        userID: userID,
      );
    }
  }

  String getGeohash(GeoPoint geopoint) {
    final geoQueryData = GeoFlutterFire()
        .point(
          latitude: geopoint.latitude,
          longitude: geopoint.longitude,
        )
        .dataForThreeHundredKm;
    return geoQueryData['data']?['precision4']?['block0'];
  }

  Future<void> loadingSwapItems({
    required GeoPoint userGeopoint,
    required String userID,
  }) async {
    currentUserGeoPoint = userGeopoint;
    final geoQueryData = GeoFlutterFire()
        .point(
          latitude: userGeopoint.latitude,
          longitude: userGeopoint.longitude,
        )
        .dataForThreeHundredKm;

    final docID = geoQueryData['data']?['precision4']?['block0'];
    geohashDocID = docID;
    final locationHashes = geoQueryData['data']?['precision4']?['block1'];

    try {
      await FirebaseFunctions.instance.httpsCallable('refreshListItems').call({
        'docID': docID,
        'locationHashes': locationHashes,
      });
    } catch (e) {
      // print(e);
    }

    Utils.futureDoWhile(
        func: () async {
          final futures = await Future.wait([
            _searchRepository.getSwapListItems(
              docID: docID,
              currentUserID: userID,
            ),
            _searchRepository.getSwapAppreciationList(currentUserID: userID),
          ]);

          fetchedSwapItemsRecords = futures[0] as List<SwapItemRecord>;
          previousSwapAppreciations =
              futures[1] as List<SwapAppreciationRecord>;

          controlSwapRecordList = getFilteredItems(
            fetchedSwapItemsRecords: fetchedSwapItemsRecords!,
            previousSwapAppreciations: previousSwapAppreciations,
            currentUserLocation: userGeopoint,
          );

          final itemsBatch =
              paginate(filteredSwapItemsRecords: controlSwapRecordList!);

          add(LoadSwapItemEvent(itemBatch: itemsBatch));
        },
        maxTries: null);
  }

  List<SwapItemRecord> paginate({
    required List<SwapItemRecord> filteredSwapItemsRecords,
  }) {
    final itemBatch = filteredSwapItemsRecords
        .asMap()
        .entries
        .takeWhile((entry) {
          final notEmpty = entry.key < filteredSwapItemsRecords.length;
          final lessThenThreshold = entry.key < 10;

          return notEmpty && lessThenThreshold;
        })
        .map((entry) => entry.value)
        .toList();

    filteredSwapItemsRecords.removeWhere((record) =>
        itemBatch.map((record) => record.itemID).contains(record.itemID));

    add(LoadSwapItemEvent(itemBatch: itemBatch));

    return itemBatch;
  }

  List<SwapItemRecord> loadMore() {
    final itemBatch =
        paginate(filteredSwapItemsRecords: controlSwapRecordList!);

    add(LoadSwapItemEvent(itemBatch: itemBatch));

    return itemBatch;
  }

  List<SwapItemRecord> getFilteredItems({
    required List<SwapItemRecord> fetchedSwapItemsRecords,
    required GeoPoint currentUserLocation,
    required List<SwapAppreciationRecord> previousSwapAppreciations,
  }) {
    return fetchedSwapItemsRecords
        .map((item) => item)
        .where((item) => item.isValid())
        .where((item) => !previousSwapAppreciations
            .map((appreciation) => appreciation.itemID)
            .contains(item.itemID))
        .where((item) {
      if (item.geopoint != null) {
        final result = Utils.getDistance(
          startLocation: currentUserLocation,
          endLocation: item.geopoint!,
        );

        if (result != null) {
          return result < selectedDistance;
        } else {
          return false;
        }
      }

      return false;
    }).orderBy<int>((item) {
      if (item.geopoint != null) {
        final result = Utils.getDistance(
          startLocation: currentUserLocation,
          endLocation: item.geopoint!,
        );

        return result ?? 300;
      } else {
        return 300;
      }
    }).toList();
  }

  changeSwapItemsFilter({
    required String currentUserID,
    required GeoPoint currentUserLocation,
    required double distance,
    required List<SwapItem> displayedSwapItems,
    required List<SwapAppreciationRecord> previousSwapAppreciations,
    required List<SwapItemRecord> fetchedSwapItemRecords,
  }) {
    final previousList = displayedSwapItems;

    final filteredList = fetchedSwapItemsRecords!
        .where((item) => item.isValid())
        .where((item) => !previousSwapAppreciations
            .map((appreciation) => appreciation.itemID)
            .contains(item.itemID))
        .where((item) {
      if (item.geopoint != null) {
        final result = Utils.getDistance(
          startLocation: currentUserLocation,
          endLocation: item.geopoint!,
        );

        if (result != null) {
          return result < distance;
        } else {
          return false;
        }
      }

      return false;
    }).toList();

    final canRefresh = previousList.length != filteredList.length &&
        (previousList.isNotEmpty || filteredList.isNotEmpty);

    if (canRefresh) {
      final itemBatch = paginate(filteredSwapItemsRecords: filteredList);
      add(LoadSwapItemEvent(itemBatch: itemBatch));
    }
  }
}
