import 'package:badges/badges.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/discover/discover_cubit.dart';
import 'package:fibali/bloc/discover/discover_state.dart';
// import 'package:fibali/env/env.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/flavors.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/discover/discover_tab.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/discover/widgets/notification_bell_icon.dart';
import 'package:fibali/ui/pages/follow_tab.dart';
import 'package:fibali/ui/widgets/app_logo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin<DiscoverPage> {
  @override
  bool get wantKeepAlive => true;

  final _key = GlobalKey<ScaffoldState>();

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  // final apiKey = Env.googleGeminiKey;
  final inputText = 'Write a story about a magic backpack.';

  DiscoverCubit get _discoverCubit => BlocProvider.of<DiscoverCubit>(context);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        key: _key,
        appBar: buildAppBar(),
        floatingActionButton: kDebugMode
            ? FloatingActionButton(
                onPressed: () async {
                  // final json = jsonDecode(mobile_detail);
                  // Get.to(
                  //   () => const Scaffold(
                  //     body: SingleChildScrollView(
                  //       padding: EdgeInsets.all(8.0),
                  //       child: HtmlWidget(htmlElement),
                  //     ),
                  //   ),
                  // );
                },
                child: const Icon(Icons.upload),
              )
            : null,
        body: Card(
          elevation: 0,
          margin: const EdgeInsets.all(0.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                isScrollable: true,
                physics: const NeverScrollableScrollPhysics(),
                tabs: [
                  // Tab(height: 30, text: RCCubit.instance.getText(R.nearby).toUpperCase()),
                  Tab(height: 30, text: RCCubit.instance.getText(R.discover).toUpperCase()),
                  Tab(height: 30, text: RCCubit.instance.getText(R.follow).toUpperCase()),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    // NearbyTab(),
                    // BusinessPage(),
                    DiscoverTab(),
                    FollowTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const SizedBox(width: 8.0),
          if (F.appFlavor == Flavor.fibali)
            BlocBuilder<DiscoverCubit, DiscoverState>(builder: (context, state) {
              return SizedBox(
                // initialValue: PhoneNumber(isoCode: _discoverCubit.countryCode ?? 'US'),
                // onInputChanged: (PhoneNumber phoneNumber) {
                //   if (phoneNumber.isoCode != null) {
                //     _discoverCubit.countryCode = phoneNumber.isoCode;
                //     _discoverCubit.refreshSearchRef();
                //   }
                // },
                // searchBoxDecoration: InputDecoration(
                //     fillColor: Colors.grey.shade200,
                //     hintText: RCCubit.instance.getText(R.search),
                //     hintStyle: const TextStyle()),
                // hasField: false,
                // selectorConfig: const SelectorConfig(
                //   selectorType: PhoneInputSelectorType.DIALOG,
                // ),
                child: _discoverCubit.countryCode != null
                    ? Badge(
                        position: BadgePosition.bottomEnd(end: -10),
                        showBadge: false,
                        badgeContent: Text(
                          _discoverCubit.countryCode!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        badgeStyle: const BadgeStyle(
                          padding: EdgeInsets.all(0),
                          elevation: 0,
                          badgeColor: Colors.transparent,
                        ),
                        child: const FittedBox(child: AppLogo(size: 40, color: Colors.grey)),
                      )
                    : Badge(
                        position: BadgePosition.bottomEnd(end: 0, bottom: -5),
                        badgeContent: Text(
                          RCCubit.instance.getText(R.global).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        badgeStyle: const BadgeStyle(
                          padding: EdgeInsets.all(0),
                          elevation: 0,
                          badgeColor: Colors.transparent,
                        ),
                        child: const FittedBox(child: AppLogo(size: 40, color: Colors.grey)),
                      ),
              );
            }),
          Expanded(
            child: SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: _discoverCubit.textController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _discoverCubit.refreshSearchRef();
                      },
                    ),
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
                    _discoverCubit.refreshSearchRef();
                  },
                ),
              ),
            ),
          ),
          const NotificationBellIcon(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () => showVideoImagePostFactoryPage(currentUser: _currentUser!),
              child: const Iconify(Ph.plus_bold, size: 30, color: Colors.grey),
            ),
          )
        ],
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 60.0,
      leadingWidth: 0.0,
    );
  }
}
