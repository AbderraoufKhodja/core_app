import 'package:badges/badges.dart' as bd;
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:swipable_stack/swipable_stack.dart';

class BottomButtonsRow extends StatelessWidget {
  const BottomButtonsRow({
    required this.onRewindTap,
    required this.onSwipe,
    required this.canRewind,
    super.key,
  });

  final bool canRewind;
  final VoidCallback onRewindTap;
  final ValueChanged<SwipeDirection> onSwipe;

  static const double height = 80;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () => onSwipe(SwipeDirection.left),
                  child: Text(
                    RCCubit.instance.getText(R.skip),
                    style: GoogleFonts.specialElite(
                      fontSize: 36,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.white70, // Button color
                  child: bd.Badge(
                    position: bd.BadgePosition.custom(end: -35, top: -6),
                    badgeStyle: const bd.BadgeStyle(
                      shape: bd.BadgeShape.instagram,
                      badgeColor: Colors.transparent,
                      elevation: 0,
                    ),
                    badgeContent: Iconify(Ph.heart_fill, color: Colors.red.shade300, size: 80),
                    child: InkWell(
                      splashColor: Colors.red.shade300, // Splash color
                      onTap: () => onSwipe(SwipeDirection.right),
                      child: SizedBox(
                        height: 56,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              RCCubit.instance.getText(R.like),
                              style: GoogleFonts.specialElite(
                                fontSize: 36,
                                color: Colors.black45,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // _BottomButton(
            //   color: SwipeDirectionColor.left,
            //   child: const Icon(Icons.arrow_back),
            //   onPressed: () {
            //     onSwipe(SwipeDirection.left);
            //   },
            // ),
            // _BottomButton(
            //   color: SwipeDirectionColor.up,
            //   onPressed: () {
            //     onSwipe(SwipeDirection.up);
            //   },
            //   child: const Icon(Icons.arrow_upward),
            // ),
            // _BottomButton(
            //   color: SwipeDirectionColor.right,
            //   onPressed: () {
            //     onSwipe(SwipeDirection.right);
            //   },
            //   child: const Icon(Icons.arrow_forward),
            // ),
            // _BottomButton(
            //   color: SwipeDirectionColor.down,
            //   onPressed: () {
            //     onSwipe(SwipeDirection.down);
            //   },
            //   child: const Icon(Icons.arrow_downward),
            // ),
          ],
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({
    required this.onPressed,
    required this.child,
    required this.color,
  });

  final VoidCallback? onPressed;
  final Icon child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 64,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => color,
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
