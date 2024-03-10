import 'package:fibali/bloc/business/bloc.dart';
import 'package:fibali/ui/widgets/categories_list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

class CategoriesHeader extends StatefulWidget {
  const CategoriesHeader({Key? key}) : super(key: key);

  @override
  State<CategoriesHeader> createState() => _CategoriesHeaderState();
}

class _CategoriesHeaderState extends State<CategoriesHeader> with TickerProviderStateMixin {
  BusinessCubit get _searchCubit => BlocProvider.of<BusinessCubit>(context);

  @override
  void initState() {
    _searchCubit.controller =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  // Dispose the controller
  @override
  void dispose() {
    _searchCubit.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessCubit, BusinessState>(
      buildWhen: ((previous, current) =>
          (previous is BusinessLoading && current is BusinessCategoryUpdated)),
      builder: (context, state) {
        return Row(
          children: [
            AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: _searchCubit.categories2.isNotEmpty ? 50 : 8,
                child: _searchCubit.categories2.isNotEmpty
                    ? IconButton(
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.arrow_menu,
                          progress: _searchCubit.controller!,
                        ),
                        color: Colors.grey,
                        onPressed: () {
                          if (_searchCubit.showGlobalRail == true) {
                            _searchCubit.controller!.forward();
                            setState(() {
                              _searchCubit.showGlobalRail = false;
                              _searchCubit.updateCategoriesWidget();
                            });
                          } else {
                            _searchCubit.controller!.reverse();
                            setState(() {
                              _searchCubit.showGlobalRail = true;
                              _searchCubit.updateCategoriesWidget();
                            });
                          }
                        },
                      )
                    : null),
            Expanded(
              child: CategoriesListViewItem(
                  items: _searchCubit.categories1,
                  labels: _searchCubit.categoriesLabels1,
                  hint: RCCubit.instance.getText(R.addSubCategory),
                  value: _searchCubit.category1,
                  onChanged: (value) {
                    if (value != null) {
                      if (value != _searchCubit.category1) {
                        _searchCubit.category1 = value;
                        _searchCubit.categories2 = _searchCubit.getSubCategories(value);
                        _searchCubit.categoriesLabels2 =
                            _searchCubit.getSubLabelsCategories(context, value: value);
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

                        _searchCubit.showGlobalRail = true;
                        _searchCubit.selectedIndex = null;
                        _searchCubit.updateCategoriesWidget();
                        _searchCubit.refreshSearchRef();
                      } else {
                        _searchCubit.category1 = null;
                        _searchCubit.categories2 = [];
                        _searchCubit.categoriesLabels2 = [];
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

                        _searchCubit.showGlobalRail = false;
                        _searchCubit.selectedIndex = null;
                        _searchCubit.updateCategoriesWidget();
                        _searchCubit.refreshSearchRef();
                      }
                    }
                  }),
            ),
          ],
        );
      },
    );
  }
}
