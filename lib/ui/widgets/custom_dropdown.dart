import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    Key? key,
    required this.items,
    required this.hint,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final List<String> items;
  final String hint;
  final String? value;
  final Function(String? p1)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      isExpanded: true,
      hint: Text(hint),
      items: items
          .map(
            (province) => DropdownMenuItem<String>(
              value: province,
              child: Text(province),
            ),
          )
          .toList(),
    );
  }
}
