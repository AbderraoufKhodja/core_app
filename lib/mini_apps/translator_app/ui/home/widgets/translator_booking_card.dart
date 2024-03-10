import 'package:fibali/mini_apps/translator_app/ui/home/home_page.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/offline_translator_booking_tab.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/online_translator_booking_tab.dart';

import 'package:flutter/material.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';

class TranslatorBookingCard extends StatefulWidget {
  const TranslatorBookingCard({super.key});

  @override
  State<TranslatorBookingCard> createState() => _TranslatorBookingCardState();
}

class _TranslatorBookingCardState extends State<TranslatorBookingCard>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: cards,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              height: 30,
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Colors.blueGrey,
                indicatorWeight: 2.5,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                indicatorColor: Colors.deepOrangeAccent,
                isScrollable: true,
                physics: const NeverScrollableScrollPhysics(),
                unselectedLabelStyle: const TextStyle(color: Colors.grey),
                labelStyle:
                    Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: RCCubit.instance.getText(R.online)),
                  Tab(text: RCCubit.instance.getText(R.offline)),
                ],
              ),
            ),
            const SizedBox(
              height: 425,
              child: TabBarView(children: [
                OnlineBookingTab(),
                OfflineBookingTab(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
