import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:google_fonts/google_fonts.dart';

class SwappedStamp extends StatelessWidget {
  const SwappedStamp({
    required double size,
    required double angle,
  })  : _size = size,
        _angle = angle;

  final double _size;
  final double _angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _angle,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularText(
            radius: _size / 5,
            position: CircularTextPosition.inside,
            backgroundPaint: Paint()..color = Colors.grey.withOpacity(0.3),
            children: [
              TextItem(
                text: Text(
                  "_______________________________________________",
                  style: TextStyle(
                    fontSize: _size / 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                space: 12,
                startAngle: -90,
                startAngleAlignment: StartAngleAlignment.center,
                direction: CircularTextDirection.clockwise,
              ),
              TextItem(
                text: Text(
                  "************************************************",
                  style: TextStyle(
                    fontSize: _size / 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                space: 10,
                startAngle: 90,
                startAngleAlignment: StartAngleAlignment.center,
                direction: CircularTextDirection.anticlockwise,
              ),
            ],
          ),
          Container(
            width: _size / 2.3,
            padding: EdgeInsets.only(top: _size / 40),
            decoration: BoxDecoration(
              border: Border.all(width: _size / 100, color: Colors.grey),
              color: Colors.green.shade300,
              borderRadius: BorderRadius.circular(_size / 40),
            ),
            child: FittedBox(
              child: Text(
                ' Swapped ',
                style: GoogleFonts.specialElite(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
