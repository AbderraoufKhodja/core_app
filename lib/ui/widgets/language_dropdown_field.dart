import 'package:flutter/material.dart';

class LanguageDropdownField extends StatelessWidget {
  const LanguageDropdownField({
    Key? key,
    required this.items,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.hint,
    this.validator,
  }) : super(key: key);

  final List<String> items;
  final String label;
  final String hint;
  final String? value;
  final Function(String? p1)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      icon: const SizedBox(),
      decoration: InputDecoration(labelText: label),
      items: items
          .map((province) => DropdownMenuItem<String>(
                value: province,
                child: Text(province),
                // child: ListTile(title: Text(province)),
              ))
          .toList(),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return hint;
            }
            return null;
          },
    );
  }
}
