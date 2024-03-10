import 'package:fibali/bloc/store_factory/store_factory_bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/ui/widgets/space.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

class StoreTagsListCreator extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final InputDecoration? decoration;
  final Function()? onAdd;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool enabled;

  const StoreTagsListCreator({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    required this.onAdd,
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
  State<StoreTagsListCreator> createState() => _StoreTagsListCreatorState();
}

class _StoreTagsListCreatorState extends State<StoreTagsListCreator> {
  StoreFactoryBloc get _storeFactoryBloc => BlocProvider.of<StoreFactoryBloc>(context);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildListTile(
          onTap: () => showModalBottomSheet(
            context: context,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<StoreFactoryBloc>(context),
              child: BottomFormField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                onSaved: widget.onSaved,
                decoration: widget.decoration,
                enabled: widget.enabled,
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                minLines: widget.maxLines,
                inputFormatters: widget.inputFormatters,
                onAdd: widget.onAdd,
                validator: widget.validator,
                keyboardType: widget.keyboardType,
                hint: widget.hint,
                title: widget.title,
                key: widget.key,
              ),
            ),
          ).then((value) {
            setState(() {});
          }),
          title: widget.title,
          trailing: widget.hint,
          isEmpty: true,
          validator: widget.validator,
        ),
        if (_storeFactoryBloc.keywords.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.start,
              children: _storeFactoryBloc.keywords
                  .map(
                    (label) => Chip(
                      label: Text('#$label'),
                      onDeleted: () {
                        setState(() {
                          _storeFactoryBloc.keywords.remove(label);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          )
      ],
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
            trailing: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
    required this.onAdd,
    this.validator,
    this.maxLength,
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
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final InputDecoration? decoration;
  final Function()? onAdd;
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
  StoreFactoryBloc get _storeFactoryBloc => BlocProvider.of<StoreFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Space.Y(20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Space.X(20),
            const PopButton(),
            Text(
              widget.hint,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueGrey),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                if (widget.onAdd != null) {
                  setState(() {
                    widget.onAdd?.call();
                  });
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0.0),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              ),
              child: Text(RCCubit.instance.getText(R.add)),
            ),
            const Space.X(20),
          ],
        ),
        if (_storeFactoryBloc.keywords.isNotEmpty == true)
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.start,
            children: _storeFactoryBloc.keywords
                .map((label) => Chip(
                      label: Text('#$label'),
                      onDeleted: () {
                        setState(() {
                          _storeFactoryBloc.keywords.remove(label);
                        });
                      },
                    ))
                .toList(),
          )
        else
          const Space.Y(10),
        const Divider(thickness: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: TextFormField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            enabled: widget.enabled,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            minLines: 1,
            inputFormatters: widget.inputFormatters,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
          ),
        ),
      ],
    );
  }
}
