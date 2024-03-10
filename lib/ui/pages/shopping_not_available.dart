import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/double_circle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShoppingNotAvailableWidget extends StatefulWidget {
  const ShoppingNotAvailableWidget({super.key});

  @override
  State<ShoppingNotAvailableWidget> createState() => _ShoppingNotAvailableWidgetState();
}

class _ShoppingNotAvailableWidgetState extends State<ShoppingNotAvailableWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: DoubleCirclesWidget(
        title: RCCubit.instance.getText(R.empty),
        description: RCCubit.instance.getText(R.shoppingNotAvailableInThisCountry),
        child: SvgPicture.asset(
          'assets/search-map-svgrepo-com.svg',
          fit: BoxFit.fitWidth,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}
