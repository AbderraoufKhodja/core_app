import 'package:fibali/bloc/business/bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/mini_apps/shopping_app/ui/screens/business/global_shopping/ae_shopping_tab.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_it_grid_page.dart';
import 'package:fibali/ui/pages/business_app_bar.dart';
import 'package:fibali/ui/widgets/categories_header.dart';
import 'package:fibali/ui/widgets/shopping_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({super.key});

  @override
  BusinessPageState createState() => BusinessPageState();
}

class BusinessPageState extends State<BusinessPage>
    with AutomaticKeepAliveClientMixin<BusinessPage> {
  @override
  bool get wantKeepAlive => true;

  RCCubit get rc => RCCubit.instance;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Theme(
      data: Get.theme.copyWith(
          textTheme: GoogleFonts.dmSansTextTheme().copyWith(
        labelSmall: GoogleFonts.dmSansTextTheme().labelSmall?.copyWith(
              fontSize: 10,
              wordSpacing: 0.1,
              letterSpacing: 0.0,
            ),
      )),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: BusinessAppBar(),
        body: BlocBuilder<BusinessCubit, BusinessState>(
          builder: (context, state) {
            return DefaultTabController(
              length: 3,
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(width: 1.5, color: Colors.black),
                        ),
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        indicatorPadding: const EdgeInsets.only(bottom: 2),
                        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                            ),
                        unselectedLabelStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 0.0),
                        unselectedLabelColor: Colors.grey,
                        labelColor: Theme.of(context).textTheme.bodyLarge?.color!,
                        tabs: [
                          Text(rc.getText(R.global)),
                          Text(rc.getText(R.shopping)),
                          Text(rc.getText(R.swaps)),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          AeShoppingTab(),
                          Column(
                            children: [
                              CategoriesHeader(),
                              Expanded(child: ShoppingItems()),
                            ],
                          ),
                          SwapItGridPage(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
