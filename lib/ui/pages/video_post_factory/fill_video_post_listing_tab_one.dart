import 'package:fibali/bloc/video_post_factory/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

//TODO: check images picker missmatch images
class FillVideoPostListingTabOne extends StatefulWidget {
  const FillVideoPostListingTabOne({Key? key}) : super(key: key);

  @override
  FillVideoPostListingTabOneState createState() => FillVideoPostListingTabOneState();
}

class FillVideoPostListingTabOneState extends State<FillVideoPostListingTabOne>
    with AutomaticKeepAliveClientMixin<FillVideoPostListingTabOne> {
  final _descriptionController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  VideoPostFactoryBloc get _videoPostFactoryBloc => BlocProvider.of<VideoPostFactoryBloc>(context);

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _descriptionController.text = _videoPostFactoryBloc.post.description ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: widgets,
    );
  }

  List<Widget> get widgets => <Widget>[
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Text(RCCubit.instance.getText(R.whoCanMyPost), style: Get.textTheme.bodyLarge),
            )),
            const Spacer(),
            Flexible(
              child: CustomDropdownField(
                elements: PostPrivacyType.values.map((privacy) => privacy.name).toList(),
                value: _videoPostFactoryBloc.post.privacy ?? PostPrivacyType.public.name,
                onChanged: (value) {
                  if (value != null) {
                    setState(
                      () {
                        _videoPostFactoryBloc.post.privacy = value;
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        CustomTextField(
          controller: _descriptionController,
          hint: RCCubit.instance.getText(R.addDescription),
          title: RCCubit.instance.getText(R.description),
          onChanged: (value) => _videoPostFactoryBloc.post.description = value,
        ),
        const PaddedDivider(hight: 0),
        // const Divider(height: 0),
        // CustomListPicker(
        //   elements: _postFactoryBloc.countries,
        //   title: RCCubit.instance.getText(R.country),
        //   hint: RCCubit.instance.getText(R.countryHint),
        //   validator: (choices) => null,
        //   enableOnlySingleSelection: true,
        //   onApplyButtonClick: (choices) {
        //     if (choices?.isNotEmpty == true) {
        //       setState(
        //         () {
        //           _postFactoryBloc.country = choices![0];
        //         },
        //       );
        //     }
        //   },
        // ),
        // if (_postFactoryBloc.country == 'DZ')
        //   Row(
        //     children: [
        //       Expanded(
        //         child: CustomDropdownField(
        //           validator: (value) => null,
        //           elements: _postFactoryBloc.provinces,
        //           label: RCCubit.instance.getText(R.province),
        //           value: _postFactoryBloc.province,
        //           onChanged: (value) {
        //             if (value != null) {
        //               setState(
        //                 () {
        //                   _postFactoryBloc.province = value;

        //                   _postFactoryBloc.subProvince = null;
        //                   _postFactoryBloc.subProvinces =
        //                       AlgeriaCities.getSubProvinces(province: value);
        //                   _postFactoryBloc.subSubProvince = null;
        //                   _postFactoryBloc.subSubProvinces = [];
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
        //             elements: _postFactoryBloc.subProvinces,
        //             label: RCCubit.instance.getText(R.subProvince),
        //             value: _postFactoryBloc.subProvince,
        //             onChanged: (value) {
        //               if (value != null) {
        //                 setState(() {
        //                   _postFactoryBloc.subProvince = value;

        //                   _postFactoryBloc.subSubProvince = null;
        //                   _postFactoryBloc.subSubProvinces =
        //                       AlgeriaCities.getSubSubProvinces(
        //                     subProvince: value,
        //                     province: _postFactoryBloc.province!,
        //                   );
        //                 });
        //               }
        //             }),
        //       ),
        //       const SizedBox(width: 8),
        //       Expanded(
        //         child: CustomDropdownField(
        //             validator: (value) => null,
        //             elements: _postFactoryBloc.subSubProvinces,
        //             label: RCCubit.instance.getText(R.subSubProvince),
        //             value: _postFactoryBloc.subSubProvince,
        //             onChanged: (value) {
        //               if (value != null) {
        //                 setState(() {
        //                   _postFactoryBloc.subSubProvince = value;
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

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.elements,
    this.label,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  final List<String> elements;
  final String? label;
  final String? value;
  final Function(String? p1)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      alignment: Alignment.centerRight,
      style: GoogleFonts.fredokaOne(color: Colors.grey),
      decoration: InputDecoration(
        labelText: label,
        fillColor: Colors.transparent,
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      items: elements
          .map((province) => DropdownMenuItem<String>(
                value: province,
                child: Text(province),
              ))
          .toList(),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please choose a field';
            }
            return null;
          },
    );
  }
}
