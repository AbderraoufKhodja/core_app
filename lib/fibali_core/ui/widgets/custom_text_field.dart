import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/space.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final String? description;
  final Color? textColor;
  final Color? borderColor;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    this.description,
    this.textColor,
    this.borderColor,
    this.validator,
    this.maxLength,
    this.maxLines,
    this.minLines = 1,
    this.decoration,
    this.onChanged,
    this.onSaved,
    this.inputFormatters,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return buildListTile(
      onTap: () => showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          minHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BottomFormField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            description: widget.description,
            decoration: widget.decoration,
            enabled: widget.enabled,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            minLines: widget.maxLines,
            inputFormatters: widget.inputFormatters,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            hint: widget.hint,
            title: widget.title,
            borderColor: widget.borderColor,
            key: widget.key,
            textColor: widget.textColor,
          ),
        ),
      ).then((value) {
        setState(() {});
      }),
      title: widget.title,
      trailing: widget.controller.text.isNotEmpty ? widget.controller.text : widget.hint,
      isEmpty: widget.controller.text.isEmpty,
      validator: widget.validator,
    );
  }

  Widget buildListTile({
    required String title,
    required String trailing,
    bool? isEmpty,
    Function()? onTap,
    String? Function(String?)? validator,
  }) {
    return FormField(
      validator: (value) {
        if (validator != null) return validator(widget.controller.text);
        return null;
      },
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: onTap,
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: Text(title),
            trailing: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: Text(
                    trailing,
                    style: isEmpty == true ? const TextStyle(color: Colors.grey) : null,
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

class BottomFormField extends StatefulWidget {
  const BottomFormField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.title,
    this.description,
    this.textColor,
    this.borderColor,
    this.validator,
    this.maxLength = 500,
    this.maxLines,
    this.minLines,
    this.decoration,
    this.onChanged,
    this.onSaved,
    this.inputFormatters,
    this.keyboardType,
    this.enabled = true,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final String title;
  final String? description;
  final Color? textColor;
  final Color? borderColor;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool enabled;

  @override
  State<BottomFormField> createState() => _BottomFormFieldState();
}

class _BottomFormFieldState extends State<BottomFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Space.Y(20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Space.X(20),
            Text(widget.hint),
            const Spacer(),
            TextButton(
              onPressed: () {
                Get.back();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0.0),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              ),
              child: Text(RCCubit.instance.getText(R.save)),
            ),
            const Space.X(20),
          ],
        ),
        const Space.Y(10),
        Divider(
          thickness: 1,
          color: Colors.blueGrey.withOpacity(0.2),
        ),
        if (widget.description != null)
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 8,
            ),
            child: Text(
              widget.description!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: TextFormField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            decoration: widget.decoration ??
                InputDecoration(
                    labelText: widget.title,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                    floatingLabelStyle:
                        const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            enabled: widget.enabled,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            minLines: 1,
            inputFormatters: widget.inputFormatters,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
          ),
        )
      ],
    );
  }
}
