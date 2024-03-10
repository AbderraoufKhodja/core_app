import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchProgressRipple extends StatelessWidget {
  const SearchProgressRipple();

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final icons = <FaIcon>[
      FaIcon(FontAwesomeIcons.headphones, size: _size.width / 6),
      FaIcon(Icons.watch, size: _size.width / 6),
      FaIcon(FontAwesomeIcons.laptop, size: _size.width / 6),
      FaIcon(FontAwesomeIcons.mobileScreenButton, size: _size.width / 5.5),
      FaIcon(FontAwesomeIcons.bicycle, size: _size.width / 6),
      FaIcon(FontAwesomeIcons.shirt, size: _size.width / 6.5),
      FaIcon(FontAwesomeIcons.glasses, size: _size.width / 6),
      FaIcon(FontAwesomeIcons.bookOpen, size: _size.width / 6),
      FaIcon(FontAwesomeIcons.chair, size: _size.width / 5.5),
    ];
    return Center(
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: _size.width / 20),
              child: SpinKitFadingGrid(
                size: _size.width * 0.6,
                shape: BoxShape.circle,
                itemBuilder: (context, index) => icons[index],
              ),
            ),
          ),
          SpinKitRipple(
            size: _size.width,
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
