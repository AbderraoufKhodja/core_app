import 'package:fibali/bloc/item_factory/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/item.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/ui/widgets/padded_left_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class ReturnPolicyItemFormTab extends StatefulWidget {
  const ReturnPolicyItemFormTab({super.key});

  @override
  ReturnPolicyItemFormTabState createState() => ReturnPolicyItemFormTabState();
}

class ReturnPolicyItemFormTabState extends State<ReturnPolicyItemFormTab>
    with AutomaticKeepAliveClientMixin<ReturnPolicyItemFormTab> {
  @override
  bool get wantKeepAlive => true;

  ItemFactoryBloc get _itemFactoryBloc => BlocProvider.of<ItemFactoryBloc>(context);

  ReturnTimeFrame? get _returnTimeFrame =>
      Utils.enumFromString(ReturnTimeFrame.values, timeFrameDropDown);

  ReturnPolicy? get getItemReturnPolicy {
    if (_itemFactoryBloc.item.returnPolicy != null) {
      return _itemFactoryBloc.item.returnPolicy;
    } else {
      return null;
    }
  }

  Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>> get formFields =>
      _itemFactoryBloc.formKey6.currentState!.fields;
  String? get timeFrameDropDown => formFields[_FFNames.timeFrameDropDown.name]?.value as String?;
  List<String?>? get conditionsCG =>
      formFields[_FFNames.conditionsCG.name]?.value as List<String?>?;
  List<String?>? get returnOptionsCG =>
      formFields[_FFNames.returnOptionsCG.name]?.value as List<String?>?;
  String? get inStoreReturnsAddressTF =>
      formFields[_FFNames.inStoreReturnsAddressTF.name]?.value as String?;
  String? get mailReturnsAddressTF =>
      formFields[_FFNames.mailReturnsAddressTF.name]?.value as String?;
  String? get mailReturnsShippingFeeBearerCC =>
      formFields[_FFNames.mailReturnsShippingFeeBearerCC.name]?.value as String?;
  String? get homeOfficePickupReturnsFeeBearerCC =>
      formFields[_FFNames.homeOfficePickupReturnsFeeBearerCC.name]?.value as String?;
  bool? get acceptExchangeSwitch => formFields[_FFNames.acceptExchangeSwitch.name]?.value as bool?;
  List<String?>? get exchangeOptionsCG =>
      formFields[_FFNames.exchangeOptionsCG.name]?.value as List<String?>?;
  String? get inStoreExchangesAddressTF =>
      formFields[_FFNames.inStoreExchangesAddressTF.name]?.value as String?;
  String? get mailExchangesAddressTF =>
      formFields[_FFNames.mailExchangesAddressTF.name]?.value as String?;
  List<String?>? get mailExchangesFeeBearerCC =>
      formFields[_FFNames.mailExchangesFeeBearerChoiceChip.name]?.value as List<String?>?;
  List<String?>? get homeOfficePickupExchangesFeeBearerCC =>
      formFields[_FFNames.homeOfficePickupExchangesFeeBearerCC.name]?.value as List<String?>?;

  @override
  void initState() {
    super.initState();
    _itemFactoryBloc.item.returnPolicy ??= ReturnPolicy.empty();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        _itemFactoryBloc.formKey6.currentState!.fields[_FFNames.timeFrameDropDown.name]?.value;
        _itemFactoryBloc.formKey6.currentState!.fields.forEach((key, value) {
          print('$key: ${value.value}');
        });
      }),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            title: Text(
              RCCubit.instance.getText(R.returnPolicy),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(RCCubit.instance.getText(R.returnPolicyDescription)),
            dense: true,
          ),
          FormBuilderDropdown<String>(
            name: _FFNames.timeFrameDropDown.name,
            decoration: InputDecoration(
              hintText: RCCubit.instance.getText(R.chooseReturnTimeFrame),
              contentPadding: const EdgeInsets.all(12.0),
            ),
            items: [
              R.sevenDayReturnPolicy,
              R.fourteenDayReturnPolicy,
              R.thirtyDayReturnPolicy,
              R.sixtyDayReturnPolicy,
              R.ninetyDayReturnPolicy,
              R.noReturnPolicy,
            ]
                .map((e) => DropdownMenuItem<String>(
                      value: e.name,
                      child: Text(RCCubit.instance.getText(e)),
                    ))
                .toList(),
            onChanged: (String? value) {
              setState(() {});
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
          if (_returnTimeFrame != null && _returnTimeFrame != ReturnTimeFrame.noReturnPolicy)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child:
                      Text(getPolicyDescription(_returnTimeFrame!), style: Get.textTheme.bodySmall),
                ),
                _buildConditions(),
                _buildReturnsOptions(),
                FormBuilderSwitch(
                  name: _FFNames.acceptExchangeSwitch.name,
                  title: ListTile(
                    title: Text(RCCubit.instance.getText(R.acceptExchange),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: acceptExchangeSwitch == true
                        ? Text(RCCubit.instance.getText(R.acceptExchangeDescription))
                        : null,
                    dense: true,
                  ),
                  initialValue: acceptExchangeSwitch,
                  decoration: const InputDecoration(
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.all(0.0),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                if (acceptExchangeSwitch == true) _buildExchangesOptions(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildExchangesOptions() {
    final initialExchangeOptions = [
      if (_itemFactoryBloc.item.returnPolicy!.exchangeOptions?.inStoreExchanges?.isAvailable ==
          true)
        R.inStoreExchanges.name,
      if (_itemFactoryBloc.item.returnPolicy!.exchangeOptions?.mailExchanges?.isAvailable == true)
        R.mailExchanges.name,
      if (_itemFactoryBloc
              .item.returnPolicy!.exchangeOptions?.homeOfficePickupExchanges?.isAvailable ==
          true)
        R.homeOfficeExchanges.name,
    ];

    return PaddedLeftBar(
      space: 0,
      child: Column(
        children: [
          FormBuilderCheckboxGroup<String?>(
            decoration: const InputDecoration(
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.all(0.0),
            ),
            name: _FFNames.exchangeOptionsCG.name,
            initialValue: initialExchangeOptions,
            onChanged: (value) {
              setState(() {});
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(1),
            ]),
            options: [
              _buildInStoreExchangesOption(),
              _buildMailExchangesOption(),
              _buildHomeOfficeExchangesOption(),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildReturnsOptions() {
    final initialReturnOptions = [
      if (_itemFactoryBloc.item.returnPolicy!.returnOptions?.inStoreReturns?.isAvailable == true)
        R.inStoreReturns.name,
      if (_itemFactoryBloc.item.returnPolicy!.returnOptions?.mailReturns?.isAvailable == true)
        R.mailReturns.name,
      if (_itemFactoryBloc.item.returnPolicy!.returnOptions?.homeOfficePickupReturns?.isAvailable ==
          true)
        R.homeOfficePickup.name,
    ];

    return Column(
      children: [
        ListTile(
          title: Text(RCCubit.instance.getText(R.returnOptions),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(RCCubit.instance.getText(R.returnOptionsDescription)),
          dense: true,
        ),
        PaddedLeftBar(
          space: 0,
          child: Column(
            children: [
              FormBuilderCheckboxGroup<String?>(
                decoration: const InputDecoration(
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.all(0.0),
                ),
                name: _FFNames.returnOptionsCG.name,
                initialValue: initialReturnOptions,
                onChanged: (value) {
                  setState(() {});
                },
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(1),
                ]),
                options: [
                  _buildInStoreReturnsOption(),
                  _buildMailReturnsOption(),
                  _buildHomeOfficePickupsOption(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  FormBuilderFieldOption<String?> _buildInStoreExchangesOption() {
    return FormBuilderFieldOption(
        value: R.inStoreExchanges.name,
        child: Column(children: [
          _buildCheckBoxTile({R.inStoreExchanges, R.inStoreExchangesSellerDescription}),
          if (exchangeOptionsCG?.contains(R.inStoreExchanges.name) == true)
            PaddedLeftBar(
              width: 2.0,
              padding: const EdgeInsets.only(left: 16.0),
              child: FormBuilderTextField(
                name: _FFNames.inStoreExchangesAddressTF.name,
                decoration: const InputDecoration(
                  labelText: 'Store address',
                  contentPadding: EdgeInsets.all(4.0),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
            )
        ]));
  }

  FormBuilderFieldOption<String?> _buildMailExchangesOption() {
    return FormBuilderFieldOption(
        value: R.mailExchanges.name,
        child: Column(children: [
          _buildCheckBoxTile({R.mailExchanges, R.mailExchangesSellerDescription}),
          if (exchangeOptionsCG?.contains(R.mailExchanges.name) == true)
            PaddedLeftBar(
                width: 2.0,
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(children: [
                  FormBuilderTextField(
                    name: _FFNames.mailExchangesAddressTF.name,
                    decoration: const InputDecoration(
                      labelText: 'Mail address',
                      contentPadding: EdgeInsets.all(4.0),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const Gap(8.0),
                  FormBuilderChoiceChip<String>(
                      name: _FFNames.mailExchangesFeeBearerChoiceChip.name,
                      spacing: 8.0,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(0.0),
                        fillColor: Colors.transparent,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(1),
                      ]),
                      options: [
                        FormBuilderChipOption(
                          value: 'seller',
                          child: Text(RCCubit.instance.getText(R.seller)),
                        ),
                        FormBuilderChipOption(
                          value: 'client',
                          child: Text(RCCubit.instance.getText(R.client)),
                        ),
                        FormBuilderChipOption(
                          value: 'shared',
                          child: Text(RCCubit.instance.getText(R.shared)),
                        ),
                      ]),
                  if (_itemFactoryBloc
                          .item.returnPolicy!.exchangeOptions!.mailExchanges?.feeBearer ==
                      'seller')
                    Text(
                      style: Get.textTheme.bodySmall,
                      RCCubit.instance.getText(R.sellerPaysForExchangeShippingFee),
                    ),
                  if (_itemFactoryBloc
                          .item.returnPolicy!.exchangeOptions!.mailExchanges?.feeBearer ==
                      'client')
                    Text(
                        style: Get.textTheme.bodySmall,
                        RCCubit.instance.getText(R.clientPaysForExchangeShippingFee)),
                  if (_itemFactoryBloc
                          .item.returnPolicy!.exchangeOptions!.mailExchanges?.feeBearer ==
                      'shared')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SegmentedButton<num>(
                          emptySelectionAllowed: false,
                          multiSelectionEnabled: false,
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          onSelectionChanged: (Set<num?> selection) {
                            setState(() {
                              _itemFactoryBloc.item.returnPolicy!.exchangeOptions!.mailExchanges!
                                  .percentage = selection.first;
                            });
                          },
                          segments: const [30, 50, 70]
                              .map((e) => ButtonSegment<num>(
                                    value: e,
                                    label: Text('$e%'),
                                  ))
                              .toList(),
                          selected: {
                            if (_itemFactoryBloc.item.returnPolicy!.exchangeOptions!.mailExchanges!
                                    .percentage !=
                                null)
                              _itemFactoryBloc
                                  .item.returnPolicy!.exchangeOptions!.mailExchanges!.percentage!
                          },
                        ),
                        Text(
                            style: Get.textTheme.bodySmall,
                            '${_itemFactoryBloc.item.returnPolicy!.exchangeOptions!.mailExchanges!.percentage?.toInt()}% ${RCCubit.instance.getText(R.sharedPaymentForExchangeShippingFee)}'),
                      ],
                    ),
                ]))
        ]));
  }

  FormBuilderFieldOption<String?> _buildHomeOfficeExchangesOption() {
    return FormBuilderFieldOption(
        value: R.homeOfficeExchanges.name,
        child: Column(children: [
          _buildCheckBoxTile({R.homeOfficeExchanges, R.homeOfficeExchangesSellerDescription}),
          if (_itemFactoryBloc
                  .item.returnPolicy!.exchangeOptions?.homeOfficePickupExchanges?.isAvailable ==
              true)
            PaddedLeftBar(
              width: 2.0,
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(children: [
                FormBuilderChoiceChip<String>(
                    name: _FFNames.homeOfficePickupExchangesFeeBearerCC.name,
                    spacing: 8.0,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(0.0),
                      fillColor: Colors.transparent,
                    ),
                    onChanged: (value) {},
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(1),
                    ]),
                    options: [
                      FormBuilderChipOption(
                        value: 'seller',
                        child: Text(RCCubit.instance.getText(R.seller)),
                      ),
                      FormBuilderChipOption(
                        value: 'client',
                        child: Text(RCCubit.instance.getText(R.client)),
                      ),
                      FormBuilderChipOption(
                        value: 'shared',
                        child: Text(RCCubit.instance.getText(R.shared)),
                      ),
                    ]),
                if (_itemFactoryBloc
                        .item.returnPolicy!.exchangeOptions!.homeOfficePickupExchanges?.feeBearer ==
                    'seller')
                  Text(
                      style: Get.textTheme.bodySmall,
                      RCCubit.instance.getText(R.sellerPaysForExchangeShippingFee)),
                if (_itemFactoryBloc
                        .item.returnPolicy!.exchangeOptions!.homeOfficePickupExchanges?.feeBearer ==
                    'client')
                  Text(
                      style: Get.textTheme.bodySmall,
                      RCCubit.instance.getText(R.clientPaysForExchangeShippingFee)),
                if (_itemFactoryBloc
                        .item.returnPolicy!.exchangeOptions!.homeOfficePickupExchanges?.feeBearer ==
                    'shared')
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SegmentedButton<num>(
                      emptySelectionAllowed: false,
                      multiSelectionEnabled: false,
                      showSelectedIcon: false,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      onSelectionChanged: (Set<num?> selection) {
                        setState(() {
                          _itemFactoryBloc.item.returnPolicy!.exchangeOptions!
                              .homeOfficePickupExchanges!.percentage = selection.first;
                        });
                      },
                      segments: const [30, 50, 70]
                          .map((e) => ButtonSegment<num>(
                                value: e,
                                label: Text('$e%'),
                              ))
                          .toList(),
                      selected: {
                        if (_itemFactoryBloc.item.returnPolicy!.exchangeOptions!
                                .homeOfficePickupExchanges!.percentage !=
                            null)
                          _itemFactoryBloc.item.returnPolicy!.exchangeOptions!
                              .homeOfficePickupExchanges!.percentage!
                      },
                    ),
                    Text(
                        style: Get.textTheme.bodySmall,
                        '${_itemFactoryBloc.item.returnPolicy!.exchangeOptions!.homeOfficePickupExchanges!.percentage?.toInt()}% ${RCCubit.instance.getText(R.sharedPaymentForExchangeShippingFee)}'),
                  ])
              ]),
            )
        ]));
  }

  FormBuilderFieldOption<String?> _buildHomeOfficePickupsOption() {
    return FormBuilderFieldOption(
      value: R.homeOfficePickup.name,
      child: Column(
        children: [
          _buildCheckBoxTile({R.homeOfficePickup, R.homeOfficePickupSellerDescription}),
          if (_itemFactoryBloc
                  .item.returnPolicy!.returnOptions?.homeOfficePickupReturns?.isAvailable ==
              true)
            PaddedLeftBar(
              width: 2.0,
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                children: [
                  FormBuilderChoiceChip<String>(
                    name: _FFNames.homeOfficePickupReturnsFeeBearerCC.name,
                    spacing: 8.0,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(0.0),
                      fillColor: Colors.transparent,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(1),
                    ]),
                    options: [
                      FormBuilderChipOption(
                        value: 'seller',
                        child: Text(RCCubit.instance.getText(R.seller)),
                      ),
                      FormBuilderChipOption(
                        value: 'client',
                        child: Text(RCCubit.instance.getText(R.client)),
                      ),
                      FormBuilderChipOption(
                        value: 'shared',
                        child: Text(RCCubit.instance.getText(R.shared)),
                      ),
                    ],
                  ),
                  if (_itemFactoryBloc
                          .item.returnPolicy!.returnOptions!.homeOfficePickupReturns?.feeBearer ==
                      'seller')
                    Text(
                      RCCubit.instance.getText(R.sellerPaysForExchangeShippingFee),
                      style: Get.textTheme.bodySmall,
                    ),
                  if (_itemFactoryBloc
                          .item.returnPolicy!.returnOptions!.homeOfficePickupReturns?.feeBearer ==
                      'client')
                    Text(
                        style: Get.textTheme.bodySmall,
                        RCCubit.instance.getText(R.clientPaysForExchangeShippingFee)),
                  if (_itemFactoryBloc
                          .item.returnPolicy!.returnOptions?.homeOfficePickupReturns?.feeBearer ==
                      'shared')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SegmentedButton<num>(
                          emptySelectionAllowed: false,
                          multiSelectionEnabled: false,
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          onSelectionChanged: (Set<num?> selection) {
                            setState(() {
                              _itemFactoryBloc.item.returnPolicy!.returnOptions!
                                  .homeOfficePickupReturns!.percentage = selection.first;
                            });
                          },
                          segments: const [30, 50, 70]
                              .map((e) => ButtonSegment<num>(
                                    value: e,
                                    label: Text('$e%'),
                                  ))
                              .toList(),
                          selected: {
                            if (_itemFactoryBloc.item.returnPolicy!.returnOptions!
                                    .homeOfficePickupReturns!.percentage !=
                                null)
                              _itemFactoryBloc.item.returnPolicy!.returnOptions!
                                  .homeOfficePickupReturns!.percentage!
                          },
                        ),
                        Text(
                            style: Get.textTheme.bodySmall,
                            '${_itemFactoryBloc.item.returnPolicy!.returnOptions!.homeOfficePickupReturns!.percentage?.toInt()}% ${RCCubit.instance.getText(R.sharedPaymentForExchangeShippingFee)}'),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  FormBuilderFieldOption<String?> _buildMailReturnsOption() {
    return FormBuilderFieldOption(
      value: R.mailReturns.name,
      child: Column(
        children: [
          _buildCheckBoxTile({R.mailReturns, R.mailReturnsSellerDescription}),
          if (returnOptionsCG?.contains(R.mailReturns.name) == true)
            PaddedLeftBar(
              width: 2.0,
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: _FFNames.mailReturnsAddressTF.name,
                    decoration: const InputDecoration(
                      labelText: 'Mail address',
                      contentPadding: EdgeInsets.all(4.0),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const Gap(8.0),
                  FormBuilderChoiceChip<String>(
                      name: _FFNames.mailReturnsShippingFeeBearerCC.name,
                      spacing: 8.0,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(0.0),
                        fillColor: Colors.transparent,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _itemFactoryBloc
                              .item.returnPolicy!.returnOptions!.mailReturns!.feeBearer = value;
                          if (value == 'shared' &&
                              _itemFactoryBloc
                                      .item.returnPolicy!.returnOptions!.mailReturns!.percentage ==
                                  null) {
                            _itemFactoryBloc
                                .item.returnPolicy!.returnOptions!.mailReturns!.percentage = 50;
                          }
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(1),
                      ]),
                      options: [
                        FormBuilderChipOption(
                          value: 'seller',
                          child: Text(RCCubit.instance.getText(R.seller)),
                        ),
                        FormBuilderChipOption(
                          value: 'client',
                          child: Text(RCCubit.instance.getText(R.client)),
                        ),
                        FormBuilderChipOption(
                          value: 'shared',
                          child: Text(RCCubit.instance.getText(R.shared)),
                        ),
                      ]),
                  if (mailReturnsShippingFeeBearerCC?.contains('seller') == true)
                    Text(
                      style: Get.textTheme.bodySmall,
                      RCCubit.instance.getText(R.sellerPaysForExchangeShippingFee),
                    ),
                  if (mailReturnsShippingFeeBearerCC?.contains('client') == true)
                    Text(
                        style: Get.textTheme.bodySmall,
                        RCCubit.instance.getText(R.clientPaysForExchangeShippingFee)),
                  if (mailReturnsShippingFeeBearerCC?.contains('shared') == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SegmentedButton<num>(
                          emptySelectionAllowed: false,
                          multiSelectionEnabled: false,
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          onSelectionChanged: (Set<num?> selection) {
                            setState(() {
                              _itemFactoryBloc.item.returnPolicy!.returnOptions!.mailReturns!
                                  .percentage = selection.first;
                            });
                          },
                          segments: const [30, 50, 70]
                              .map((e) => ButtonSegment<num>(
                                    value: e,
                                    label: Text('$e%'),
                                  ))
                              .toList(),
                          selected: {
                            if (_itemFactoryBloc
                                    .item.returnPolicy!.returnOptions!.mailReturns!.percentage !=
                                null)
                              _itemFactoryBloc
                                  .item.returnPolicy!.returnOptions!.mailReturns!.percentage!
                          },
                        ),
                        Text(
                            style: Get.textTheme.bodySmall,
                            '${_itemFactoryBloc.item.returnPolicy!.returnOptions!.mailReturns!.percentage?.toInt()}% ${RCCubit.instance.getText(R.sharedPaymentForExchangeShippingFee)}'),
                      ],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  FormBuilderFieldOption<String?> _buildInStoreReturnsOption() {
    return FormBuilderFieldOption(
      value: R.inStoreReturns.name,
      child: Column(
        children: [
          _buildCheckBoxTile({R.inStoreReturns, R.inStoreReturnsSellerDescription}),
          if (returnOptionsCG?.contains(R.inStoreReturns.name) == true)
            FormBuilderTextField(
              name: _FFNames.inStoreReturnsAddressTF.name,
              decoration: const InputDecoration(
                hintText: 'Enter Store address',
                contentPadding: EdgeInsets.all(4.0),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _buildConditions() {
    return Column(
      children: [
        ListTile(
          title: Text(RCCubit.instance.getText(R.conditions),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(
            RCCubit.instance.getText(R.conditionsDescription),
          ),
          dense: true,
        ),
        PaddedLeftBar(
          space: 0,
          child: FormBuilderCheckboxGroup<String?>(
            decoration: const InputDecoration(
              fillColor: Colors.transparent,
              isDense: true,
              contentPadding: EdgeInsets.all(0.0),
            ),
            wrapCrossAxisAlignment: WrapCrossAlignment.start,
            name: _FFNames.conditionsCG.name,
            initialValue: [
              if (conditionsCG?.contains(R.unusedAndInOriginalCondition.name) == true)
                R.unusedAndInOriginalCondition.name,
              if (conditionsCG?.contains(R.defectiveOrDamaged.name) == true)
                R.defectiveOrDamaged.name,
              if (conditionsCG?.contains(R.notAsDescribed.name) == true) R.notAsDescribed.name,
            ],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(1),
            ]),
            options: [
              {R.unusedAndInOriginalCondition, R.unusedAndInOriginalConditionSellerDescription},
              {R.defectiveOrDamaged, R.defectiveOrDamagedSellerDescription},
              {R.notAsDescribed, R.notAsDescribedSellerDescription}
            ]
                .map((e) => FormBuilderFieldOption(
                    value: e.elementAt(0).name, child: _buildCheckBoxTile(e)))
                .toList(),
          ),
        ),
      ],
    );
  }

  Row _buildCheckBoxTile(Set<R> e) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            RCCubit.instance.getText(e.elementAt(0)),
            style: Get.textTheme.bodySmall?.copyWith(
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline_rounded),
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: Text(RCCubit.instance.getText(e.elementAt(0))),
                content: Text(RCCubit.instance.getText(e.elementAt(1))),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(RCCubit.instance.getText(R.ok)),
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }

  String getPolicyDescription(ReturnTimeFrame name) {
    switch (name) {
      case ReturnTimeFrame.sevenDayReturnPolicy:
        return RCCubit.instance.getText(R.sevenDayReturnPolicySellerDescription);
      case ReturnTimeFrame.fourteenDayReturnPolicy:
        return RCCubit.instance.getText(R.fourteenDayReturnPolicySellerDescription);
      case ReturnTimeFrame.thirtyDayReturnPolicy:
        return RCCubit.instance.getText(R.thirtyDayReturnPolicySellerDescription);
      case ReturnTimeFrame.sixtyDayReturnPolicy:
        return RCCubit.instance.getText(R.sixtyDayReturnPolicySellerDescription);
      case ReturnTimeFrame.ninetyDayReturnPolicy:
        return RCCubit.instance.getText(R.ninetyDayReturnPolicySellerDescription);
      case ReturnTimeFrame.noReturnPolicy:
        return RCCubit.instance.getText(R.noReturnPolicySellerDescription);
    }
  }
}

enum _FFNames {
  timeFrameDropDown,
  conditionsCG,
  returnOptionsCG,
  inStoreReturnsAddressTF,
  mailReturnsAddressTF,
  mailReturnsShippingFeeBearerCC,
  homeOfficePickupReturnsFeeBearerCC,
  acceptExchangeSwitch,
  exchangeOptionsCG,
  inStoreExchangesAddressTF,
  mailExchangesAddressTF,
  mailExchangesFeeBearerChoiceChip,
  homeOfficePickupExchangesFeeBearerCC,
}
