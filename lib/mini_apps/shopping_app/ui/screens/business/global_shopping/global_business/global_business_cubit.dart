import 'package:ae_api/ae_api.dart';
import 'package:ae_api/ds_api.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/repository/ae.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'bloc.dart';

class AeBusinessCubit extends Cubit<AeBusinessState> {
  AeBusinessCubit() : super(AeBusinessInitial());

  static AeBusinessCubit get instance => BlocProvider.of<AeBusinessCubit>(Get.context!);

  final _analytics = FirebaseAnalytics.instance;

  final textController = TextEditingController();

  List<Product> displayedProducts = <Product>[];

  String? sortedBy;
  String? countryCode;

  final mainProducts = <Product>[];
  bool hasMore = true;
  int pageNumber = 1;

  final query1Products = <Product>[];
  bool query1HasMore = true;
  int query1PageNumber = 1;

  final query2Products = <Product>[];
  bool query2HasMore = true;
  int query2PageNumber = 1;

  bool isDecending = true;
  bool? teamChoice;
  bool showGlobalRail = false;

  int? selectedAeSubCatIndex;

  AnimationController? globalTabController;

  int? aeCategoryID;
  int? aeSubCategoryID;

  int? get getCategory => aeSubCategoryID ?? aeCategoryID;

  final targetCurrency = SettingsCubit.instance.state.appCountry;
  final targetCountry = SettingsCubit.instance.state.currency;
  final targetLanguage = SettingsCubit.instance.state.appLanguage;

  Future<HotProductsResponse> getHotProducts() {
    return AeRepository.getHotProducts(HotProductRequestParams(
      keywords: 'hot products',
      pageSize: '10',
      sort: 'LAST_VOLUME_DESC',
      targetCurrency: targetCurrency,
      targetLanguage: targetLanguage,
    ));
  }

  Future<AeDSProductGetResponse> getProductInfo(ProductInfoQuery infoQuery) {
    return AeRepository.getProductInfo(infoQuery);
  }

  Future<FeaturedPromoResponse> getFeaturedPromos() {
    return AeRepository.getFeaturedPromos();
  }

  Future<FeaturedPromoProductsResponse> getFeaturedPromoProducts(
      FeaturedPromoProductsRequestParams params) {
    return AeRepository.getFeaturedPromoProducts(params);
  }

  void getMainMoreAeProducts() async {
    emit(AeBusinessLoading());
    try {
      pageNumber += 1;
      final response = await AeRepository.getRecommendedFeed(
        pageNo: pageNumber.toString(),
        targetCurrency: targetCurrency,
        targetLanguage: targetLanguage,
      );

      if (response.result.products?.isNotEmpty == false) {
        hasMore = false;
      }

      if (response.result.products?.isNotEmpty == true) {
        mainProducts.addAll(response.result.products!);
      } else {
        EasyLoading.showInfo(RCCubit.getT(R.noMoreProducts));
      }

      displayedProducts = List.from(mainProducts);
      emit(AeMainProductsLoaded());
    } catch (e) {
      emit(AeBusinessError(message: e.toString()));
    }
  }

  void initGetMainAeProducts() async {
    emit(AeBusinessLoading());
    try {
      final response = await AeRepository.getRecommendedFeed(
        targetCurrency: targetCurrency,
        targetLanguage: targetLanguage,
      );

      if (response.result.products?.isNotEmpty == false) {
        hasMore = false;
      }

      if (response.result.products?.isNotEmpty == true) {
        mainProducts.addAll(response.result.products!);
      } else {
        EasyLoading.showInfo(RCCubit.getT(R.noMoreProducts));
      }

      displayedProducts = List.from(mainProducts);
      emit(AeMainProductsLoaded());
    } catch (e) {
      emit(AeBusinessError(message: e.toString()));
    }
  }

  void backToMain() async {
    emit(AeBusinessLoading());

    displayedProducts = List.from(mainProducts);
    emit(AeMainProductsLoaded());
  }

  void backPrimeCategory() async {
    emit(AeBusinessLoading());

    displayedProducts = List.from(query1Products);
    emit(AeQueryProductsLoaded());
  }

  void getQueryMoreAeProducts() async {
    emit(AeBusinessLoading());
    try {
      query1PageNumber += 1;
      final response = await AeRepository.getRecommendedFeed(
        categoryId: getCategory?.toString(),
        pageNo: query1PageNumber.toString(),
        targetCurrency: targetCurrency,
        targetLanguage: targetLanguage,
      );

      if (response.result.products?.isNotEmpty == false) {
        query1HasMore = false;
      }

      if (response.result.products?.isNotEmpty == true) {
        query1Products.addAll(response.result.products!);
      } else {
        EasyLoading.showInfo(RCCubit.getT(R.noMoreProducts));
      }

      displayedProducts = List.from(query1Products);
      emit(AeQueryProductsLoaded());
    } catch (e) {
      debugPrint(e.toString());
      emit(AeBusinessError(message: e.toString()));
    }
  }

  void initGetQueryAeProducts() async {
    emit(AeBusinessLoading());
    try {
      final response = await AeRepository.getRecommendedFeed(
        categoryId: getCategory?.toString(),
        targetCurrency: targetCurrency,
        targetLanguage: targetLanguage,
      );

      if (response.result.products?.isNotEmpty == false) {
        hasMore = false;
      }

      if (response.result.products?.isNotEmpty == false) {
        query1Products.addAll(response.result.products!);
      } else {
        EasyLoading.showInfo(RCCubit.getT(R.noMoreProducts));
      }

      displayedProducts = List.from(query1Products);
      emit(AeQueryProductsLoaded());
    } catch (e) {
      emit(AeBusinessError(message: e.toString()));
    }
  }

  void resetAeFilters() {
    sortedBy = null;
    isDecending = true;
    teamChoice = false;
  }

  void updateAeCategoriesWidget() {
    emit(AeBusinessLoading());
    emit(AeBusinessCategoryUpdated());
  }

  void resetMainCategory() {
    query1Products.removeWhere((element) => true);
    query1HasMore = true;
    query1PageNumber = 1;
  }
}
