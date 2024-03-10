import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorful_iconify_flutter/icons/emojione.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/business/bloc.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:fibali/ui/pages/business_screen/business_location_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();
}

class CustomAppBarState extends State<CustomAppBar>
    with AutomaticKeepAliveClientMixin<CustomAppBar> {
  @override
  bool get wantKeepAlive => true;

  final scaffoldKey = GlobalKey();

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const SliverAppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          BusinessLocationWidget(),
          AppBarHeader(),
        ],
      ),
      centerTitle: false,
      // actions: [
      //   XiaoYiIcon(
      //     path: 'assets/xiaoyi.png',
      //     label: RCCubit.instance.getText(R.gabi),
      //     color1: Colors.white,
      //     onTap: () => showTranslatorApp(context),
      //   ),
      // ],
      pinned: true,
      snap: false,
      floating: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      // expandedHeight: 200.0,
      // collapsedHeight: 60.0,
      toolbarHeight: 60.0,
      leadingWidth: 0.0,
      // flexibleSpace: buildAppBarContent(),
    );
  }

  FlexibleSpaceBar buildAppBarContent() {
    return const FlexibleSpaceBar(
      expandedTitleScale: 1,
      titlePadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      background: Padding(
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 8.0,
          top: 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(color: Colors.white),
            Expanded(child: FeaturedItemsWidget()),
          ],
        ),
      ),
    );
  }

  Widget buildLocationTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(1),
      child: Row(
        children: [
          const Iconify(
            Emojione.flag_for_algeria,
            size: 38,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Text(
              _currentUser?.deliveryAddress?.containsKey('province') == true
                  ? ' ' + _currentUser!.deliveryAddress!['province']
                  : ' add service region',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturedItemsWidget extends StatelessWidget {
  const FeaturedItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: CarouselSlider.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          if (itemIndex == 0) {
            return PhotoWidget.asset(
              path: 'assets/banner_1.jpg',
              height: Get.size.height / 5,
              width: Get.size.width,
              fit: BoxFit.fitWidth,
            );
          }
          if (itemIndex == 1) {
            return PhotoWidget.asset(
              path: 'assets/banner_2.jpg',
              height: Get.size.height / 5,
              width: Get.size.width,
              fit: BoxFit.fitWidth,
            );
          }
          if (itemIndex == 2) {
            return PhotoWidget.asset(
              path: 'assets/banner_3.jpg',
              height: Get.size.height / 5,
              width: Get.size.width,
              fit: BoxFit.fitWidth,
            );
          }
          return const SizedBox();
        },
        options: CarouselOptions(
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 8),
          scrollDirection: Axis.vertical,
          autoPlay: true,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
        ),
      ),
    );
  }
}

class AppBarHeader extends StatelessWidget {
  const AppBarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCubit = BlocProvider.of<BusinessCubit>(context);

    return Expanded(
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            controller: searchCubit.textController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  if (searchCubit.textController.text.split(' ').isNotEmpty) {
                    searchCubit.refreshSearchRef();
                  }
                },
              ),
              fillColor: Colors.white30,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(width: 2, color: Colors.white),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) {
              if (searchCubit.textController.text.split(' ').isNotEmpty) {
                searchCubit.refreshSearchRef();
              }
            },
          ),
        ),
      ),
    );
  }
}

class LoadingContainer extends StatelessWidget {
  const LoadingContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white70.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: MediaQuery.of(context).size.width / 4.8,
    );
  }
}

class HeaderIcon extends StatelessWidget {
  const HeaderIcon({
    super.key,
    required this.path,
    required this.label,
    this.onTap,
    this.color1,
    this.color2,
  });

  final String path;
  final String label;
  final Function()? onTap;
  final Color? color1;
  final Color? color2;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Icon(Icons.circle, color: color1 ?? Colors.white30, size: size.width / 6),
          Icon(Icons.circle, color: color2 ?? Colors.white70, size: size.width / 6),
          Icon(Icons.circle, color: Colors.white30, size: size.width / 5.5),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                child: PhotoWidget.asset(
                  path: path,
                  fit: BoxFit.fitWidth,
                  width: size.width / 7,
                  height: size.width / 7,
                ),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class XiaoYiIcon extends StatelessWidget {
  const XiaoYiIcon({
    super.key,
    required this.path,
    required this.label,
    this.onTap,
    this.color1,
    this.color2,
  });

  final String path;
  final String label;
  final Function()? onTap;
  final Color? color1;
  final Color? color2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Icon(Icons.circle, color: color1 ?? Colors.white30, size: 260 / 6),
          Icon(Icons.circle, color: color2 ?? Colors.white70, size: 260 / 6),
          const Icon(Icons.circle, color: Colors.white30, size: 260 / 5.5),
          Container(
            padding: const EdgeInsets.all(4),
            child: PhotoWidget.asset(
              path: path,
              fit: BoxFit.fitWidth,
              width: 260 / 7,
              height: 260 / 7,
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedButton extends StatelessWidget {
  final Widget child;
  final double? hight;
  final EdgeInsets padding;
  final Function()? onTap;
  final Color color;

  const CurvedButton({
    super.key,
    required this.child,
    this.hight,
    this.padding = const EdgeInsets.all(4.0),
    this.onTap,
    this.color = Colors.white30,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        height: hight,
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(20),
          color: color.withOpacity(0.4),
        ),
        child: Center(child: child),
      ),
    );
  }
}
