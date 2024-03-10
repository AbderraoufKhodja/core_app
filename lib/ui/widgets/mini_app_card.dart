import 'package:badges/badges.dart' as bd;
import 'package:flutter/material.dart';
import 'package:fibali/mini_apps/medical_appointment/models/md_doctor_category.dart';
import 'package:google_fonts/google_fonts.dart';

class MiniAppCard extends StatelessWidget {
  const MiniAppCard({
    super.key,
    required this.category,
  });

  final DoctorCategory category;

  @override
  Widget build(BuildContext context) {
    return bd.Badge(
      badgeContent: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white30,
            shape: BoxShape.circle,
          ),
          child: Icon(
            category.iconData,
            color: Colors.white54,
            size: 30,
          ),
        ),
      ),
      badgeStyle: const bd.BadgeStyle(
        shape: bd.BadgeShape.instagram,
        badgeColor: Colors.transparent,
        padding: EdgeInsets.all(0),
        elevation: 0,
      ),
      position: bd.BadgePosition.topStart(start: 10, top: -10),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.all(6.0),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // color: Colors.transparent,
          gradient: LinearGradient(
            colors: [
              Color(category.rawColor!),
              Color(category.rawColor!).withAlpha(4000),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          // fit: StackFit.expand,
          children: [
            //----------------------------------
            //-------WHITE CIRCLE WITH ICON
            //---------------------------------
            // Positioned(
            //   child: Container(
            //     padding: EdgeInsets.all(8),
            //     decoration: const BoxDecoration(
            //       color: Colors.white12,
            //       shape: BoxShape.circle,
            //     ),
            //     child: Container(
            //       decoration: const BoxDecoration(
            //         color: Colors.white24,
            //         shape: BoxShape.circle,
            //       ),
            //       child: Icon(
            //         category.iconData,
            //         color: Colors.white38,
            //         size: 40,
            //       ),
            //     ),
            //   ),
            // ),
            //----------------------------------
            //-----CATEGORY INFORMATION
            //----------------------------------
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Doctors  ${category.doctors}',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white70),
                ),
                Text(
                  'Specialist  ${category.specialists}',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white70),
                ),
                Text(
                  category.nameCategory!,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
