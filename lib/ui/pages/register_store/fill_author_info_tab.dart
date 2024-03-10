import 'package:fibali/bloc/store_factory/store_factory_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/custom_text_field.dart';
import 'package:fibali/ui/widgets/padded_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FillAuthorInfoTab extends StatefulWidget {
  const FillAuthorInfoTab({super.key});

  @override
  FillAuthorInfoTabState createState() => FillAuthorInfoTabState();
}

class FillAuthorInfoTabState extends State<FillAuthorInfoTab>
    with AutomaticKeepAliveClientMixin<FillAuthorInfoTab> {
  StoreFactoryBloc get _storeFactory => BlocProvider.of<StoreFactoryBloc>(context);

  final _authorFirstNameController = TextEditingController();
  final _authorLastNameController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _storeFactory.formKey2,
      child: Scaffold(
        body: ListView(children: widgets),
      ),
    );
  }

  String? _lastNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please add your legal name';
    }
    return null;
  }

  String? _firstNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please add your legal name';
    }
    return null;
  }

  List<Widget> get widgets => <Widget>[
        ListTile(
          title: Text(RCCubit.instance.getText(R.fillAuthorInfoDescription)),
        ),
        Card(
          child: Column(
            children: [
              CustomTextField(
                controller: _authorFirstNameController,
                title: RCCubit.instance.getText(R.firstName),
                hint: RCCubit.instance.getText(R.firstNameHint),
                onChanged: (value) {
                  _storeFactory.authorFirstName = value;
                },
                validator: (value) => _firstNameValidator(value),
              ),
              const PaddedDivider(hight: 8),
              CustomTextField(
                controller: _authorLastNameController,
                title: RCCubit.instance.getText(R.lastName),
                hint: RCCubit.instance.getText(R.lastNameHint),
                onChanged: (value) {
                  _storeFactory.authorLastName = value;
                },
                validator: (value) => _lastNameValidator(value),
              ),
            ],
          ),
        ),
      ];
}
