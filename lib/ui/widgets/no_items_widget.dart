import 'package:badges/badges.dart' as bd;
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/firebase_analytics/firebase_analytics_cubit.dart';
import 'package:fibali/mini_apps/swap_it_app/bloc/search/bloc.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/d_l_params.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/dashicons.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class NoItemsWidget extends StatefulWidget {
  const NoItemsWidget({super.key});

  @override
  State<NoItemsWidget> createState() => _NoItemsWidgetState();
}

class _NoItemsWidgetState extends State<NoItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SvgPicture.asset(
            'assets/map-svgrepo-com.svg',
            fit: BoxFit.fitHeight,
            color: Colors.grey.shade400,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 8.0,
            left: Get.size.width / 10,
            right: Get.size.width / 10,
            bottom: Get.size.height / 50,
          ),
          child: Text(
            RCCubit.instance.getText(R.noItems),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: Get.size.width / 10,
            right: Get.size.width / 10,
            bottom: Get.size.height / 50,
            top: Get.size.height / 50,
          ),
          child: Text(
            RCCubit.instance.getText(R.shareWithFriends),
            textAlign: TextAlign.center,
          ),
        ),
        // const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: NoItemBottomButtons(),
        // )
      ],
    );
  }
}

class CustomVerticalSlider extends StatefulWidget {
  const CustomVerticalSlider({super.key});

  @override
  State<CustomVerticalSlider> createState() => _CustomVerticalSliderState();
}

class _CustomVerticalSliderState extends State<CustomVerticalSlider> {
  SwapSearchBloc get _searchBloc => BlocProvider.of<SwapSearchBloc>(context);

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwapSearchBloc, SwapSearchState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SfSlider.vertical(
                min: 0.0,
                max: 300.0,
                value: _searchBloc.selectedDistance,
                interval: 20,
                showTicks: false,
                showLabels: false,
                enableTooltip: true,
                stepSize: 10,
                inactiveColor: Colors.grey.shade300,
                activeColor: Colors.grey.shade400,
                labelFormatterCallback: (actualValue, formattedText) => formattedText,
                tooltipTextFormatterCallback: (actualValue, formattedText) {
                  if (_searchBloc.fetchedSwapItemsRecords?.isNotEmpty == true) {
                    final filteredItems = _searchBloc.getFilteredItems(
                      fetchedSwapItemsRecords: _searchBloc.fetchedSwapItemsRecords!,
                      previousSwapAppreciations: _searchBloc.previousSwapAppreciations,
                      currentUserLocation: _searchBloc.currentUserGeoPoint!,
                    );

                    final numItems = filteredItems.where((item) {
                      if (item.geopoint == null) return false;

                      final distance = Utils.getDistance(
                        startLocation: _searchBloc.currentUserGeoPoint!,
                        endLocation: item.geopoint!,
                      );

                      if (distance != null) {
                        return distance < _searchBloc.selectedDistance;
                      } else {
                        return false;
                      }
                    }).length;

                    return '${RCCubit.instance.getText(R.numOfItems)} $numItems | ${_searchBloc.selectedDistance.toInt()} km';
                  }

                  return '${RCCubit.instance.getText(R.numOfItems)} 0 | ${_searchBloc.selectedDistance.toInt()} km';
                },
                onChanged: (dynamic value) {
                  setState(
                    () {
                      _searchBloc.selectedDistance = value;
                    },
                  );
                },
              ),
            ),
            IconButton(
              onPressed: _searchBloc.fetchedSwapItemsRecords?.isNotEmpty == true
                  ? () {
                      _searchBloc.changeSwapItemsFilter(
                        currentUserID: _currentUser!.uid,
                        distance: _searchBloc.selectedDistance,
                        currentUserLocation: _searchBloc.currentUserGeoPoint!,
                        displayedSwapItems: _searchBloc.swapItemBatch!,
                        previousSwapAppreciations: _searchBloc.previousSwapAppreciations,
                        fetchedSwapItemRecords: _searchBloc.fetchedSwapItemsRecords!,
                      );
                    }
                  : null,
              padding: const EdgeInsets.all(0),
              icon: const Iconify(
                Dashicons.update2,
                color: Colors.grey,
                size: 50,
              ),
            ),
          ],
        );
      },
    );
  }
}

class NoItemBottomButtons extends StatefulWidget {
  const NoItemBottomButtons({
    super.key,
  });

  static const double height = 80;

  @override
  State<NoItemBottomButtons> createState() => _NoItemBottomButtonsState();
}

class _NoItemBottomButtonsState extends State<NoItemBottomButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Expanded(
        //   child: Center(
        //     child: GestureDetector(
        //       onTap: () {
        //         showAppSettingsPage(context);
        //       },
        //       child: Text(
        //         RCCubit.instance.getText(R.settings),
        //         style: GoogleFonts.specialElite(
        //           fontSize: 28,
        //           color: Colors.white70,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        if (!kIsWeb)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                child: bd.Badge(
                  badgeStyle: const bd.BadgeStyle(
                    shape: bd.BadgeShape.instagram,
                    badgeColor: Colors.transparent,
                    elevation: 0,
                  ),
                  badgeContent: const Iconify(
                    Teenyicons.share_solid,
                    color: Colors.grey,
                    size: 35,
                  ),
                  child: InkWell(
                    splashColor: Colors.red.shade300, // Splash color
                    onTap: handleShareApp,
                    child: SizedBox(
                      height: 56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            RCCubit.instance.getText(R.share),
                            style: Get.textTheme.labelLarge?.copyWith(fontSize: 34),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _shareApp() async {
    final dynamicLinks = FirebaseDynamicLinks.instance;

    final parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: 'https://fibali.page.link',
      // The deep Link passed to your application which you can use to affect change
      link: Uri(
        scheme: 'https',
        host: 'mobile-fibali.web.app',
        path: DLTypes.app.name,
      ),
      // Android application details needed for opening correct app on device/Play Store
      androidParameters: const AndroidParameters(
        packageName: "com.deepdev.fibali",
        minimumVersion: 1,
      ),

      // iOS application details needed for opening correct app on device/App Store
      iosParameters: const IOSParameters(
        bundleId: "com.deepdev.fibali",
        minimumVersion: '1',
      ),

      socialMetaTagParameters: SocialMetaTagParameters(
        title: RCCubit.instance.getText(R.shareAppTitle),
        description: RCCubit.instance.getText(R.shareAppDescription),
        imageUrl: Uri.parse(
            'https://firebasestorage.googleapis.com/v0/b/sou9-cf313.appspot.com/o/posts%2Fn8reY5fxrbbEL92MCkHB%2FitemPhotos%2F1?alt=media&tok…'),
      ),
    );

    final uri = await dynamicLinks.buildShortLink(parameters);
    return Share.share(uri.shortUrl.toString());
  }

  Future<void> handleShareApp() {
    FAC.logEvent(FAEvent.share_app);
    //TODO: add share post message

    EasyLoading.show(dismissOnTap: true);
    return _shareApp().then((value) {
      EasyLoading.dismiss(animation: true);
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      EasyLoading.showError(RCCubit.instance.getText(R.failed), dismissOnTap: true);
    });
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({
    super.key,
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
