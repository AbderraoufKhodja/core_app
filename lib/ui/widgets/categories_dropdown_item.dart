import 'package:flutter/material.dart';

class CategoriesDropdownItem extends StatelessWidget {
  const CategoriesDropdownItem({
    Key? key,
    required this.items,
    required this.labels,
    required this.hint,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final List<String> items;
  final String hint;
  final List<String> labels;
  final String? value;
  final Function(String? p1)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      isExpanded: true,
      hint: Text(hint),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      decoration: const InputDecoration(
        fillColor: Colors.transparent,
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        hintStyle: TextStyle(color: Colors.black),
      ),
      items: items
          .map(
            (category) => DropdownMenuItem<String>(
              value: category,
              child: Text(labels[items.indexOf(category)]),
            ),
          )
          .toList(),
    );
  }
}
