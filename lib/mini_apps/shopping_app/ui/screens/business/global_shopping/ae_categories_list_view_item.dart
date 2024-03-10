import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';

class AeCategoriesListViewItem extends StatelessWidget {
  const AeCategoriesListViewItem({
    super.key,
    required this.items,
    required this.labels,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.direction,
    this.choiceStyle,
    this.choiceActiveStyle,
  });

  final List<int> items;
  final String hint;
  final List<String> labels;
  final int? value;
  final Function(int? p1) onChanged;
  final Axis? direction;
  final C2ChipStyle? choiceStyle;
  final C2ChipStyle? choiceActiveStyle;

  @override
  Widget build(BuildContext context) {
    return ChipsChoice<int?>.single(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      direction: direction ?? Axis.horizontal,
      padding: const EdgeInsets.all(0),
      choiceStyle: choiceStyle ??
          C2ChipStyle.outlined(
            color: Colors.grey,
            selectedStyle: C2ChipStyle.filled(
              color: Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.symmetric(horizontal: 1),
            ),
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.symmetric(horizontal: 1),
          ),
      value: value,
      onChanged: onChanged,
      choiceItems: items
          .map(
            (category) => C2Choice<int>(
              label: labels[items.indexOf(category)],
              value: category,
            ),
          )
          .toList(),
    );
  }
}
