import 'dart:math' as math;

import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/ui/swip_module/theme/colors.dart';
import 'package:flutter/material.dart';

const _labelAngle = math.pi / 2 * 0.2;

class CardLabel extends StatelessWidget {
  const CardLabel._({
    required this.color,
    required this.label,
    required this.angle,
    required this.alignment,
  });

  factory CardLabel.right() {
    return const CardLabel._(
      color: SwipeDirectionColor.right,
      label: 'like',
      angle: -_labelAngle,
      alignment: Alignment.topLeft,
    );
  }

  factory CardLabel.left() {
    return const CardLabel._(
      color: SwipeDirectionColor.left,
      label: 'skip',
      angle: _labelAngle,
      alignment: Alignment.topRight,
    );
  }

  factory CardLabel.up() {
    return const CardLabel._(
      color: SwipeDirectionColor.up,
      label: 'up',
      angle: _labelAngle,
      alignment: Alignment(0, 0.5),
    );
  }

  factory CardLabel.down() {
    return const CardLabel._(
      color: SwipeDirectionColor.down,
      label: 'down',
      angle: -_labelAngle,
      alignment: Alignment(0, -0.75),
    );
  }

  final Color color;
  final String label;
  final double angle;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(
        vertical: 36,
        horizontal: 36,
      ),
      child: Transform.rotate(
        angle: angle,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: 4,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(6),
          child: Text(
            RCCubit.instance.getCloudText(context, label),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: color,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

enum LabelDirections { right, left, up, down }
