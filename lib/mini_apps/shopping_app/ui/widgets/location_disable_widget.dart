import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationDisableWidget extends StatefulWidget {
  const LocationDisableWidget({super.key});

  @override
  State<LocationDisableWidget> createState() => _LocationDisableWidgetState();
}

class _LocationDisableWidgetState extends State<LocationDisableWidget> {
  @override
  Widget build(BuildContext context) {
    return DoubleCirclesWidget(
      title: RCCubit.instance.getText(R.locationDisabled),
      description: RCCubit.instance.getText(R.pleaseEnableLocation),
      child: SvgPicture.asset(
        'assets/search-map-svgrepo-com.svg',
        fit: BoxFit.fitHeight,
        color: Colors.white,
      ),
    );
  }
}
