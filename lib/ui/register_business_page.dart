import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:fibali/mini_apps/medical_appointment/utils/md_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class RegisterBusinessPage extends StatefulWidget {
  const RegisterBusinessPage({super.key});

  @override
  State<RegisterBusinessPage> createState() => _RegisterBusinessPageState();
}

class _RegisterBusinessPageState extends State<RegisterBusinessPage> {
  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    final topBusinesses = [
      Business(
        name: RCCubit.instance.getText(R.supplier),
        description: RCCubit.instance.getText(R.supplierSupplierDescription),
        numClients: 203,
        pngPhotoUrl: 'assets/favpng_import-export.png',
        numBusinesses: 402,
        onTap: (context) {
          Get.showSnackbar(
            GetSnackBar(
              title: RCCubit.instance.getText(R.becomeExpert),
              message: RCCubit.instance.getText(R.downloadExpertApp),
            ),
          );
        },
      ),
      Business(
        name: RCCubit.instance.getText(R.onlineShop),
        description: RCCubit.instance.getText(R.onlineShopBusinessDescription),
        numClients: 193,
        pngPhotoUrl: 'assets/favpng_delivery.png',
        numBusinesses: 320,
        onTap: (context) {
          Get.showSnackbar(
            GetSnackBar(
              title: RCCubit.instance.getText(R.becomeExpert),
              message: RCCubit.instance.getText(R.downloadExpertApp),
            ),
          );
        },
      ),
      Business(
        name: RCCubit.instance.getText(R.housing),
        description: RCCubit.instance.getText(R.housingBusinessDescription),
        numClients: 210,
        pngPhotoUrl: 'assets/favpng_housing.png',
        numBusinesses: 352,
        onTap: (context) {
          Get.showSnackbar(
            GetSnackBar(
              title: RCCubit.instance.getText(R.becomeExpert),
              message: RCCubit.instance.getText(R.downloadExpertApp),
            ),
          );
        },
      ),
      Business(
        name: RCCubit.instance.getText(R.xiaoYi),
        description: RCCubit.instance.getText(R.xiaoYiBusinessDescription),
        numClients: 210,
        pngPhotoUrl: 'assets/xiaoyi.png',
        numBusinesses: 352,
        onTap: (context) {
          Get.showSnackbar(
            GetSnackBar(
              title: RCCubit.instance.getText(R.becomeExpert),
              message: RCCubit.instance.getText(R.downloadExpertApp),
            ),
          );
        },
      ),
      Business(
        name: RCCubit.instance.getText(R.carRental),
        description: RCCubit.instance.getText(R.carRentalBusinessDescription),
        numClients: 210,
        pngPhotoUrl: 'assets/blue_car.png',
        numBusinesses: 352,
        onTap: (context) {
          Get.showSnackbar(
            GetSnackBar(
              title: RCCubit.instance.getText(R.becomeExpert),
              message: RCCubit.instance.getText(R.downloadExpertApp),
            ),
          );
        },
      ),
      Business(
        name: RCCubit.instance.getText(R.foodDelivery),
        description: RCCubit.instance.getText(R.foodDeliveryBusinessDescription),
        numClients: 210,
        pngPhotoUrl: 'assets/favpng_pizza-delivery.png',
        numBusinesses: 352,
        onTap: (context) {
          Get.showSnackbar(
            GetSnackBar(
              title: RCCubit.instance.getText(R.becomeExpert),
              message: RCCubit.instance.getText(R.downloadExpertApp),
            ),
          );
        },
      ),
      Business(
        name: RCCubit.instance.getText(R.medical),
        description: RCCubit.instance.getText(R.medicalBusinessDescription),
        numClients: 173,
        pngPhotoUrl: 'assets/doctor.png',
        numBusinesses: 298,
        onTap: (context) {
          Get.showSnackbar(
            GetSnackBar(
              title: RCCubit.instance.getText(R.becomeExpert),
              message: RCCubit.instance.getText(R.downloadExpertApp),
            ),
          );
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.registerBusiness)),
        centerTitle: true,
        leading: const PopButton(),
        elevation: .5,
      ),
      body: ListView.builder(
        itemExtent: 115,
        physics: const BouncingScrollPhysics(),
        itemCount: topBusinesses.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          final business = topBusinesses[index];
          return BusinessCard(business: business);
        },
      ),
    );
  }
}

class BusinessCard extends StatelessWidget {
  const BusinessCard({
    super.key,
    required this.business,
  });

  final Business business;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (business.onTap != null) business.onTap!(context);
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          children: <Widget>[
            //----------------------------------
            //-----BLUE BACKGROUND
            //---------------------------------
            Container(
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.only(
                left: 120,
                bottom: 5,
                right: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [
                    MdAppColors.kLightBlue,
                    MdAppColors.kBlue,
                  ],
                ),
              ),
              child: _DoctorInformation(business: business),
            ),
            //-----------------------------
            //------PNG DOCTOR IMAGE
            //-----------------------------
            Positioned(
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
                child: PhotoWidget.asset(
                  path: business.pngPhotoUrl!,
                  width: 115,
                  height: 115,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorInformation extends StatelessWidget {
  const _DoctorInformation({
    required this.business,
  });

  final Business business;

  @override
  Widget build(BuildContext context) {
    final countTextStyle = TextStyle(
      color: Colors.white.withOpacity(.8),
      fontWeight: FontWeight.w600,
      height: 1,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //--------------------------------------------
        //------NAME DOCTOR AND SPECIALIZATION
        //--------------------------------------------
        Text(
          business.name!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          business.description!,
          style: const TextStyle(
            height: 1,
            color: Colors.white70,
          ),
          maxLines: 4,
        ),
        const Spacer(),
        //-----------------------------------------------
        //-----INFORMATION
        //-----------------------------------------------
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          // children: <Widget>[
          //   //-------------------------------
          //   //-----PATIENTS COUNT
          //   //-------------------------------
          //   Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       Text(
          //         RCCubit.instance.getText(R.businesses),
          //         style: TextStyle(
          //           color: Colors.white.withOpacity(.8),
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       Text(
          //         business.numBusinesses.toString(),
          //         style: countTextStyle,
          //       ),
          //     ],
          //   ),
          //   //-------------------------------
          //   //-----RATE
          //   //-------------------------------
          //   Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       Text(
          //         RCCubit.instance.getText(R.clients),
          //         style: TextStyle(
          //           color: Colors.white.withOpacity(.8),
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       Text(
          //         business.numClients.toString(),
          //         style: countTextStyle,
          //       ),
          //     ],
          //   )
          // ],
        )
      ],
    );
  }
}

Future<dynamic>? showRegisterBusinessPage() {
  final route = PageRouteBuilder<dynamic>(
    opaque: true,
    transitionDuration: const Duration(milliseconds: 600),
    reverseTransitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) {
      return FadeTransition(
        opacity: animation,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<AuthBloc>(context)),
          ],
          child: const RegisterBusinessPage(),
        ),
      );
    },
  );
  return Get.to(() => const RegisterBusinessPage());
}

class Business {
  const Business({
    this.name,
    this.description,
    this.numBusinesses,
    this.numClients,
    this.pngPhotoUrl,
    this.onTap,
  });

  final String? name;
  final String? description;
  final int? numBusinesses;
  final int? numClients;
  final String? pngPhotoUrl;
  final Function(BuildContext context)? onTap;
}
