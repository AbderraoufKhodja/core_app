import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/swap_factory/bloc.dart';
import 'package:fibali/ui/widgets/categories_dropdown.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/ui/widgets/space.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//TODO: check images picker missmatch images
class FillSwapListingTabTwo extends StatefulWidget {
  const FillSwapListingTabTwo({Key? key}) : super(key: key);

  @override
  FillSwapListingTabTwoState createState() => FillSwapListingTabTwoState();
}

class FillSwapListingTabTwoState extends State<FillSwapListingTabTwo>
    with AutomaticKeepAliveClientMixin<FillSwapListingTabTwo> {
  final _tagsController = TextEditingController();

  List<String> tags = [];

  @override
  bool get wantKeepAlive => true;

  SwapFactoryBloc get _swapFactoryBloc => BlocProvider.of<SwapFactoryBloc>(context);

  @override
  void dispose() {
    _tagsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    tags = _swapFactoryBloc.swapItem.tags?.cast<String>() ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  List<Widget> get widgets => <Widget>[
        WordsListCreator(
          controller: _tagsController,
          hint: RCCubit.instance.getText(R.addTags),
          title: RCCubit.instance.getText(R.tag),
          onAdd: () {
            if (_tagsController.text.isNotEmpty) {
              _swapFactoryBloc.swapItem.tags ??= [];
              final theseTags = _tagsController.text.toLowerCase().split(' ').toList();
              _swapFactoryBloc.swapItem.tags!.addAll(theseTags);
              _swapFactoryBloc.swapItem.tags = _swapFactoryBloc.swapItem.tags!.toSet().toList();
              _swapFactoryBloc.swapItem.tags?.remove('');
              _tagsController.clear();
            }
          },
        ),
        const PaddedDivider(hight: 0),
        const CategoriesDropdown(),
        if (kDebugMode) const SelectHasPrice()
      ];
}

class WordsListCreator extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final Color textColor;
  final Color borderColor;
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

  const WordsListCreator({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
    required this.onAdd,
    this.textColor = Colors.black,
    this.borderColor = Colors.grey,
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
  State<WordsListCreator> createState() => _WordsListCreatorState();
}

class _WordsListCreatorState extends State<WordsListCreator> {
  SwapFactoryBloc get _swapFactoryBloc => BlocProvider.of<SwapFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildListTile(
          onTap: () => showModalBottomSheet(
            context: context,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              minHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<SwapFactoryBloc>(context),
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  borderColor: widget.borderColor,
                  key: widget.key,
                  textColor: widget.textColor,
                ),
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
        if (_swapFactoryBloc.swapItem.tags?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.start,
              children: _swapFactoryBloc.swapItem.tags!
                  .map(
                    (label) => Chip(
                      label: Text('#' + label),
                      onDeleted: () {
                        setState(() {
                          _swapFactoryBloc.swapItem.tags!.remove(label);
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
    this.textColor = Colors.black,
    this.borderColor = Colors.grey,
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
  final Color textColor;
  final Color borderColor;
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
  SwapFactoryBloc get _swapFactoryBloc => BlocProvider.of<SwapFactoryBloc>(context);

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
            Text(widget.hint),
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
        if (_swapFactoryBloc.swapItem.tags?.isNotEmpty == true)
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.start,
            children: _swapFactoryBloc.swapItem.tags!
                .map((label) => Chip(
                      label: Text('#' + label),
                      onDeleted: () {
                        setState(() {
                          _swapFactoryBloc.swapItem.tags!.remove(label);
                        });
                      },
                    ))
                .toList(),
          )
        else
          const Space.Y(10),
        Divider(
          thickness: 1,
          color: Colors.blueGrey.withOpacity(0.2),
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
                      const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
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

class SelectHasPrice extends StatefulWidget {
  const SelectHasPrice({super.key});

  @override
  SelectHasPriceState createState() => SelectHasPriceState();
}

class SelectHasPriceState extends State<SelectHasPrice> {
  SwapFactoryBloc get swapFactoryBloc => BlocProvider.of<SwapFactoryBloc>(context);

  final _priceController = TextEditingController();

  @override
  void initState() {
    _priceController.text = swapFactoryBloc.swapItem.price?.toString() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(RCCubit.instance.getText(R.price)),
          trailing: Switch(
            value: swapFactoryBloc.swapItem.isForSale == true,
            // activeColor: swapFactoryBloc.swapItem.hasPrice == true
            //     ? Colors.amber
            //     : Colors.grey,
            // activeTrackColor: swapFactoryBloc.swapItem.hasPrice == true
            //     ? Colors.amber.shade100
            //     : Colors.grey.shade100,
            onChanged: (hasPrice) {
              if (!hasPrice) {
                swapFactoryBloc.swapItem.price = null;
              }
              swapFactoryBloc.swapItem.isForSale = hasPrice;
              setState(() {});
            },
          ),
        ),
        if (swapFactoryBloc.swapItem.isForSale == true)
          CustomTextField(
            controller: _priceController,
            hint: RCCubit.instance.getText(R.addPrice),
            title: '',
            onChanged: (value) => swapFactoryBloc.swapItem.price = num.tryParse(value),
          ),
      ],
    );
  }
}
