import 'package:currency_picker/currency_picker.dart';
import 'package:fibali/bloc/store_factory/store_factory_bloc.dart';
import 'package:fibali/fibali_core/ui/constants.dart';

import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:flutter/services.dart';

class FillStoreAddressTab extends StatefulWidget {
  const FillStoreAddressTab({super.key});

  @override
  FillStoreAddressTabState createState() => FillStoreAddressTabState();
}

class FillStoreAddressTabState extends State<FillStoreAddressTab>
    with AutomaticKeepAliveClientMixin<FillStoreAddressTab> {
  final _streetAddressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _currencyController = TextEditingController();

  StoreFactoryBloc get _storeFactory => BlocProvider.of<StoreFactoryBloc>(context);

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _streetAddressController.dispose();
    _phoneNumberController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _storeFactory.formKey3,
      child: Scaffold(
        body: ListView(children: widgets),
      ),
    );
  }

  List<Widget> get widgets => <Widget>[
        ListTile(
          title: Text(RCCubit.instance.getText(R.fillStoreLocationDescription)),
        ),
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: InternationalPhoneNumberInput(
                  countries: [CountriesIso.DZ.name],
                  onInputChanged: (PhoneNumber value) {
                    setState(() {
                      _storeFactory.phoneNumber = value.phoneNumber;
                      _storeFactory.dialCode = value.dialCode;
                      _storeFactory.country = value.isoCode;
                    });
                  },
                  validator: (value) => (_storeFactory.phoneNumber == null ||
                          _storeFactory.dialCode == null ||
                          _storeFactory.country == null)
                      ? RCCubit.instance.getText(R.checkPhone)
                      : null,
                  textFieldController: _phoneNumberController,
                  formatInput: true,
                  inputDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
              CustomTextField(
                controller: _streetAddressController,
                maxLines: 3,
                title: RCCubit.instance.getText(R.address),
                hint: RCCubit.instance.getText(R.addressHint),
                onChanged: (value) {
                  _storeFactory.streetAddress = value;
                },
                validator: (value) => _addressValidator(value),
              ),
              const PaddedDivider(hight: 0),
              CurrencyPickerField(
                controller: _currencyController,
                onChanged: (currency) {
                  _storeFactory.currency = currency.code;
                },
                title: RCCubit.instance.getText(R.currency),
                hint: RCCubit.instance.getText(R.currencyHint),
                validator: (value) => _descriptionCurrency(value),
              ),
            ],
          ),
        ),
      ];

  String? _addressValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please add the legal address of your store';
    }
    return null;
  }

  String? _descriptionCurrency(String? value) {
    if (value == null || value.isEmpty) {
      return RCCubit.instance.getText(R.pleaseAddCurrency);
    }
    return null;
  }
}

class CurrencyPickerField extends StatefulWidget {
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
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function(Currency)? onChanged;
  final bool enabled;

  const CurrencyPickerField({
    super.key,
    required this.controller,
    required this.title,
    required this.hint,
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
  State<CurrencyPickerField> createState() => _CurrencyPickerFieldState();
}

class _CurrencyPickerFieldState extends State<CurrencyPickerField> {
  @override
  Widget build(BuildContext context) {
    return buildListTile(
      onTap: () => showCurrencyPicker(
        context: context,
        onSelect: (currency) {
          if (widget.onChanged != null) {
            setState(() {
              widget.onChanged?.call(currency);
              widget.controller.text = currency.name;
            });
          }
        },
      ),
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
