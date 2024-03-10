import 'package:ae_api/ae_api.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ae_categories_list_view_item.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/global_business/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AeCategoriesHeader extends StatefulWidget {
  const AeCategoriesHeader({super.key});

  @override
  State<AeCategoriesHeader> createState() => AeCategoriesHeaderState();
}

class AeCategoriesHeaderState extends State<AeCategoriesHeader> with TickerProviderStateMixin {
  AeBusinessCubit get _searchCubit => BlocProvider.of<AeBusinessCubit>(context);

  @override
  void initState() {
    _searchCubit.globalTabController =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  // Dispose the controller
  @override
  void dispose() {
    _searchCubit.globalTabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AeBusinessCubit, AeBusinessState>(
      buildWhen: ((previous, current) =>
          (previous is AeBusinessLoading && current is AeBusinessCategoryUpdated)),
      builder: (context, state) {
        return Row(
          children: [
            // TODO: See if there is a fix in the api for colling subcategories
            if (false)
              AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: _searchCubit.aeCategoryID != null ? 50 : 8,
                  child: _searchCubit.aeCategoryID != null
                      ? IconButton(
                          icon: AnimatedIcon(
                            icon: AnimatedIcons.arrow_menu,
                            progress: _searchCubit.globalTabController!,
                          ),
                          color: Colors.grey,
                          onPressed: () {
                            if (_searchCubit.showGlobalRail == true) {
                              _searchCubit.globalTabController!.forward();
                              setState(() {
                                _searchCubit.showGlobalRail = false;
                                _searchCubit.updateAeCategoriesWidget();
                              });
                            } else {
                              _searchCubit.globalTabController!.reverse();
                              setState(() {
                                _searchCubit.showGlobalRail = true;
                                _searchCubit.updateAeCategoriesWidget();
                              });
                            }
                          },
                        )
                      : null),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AeCategoriesListViewItem(
                    items:
                        AeCategories.parentCategories.map((e) => e['category_id'] as int).toList(),
                    // TODO: add translation
                    labels: AeCategories.parentCategories
                        .map((e) => e['category_name'] as String)
                        .toList(),
                    hint: RCCubit.instance.getText(R.addSubCategory),
                    value: _searchCubit.aeCategoryID,
                    onChanged: (value) {
                      if (value != null) {
                        if (value != _searchCubit.aeCategoryID) {
                          _searchCubit.aeCategoryID = value;
                          _searchCubit.showGlobalRail = true;
                          _searchCubit.selectedAeSubCatIndex = null;
                          _searchCubit.aeSubCategoryID = null;

                          _searchCubit.updateAeCategoriesWidget();
                          _searchCubit.resetMainCategory();
                          _searchCubit.getQueryMoreAeProducts();
                        } else {
                          _searchCubit.aeCategoryID = null;
                          _searchCubit.selectedAeSubCatIndex = null;
                          _searchCubit.aeSubCategoryID = null;

                          _searchCubit.showGlobalRail = false;
                          _searchCubit.updateAeCategoriesWidget();
                          _searchCubit.backToMain();
                        }
                      }
                    }),
              ),
            ),
          ],
        );
      },
    );
  }
}
