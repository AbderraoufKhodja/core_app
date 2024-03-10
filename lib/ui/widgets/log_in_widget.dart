import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:flutter/material.dart';

class LogInWidget extends StatefulWidget {
  const LogInWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<LogInWidget> createState() => _LogInWidgetState();
}

class _LogInWidgetState extends State<LogInWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        child: Text(RCCubit.instance.getText(R.pleaseLogIn)),
      ),
    );
  }
}
