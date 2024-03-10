import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

class CustomListPicker extends StatefulWidget {
  final List<String> elements;
  final List<String> selectedElements;
  final String title;
  final String hint;
  final String? Function(List<String>?)? validator;
  final dynamic Function(List<String>?) onApplyButtonClick;
  final bool enableOnlySingleSelection;
  final bool hideSearchField;
  final bool hideHeader;
  final Color backgroundColor;
  final List<ControlButtonType>? controlButtons;

  const CustomListPicker({
    required this.elements,
    required this.selectedElements,
    required this.title,
    required this.hint,
    required this.onApplyButtonClick,
    required this.enableOnlySingleSelection,
    required this.hideSearchField,
    required this.hideHeader,
    required this.backgroundColor,
    this.controlButtons,
    this.validator,
  });

  @override
  State<CustomListPicker> createState() => _CustomListPickerState();
}

class _CustomListPickerState extends State<CustomListPicker> {
  late final selectedElements = widget.selectedElements;

  @override
  Widget build(BuildContext context) {
    return buildListTile(
      onTap: () => FilterListDialog.display<String>(
        context,
        listData: widget.elements,
        hideSearchField: widget.hideSearchField,
        enableOnlySingleSelection: widget.enableOnlySingleSelection,
        selectedListData: widget.selectedElements,
        backgroundColor: widget.backgroundColor,
        controlButtons: widget.controlButtons,
        hideHeader: widget.hideHeader,
        choiceChipLabel: (element) => RCCubit.instance.getCloudText(context, element ?? ''),
        applyButtonText: RCCubit.instance.getText(R.save),
        validateSelectedItem: (list, val) {
          return list?.contains(val) == true;
        },
        onItemSearch: (word, query) {
          return word.toLowerCase().contains(query.toLowerCase());
        },
        onApplyButtonClick: widget.onApplyButtonClick,
      ),
      title: widget.title,
      trailing: widget.selectedElements.isNotEmpty == true
          ? widget.selectedElements.join(' | ')
          : widget.hint,
      isEmpty: widget.selectedElements.isEmpty == true,
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
