import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    Key? key,
    required this.elements,
    required this.label,
    required this.value,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  final List<String> elements;
  final String label;
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      icon: const SizedBox(),
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      ),
      isExpanded: true,
      items: elements
          .map((province) => DropdownMenuItem<String>(
                value: province,
                child: Text(RCCubit.instance.getCloudText(context, province)),
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
