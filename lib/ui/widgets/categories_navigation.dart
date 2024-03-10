import 'package:fibali/bloc/business/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CategoriesNavigation extends StatefulWidget {
  const CategoriesNavigation({super.key});

  @override
  State<CategoriesNavigation> createState() => CategoriesNavigationState();
}

class CategoriesNavigationState extends State<CategoriesNavigation> {
  BusinessCubit get _searchCubit => BlocProvider.of<BusinessCubit>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessCubit, BusinessState>(
      // buildWhen: ((previous, current) =>
      //     previous is BusinessLoading && current is BusinessCategoryUpdated),
      builder: (context, state) {
        return _searchCubit.showGlobalRail
            ? _searchCubit.categories2.isNotEmpty
                ? Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(top: 4.0),
                    width: Get.width / 6,
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: _searchCubit.categories2.length,
                      itemBuilder: (context, idx) => _searchCubit.selectedIndex == idx
                          ? GestureDetector(
                              onTap: () {
                                _searchCubit.selectedIndex = null;

                                _searchCubit.category2 = null;
                                _searchCubit.categories3 = [];
                                _searchCubit.categoriesLabels3 = [];
                                _searchCubit.category3 = null;
                                _searchCubit.categories4 = [];
                                _searchCubit.categoriesLabels4 = [];
                                _searchCubit.category4 = null;
                                _searchCubit.categories5 = [];
                                _searchCubit.categoriesLabels5 = [];
                                _searchCubit.category5 = null;
                                _searchCubit.categories6 = [];
                                _searchCubit.categoriesLabels6 = [];
                                _searchCubit.category6 = null;

                                _searchCubit.refreshSearchRef();
                              },
                              child: Container(
                                decoration: BoxDecoration(color: Get.theme.highlightColor),
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  _searchCubit.categories2[idx],
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                _searchCubit.selectedIndex = idx;

                                _searchCubit.category2 = _searchCubit.categories1[idx];
                                _searchCubit.categories3 =
                                    _searchCubit.getSubCategories(_searchCubit.categories1[idx]);
                                _searchCubit.categoriesLabels3 =
                                    _searchCubit.getSubLabelsCategories(
                                  context,
                                  value: _searchCubit.categories1[idx],
                                );
                                _searchCubit.category3 = null;
                                _searchCubit.categories4 = [];
                                _searchCubit.categoriesLabels4 = [];
                                _searchCubit.category4 = null;
                                _searchCubit.categories5 = [];
                                _searchCubit.categoriesLabels5 = [];
                                _searchCubit.category5 = null;
                                _searchCubit.categories6 = [];
                                _searchCubit.categoriesLabels6 = [];
                                _searchCubit.category6 = null;

                                _searchCubit.refreshSearchRef();
                              },
                              child: Container(
                                decoration: const BoxDecoration(color: Colors.transparent),
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  _searchCubit.categories2[idx],
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
                : const SizedBox()
            : const SizedBox();
      },
    );
  }
}
