import 'package:fibali/bloc/post_factory/bloc.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_list_picker.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/fibali_core/ui/widgets/space.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

//TODO: check images picker missmatch images
class FillPostListingTabTwo extends StatefulWidget {
  const FillPostListingTabTwo({Key? key}) : super(key: key);

  @override
  FillPostListingTabTwoState createState() => FillPostListingTabTwoState();
}

class FillPostListingTabTwoState extends State<FillPostListingTabTwo>
    with AutomaticKeepAliveClientMixin<FillPostListingTabTwo> {
  final _tagsController = TextEditingController();

  List<String> tags = [];

  @override
  bool get wantKeepAlive => true;

  PostFactoryBloc get _postFactoryBloc => BlocProvider.of<PostFactoryBloc>(context);

  @override
  void dispose() {
    _tagsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    tags = _postFactoryBloc.postFromBloc.tags?.cast<String>() ?? [];
    _postFactoryBloc.postFromBloc.privacy ??= PostPrivacyType.public.name;
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
        CustomListPicker(
          elements: _postFactoryBloc.postCategories,
          selectedElements: _postFactoryBloc.postFromBloc.category != null
              ? [_postFactoryBloc.postFromBloc.category!]
              : <String>[],
          hideHeader: true,
          backgroundColor: Colors.white38,
          title: RCCubit.instance.getText(R.category),
          hint: RCCubit.instance.getText(R.addCategory),
          hideSearchField: true,
          validator: (choices) => null,
          controlButtons: const [ControlButtonType.Reset],
          enableOnlySingleSelection: true,
          onApplyButtonClick: (choices) {
            setState(
              () {
                Get.back();
                if (choices?.isNotEmpty == true) {
                  _postFactoryBloc.postFromBloc.category = choices?[0];
                } else {
                  _postFactoryBloc.postFromBloc.category = null;
                }
              },
            );
          },
        ),
        if (_postFactoryBloc.postFromBloc.category?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Chip(
              label: Text(_postFactoryBloc.postFromBloc.category!),
              onDeleted: () {
                setState(() {
                  _postFactoryBloc.postFromBloc.category = null;
                });
              },
            ),
          ),
        const PaddedDivider(hight: 0),
        WordsListCreator(
          controller: _tagsController,
          title: RCCubit.instance.getText(R.tag),
          hint: RCCubit.instance.getText(R.addTags),
          onAdd: () {
            if (_tagsController.text.isNotEmpty) {
              _postFactoryBloc.postFromBloc.tags ??= [];
              final theseTags = _tagsController.text.toLowerCase().split(' ').toList();
              _postFactoryBloc.postFromBloc.tags!.addAll(theseTags);
              _postFactoryBloc.postFromBloc.tags =
                  _postFactoryBloc.postFromBloc.tags!.toSet().toList();
              _postFactoryBloc.postFromBloc.tags?.remove('');
              _tagsController.clear();
            }
          },
        ),
      ];
}

class WordsListCreator extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hint;
  final Color textColor;
  final Color borderColor;
  final Color fillColor;
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
    this.fillColor = Colors.white,
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
  PostFactoryBloc get _postFactoryBloc => BlocProvider.of<PostFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildListTile(
          onTap: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.grey.shade100,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              minHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<PostFactoryBloc>(context),
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
                  fillColor: widget.fillColor,
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
        if (_postFactoryBloc.postFromBloc.tags?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              spacing: 10,
              alignment: WrapAlignment.start,
              children: _postFactoryBloc.postFromBloc.tags!
                  .map(
                    (label) => Chip(
                      label: Text('#' + label),
                      onDeleted: () {
                        setState(() {
                          _postFactoryBloc.postFromBloc.tags!.remove(label);
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
    this.fillColor = Colors.white,
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
  final Color fillColor;
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
  PostFactoryBloc get _postFactoryBloc => BlocProvider.of<PostFactoryBloc>(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        if (_postFactoryBloc.postFromBloc.tags?.isNotEmpty == true)
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.start,
            children: _postFactoryBloc.postFromBloc.tags!
                .map((label) => Chip(
                      label: Text('#' + label),
                      onDeleted: () {
                        setState(() {
                          _postFactoryBloc.postFromBloc.tags!.remove(label);
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
                  fillColor: widget.fillColor,
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
