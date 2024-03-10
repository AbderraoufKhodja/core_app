import 'package:fibali/mini_apps/swap_it_app/bloc/swap_factory/bloc.dart';
import 'package:filter_list/filter_list.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

//TODO: check images picker missmatch images
class FillSwapListingTabOne extends StatefulWidget {
  const FillSwapListingTabOne({Key? key}) : super(key: key);

  @override
  FillSwapListingTabOneState createState() => FillSwapListingTabOneState();
}

class FillSwapListingTabOneState extends State<FillSwapListingTabOne>
    with AutomaticKeepAliveClientMixin<FillSwapListingTabOne> {
  final _descriptionController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  SwapFactoryBloc get _swapFactoryBloc => BlocProvider.of<SwapFactoryBloc>(context);

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _descriptionController.text = _swapFactoryBloc.swapItem.description ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: widgets
          .map(
            (widget) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: widget,
            ),
          )
          .toList(),
    );
  }

  List<Widget> get widgets => <Widget>[
        CustomTextField(
          controller: _descriptionController,
          hint: RCCubit.instance.getText(R.addDescription),
          title: RCCubit.instance.getText(R.description),
          onChanged: (value) => _swapFactoryBloc.swapItem.description = value,
        ),
        // A toggle button to select if has price or not

        // const Divider(height: 0),
        // CustomListPicker(
        //   elements: _swapFactoryBloc.countries,
        //   title: RCCubit.instance.getText(R.country),
        //   hint: RCCubit.instance.getText(R.countryHint),
        //   validator: (choices) => null,
        //   enableOnlySingleSelection: true,
        //   onApplyButtonClick: (choices) {
        //     if (choices?.isNotEmpty == true) {
        //       setState(
        //         () {
        //           _swapFactoryBloc.country = choices![0];
        //         },
        //       );
        //     }
        //   },
        // ),
        // if (_swapFactoryBloc.country == 'DZ')
        //   Row(
        //     children: [
        //       Expanded(
        //         child: CustomDropdownField(
        //           validator: (value) => null,
        //           elements: _swapFactoryBloc.provinces,
        //           label: RCCubit.instance.getText(R.province),
        //           value: _swapFactoryBloc.province,
        //           onChanged: (value) {
        //             if (value != null) {
        //               setState(
        //                 () {
        //                   _swapFactoryBloc.province = value;
        //                   _swapFactoryBloc.subProvince = null;
        //                   _swapFactoryBloc.subProvinces =
        //                       AlgeriaCities.getSubProvinces(province: value);
        //                   _swapFactoryBloc.subSubProvince = null;
        //                   _swapFactoryBloc.subSubProvinces = [];
        //                 },
        //               );
        //             }
        //           },
        //         ),
        //       ),
        //       const SizedBox(width: 8),
        //       Expanded(
        //         child: CustomDropdownField(
        //             validator: (value) => null,
        //             elements: _swapFactoryBloc.subProvinces,
        //             label: RCCubit.instance.getText(R.subProvince),
        //             value: _swapFactoryBloc.subProvince,
        //             onChanged: (value) {
        //               if (value != null) {
        //                 setState(() {
        //                   _swapFactoryBloc.subProvince = value;
        //                   _swapFactoryBloc.subSubProvince = null;
        //                   _swapFactoryBloc.subSubProvinces =
        //                       AlgeriaCities.getSubSubProvinces(
        //                     subProvince: value,
        //                     province: _swapFactoryBloc.province!,
        //                   );
        //                 });
        //               }
        //             }),
        //       ),
        //       const SizedBox(width: 8),
        //       Expanded(
        //         child: CustomDropdownField(
        //             validator: (value) => null,
        //             elements: _swapFactoryBloc.subSubProvinces,
        //             label: RCCubit.instance.getText(R.subSubProvince),
        //             value: _swapFactoryBloc.subSubProvince,
        //             onChanged: (value) {
        //               if (value != null) {
        //                 setState(() {
        //                   _swapFactoryBloc.subSubProvince = value;
        //                 });
        //               }
        //             }),
        //       ),
        //     ],
        //   ),
      ];
}

class CustomListPicker extends StatefulWidget {
  final List<String> elements;
  final String title;
  final String hint;
  final String? Function(List<String>?)? validator;
  final dynamic Function(List<String>?) onApplyButtonClick;
  final bool enableOnlySingleSelection;

  const CustomListPicker({
    super.key,
    required this.elements,
    required this.title,
    required this.hint,
    required this.onApplyButtonClick,
    required this.enableOnlySingleSelection,
    this.validator,
  });

  @override
  State<CustomListPicker> createState() => _CustomListPickerState();
}

class _CustomListPickerState extends State<CustomListPicker> {
  final selectedElements = <String>[];

  @override
  Widget build(BuildContext context) {
    return buildListTile(
      onTap: () => FilterListDialog.display<String>(
        context,
        listData: widget.elements,
        enableOnlySingleSelection: widget.enableOnlySingleSelection,
        selectedListData: selectedElements,
        choiceChipLabel: (element) => RCCubit.instance.getCloudText(context, element ?? ''),
        validateSelectedItem: (list, val) => list?.contains(val) == true,
        onItemSearch: (category, query) {
          if (category.toLowerCase() == query.toLowerCase()) return true;
          return false;
        },
        onApplyButtonClick: widget.onApplyButtonClick,
      ).then((value) {
        setState(() {});
      }),
      title: widget.title,
      trailing: selectedElements.isNotEmpty == true ? selectedElements.join(' | ') : widget.hint,
      isEmpty: selectedElements.isEmpty == true,
      validator: widget.validator,
    );
  }

  Widget buildListTile({
    required String title,
    required String trailing,
    Function()? onTap,
    bool? isEmpty,
    String? Function(List<String>?)? validator,
  }) {
    return FormField(
      validator: (value) {
        if (validator != null) return validator(selectedElements);
        return null;
      },
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: onTap,
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: Text(title),
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                      child: Text(
                    trailing,
                    style: const TextStyle(color: Colors.grey),
                  )),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  )
                ],
              ),
            ),
          ),
          if (field.hasError)
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                field.errorText ?? '',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            )
        ],
      ),
    );
  }
}
