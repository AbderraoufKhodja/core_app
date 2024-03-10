import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.elements,
    required this.label,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  final List<String> elements;
  final String label;
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
