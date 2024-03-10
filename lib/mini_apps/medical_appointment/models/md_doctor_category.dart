import 'package:flutter/cupertino.dart' show IconData;
import 'package:fibali/mini_apps/medical_appointment/utils/md_icons_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';

enum DoctorCategory {
  kCardiologist._(
    nameCategory: 'Flights',
    doctors: 9,
    iconData: FontAwesome.paper_plane,
    specialists: 10,
    rawColor: 0xffFF565D,
  ),
  kPediatrician._(
    nameCategory: "Cars",
    doctors: 9,
    iconData: FontAwesome.camera,
    specialists: 10,
    rawColor: 0xffFCD94A,
  ),
  kSurgeon._(
    nameCategory: "Hotel",
    iconData: FontAwesome.adjust,
    doctors: 9,
    specialists: 10,
    rawColor: 0xff1BCAB2,
  ),
  kUrologist._(
    nameCategory: "Experts",
    doctors: 9,
    iconData: FontAwesome.suitcase,
    specialists: 10,
    rawColor: 0xff33b5e5,
  ),
  kAllergist._(
    nameCategory: "Translator",
    doctors: 9,
    iconData: FontAwesome.language,
    rawColor: 0xffFFaf00,
    specialists: 10,
  ),
  kDermatologist._(
    nameCategory: "Dermatologist",
    iconData: FontAwesome.shopping_basket,
    doctors: 9,
    rawColor: 0xffff6ad3,
    specialists: 10,
  ),
  kOphthalmologist._(
    nameCategory: "Ophthalmologist",
    doctors: 9,
    iconData: MdIcons.eye,
    rawColor: 0xff28EB62,
    specialists: 10,
  ),
  kEndocrinologist._(
    nameCategory: "Endocrinologist",
    doctors: 9,
    iconData: MdIcons.kidneys,
    rawColor: 0xff993299,
    specialists: 10,
  );

  const DoctorCategory._({
    this.iconData,
    this.nameCategory,
    this.specialists,
    this.doctors,
    this.rawColor,
  });

  final String? nameCategory;
  final int? specialists;
  final int? doctors;
  final int? rawColor;
  final IconData? iconData;

  static const categories = [
    kCardiologist,
    kPediatrician,
    kSurgeon,
    kUrologist,
    kAllergist,
    kDermatologist,
    kOphthalmologist,
    kEndocrinologist,
  ];
}
