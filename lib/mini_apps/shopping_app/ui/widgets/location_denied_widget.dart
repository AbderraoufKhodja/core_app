import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationDeniedWidget extends StatefulWidget {
  const LocationDeniedWidget({super.key});

  @override
  State<LocationDeniedWidget> createState() => _LocationDeniedWidgetState();
}

class _LocationDeniedWidgetState extends State<LocationDeniedWidget> {
  @override
  Widget build(BuildContext context) {
    return DoubleCirclesWidget(
      title: RCCubit.instance.getText(R.locationDenied),
      description: RCCubit.instance.getText(R.pleaseAllowAccessToGPSLocation),
      child: SvgPicture.asset(
        'assets/search-map-svgrepo-com.svg',
        fit: BoxFit.fitHeight,
        color: Colors.white,
      ),
    );
  }
}
