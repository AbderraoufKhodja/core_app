import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class STFCheckBox extends StatefulWidget {
  const STFCheckBox({
    Key? key,
    required this.requestPermission,
  }) : super(key: key);

  final bool requestPermission;

  @override
  State<STFCheckBox> createState() => _STFCheckBoxState();
}

class _STFCheckBoxState extends State<STFCheckBox> {
  late bool check;

  SettingsCubit get settings => BlocProvider.of<SettingsCubit>(context);

  @override
  void initState() {
    check = widget.requestPermission;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(
            value: check,
            onChanged: (value) {
              if (value != null) {
                check = value;
                settings.setRequestNotifyPermission(value: value);
                setState(() {});
              }
            }),
        Text(
          'Always check',
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }
}
