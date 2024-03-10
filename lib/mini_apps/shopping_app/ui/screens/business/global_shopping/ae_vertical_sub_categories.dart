import 'package:ae_api/ae_api.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/global_business/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AeVerticalSubCategories extends StatefulWidget {
  const AeVerticalSubCategories({super.key});

  @override
  State<AeVerticalSubCategories> createState() => AeVerticalSubCategoriesState();
}

class AeVerticalSubCategoriesState extends State<AeVerticalSubCategories> {
  AeBusinessCubit get _searchCubit => BlocProvider.of<AeBusinessCubit>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AeBusinessCubit, AeBusinessState>(
      builder: (context, state) {
        return _searchCubit.showGlobalRail
            ? Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(top: 4.0),
                width: Get.width / 6,
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: AeCategories.subCategory(_searchCubit.aeCategoryID!).length,
                  itemBuilder: (context, idx) => _searchCubit.selectedAeSubCatIndex == idx
                      ? GestureDetector(
                          onTap: () {
                            _searchCubit.selectedAeSubCatIndex = null;
                            _searchCubit.aeSubCategoryID = null;

                            _searchCubit.backPrimeCategory();
                          },
                          child: Container(
                            decoration: BoxDecoration(color: Get.theme.highlightColor),
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              AeCategories.subCategory(_searchCubit.aeCategoryID!)[idx]
                                  ['category_name'] as String,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _searchCubit.selectedAeSubCatIndex = idx;
                            _searchCubit.aeSubCategoryID =
                                AeCategories.aeCategories[idx]['category_id'] as int;

                            _searchCubit.getQueryMoreAeProducts();
                          },
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.transparent),
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              AeCategories.subCategory(_searchCubit.aeCategoryID!)[idx]
                                  ['category_name'] as String,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ),
                  separatorBuilder: (context, idx) => const Divider(
                    thickness: 1,
                    height: 0,
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
