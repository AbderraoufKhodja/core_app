import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/codicon.dart';
import 'package:fibali/fibali_core/ui/widgets/space.dart';

class CommunicationMethod extends StatefulWidget {
  const CommunicationMethod({super.key});

  @override
  State<CommunicationMethod> createState() => _CommunicationMethodState();
}

class _CommunicationMethodState extends State<CommunicationMethod> {
  final List<Method> communicationMethods = [
    Method(
      name: 'In-App',
      description: 'Receive an online video call through our app.',
      cloudLabel: CommunicationMethods.inApp.name,
      pricing: 6.5,
    ),
    Method(
      name: 'Phone',
      description: 'Receive a phone call using a local sim card.',
      cloudLabel: CommunicationMethods.phone.name,
      pricing: 7.5,
    ),
    Method(
      name: 'Tencent Metting',
      description: 'Schedule a video/audio online call using Tencent Meeting or WeChat.',
      cloudLabel: CommunicationMethods.tencentMeeting.name,
      pricing: 6.5,
    ),
    Method(
      name: 'ZOOM',
      description: 'Schedule a video/audio online call using Tencent Meeting or WeChat.',
      cloudLabel: CommunicationMethods.zoom.name,
      pricing: 6.5,
    ),
  ];

  TranslatorDashboardCubit get _dashboardCubit =>
      BlocProvider.of<TranslatorDashboardCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Space.Y(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Space.X(20),
              GestureDetector(
                onTap: () {
                  _dashboardCubit.closeWidgetShowed();
                },
                child: const Iconify(
                  Codicon.close,
                  color: Colors.blueGrey,
                ),
              ),
              const Space.X(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Select Communication Method',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                  ),
                ],
              ),
            ],
          ),
          const Space.Y(10),
          Divider(
            thickness: 1,
            color: textColor.withOpacity(0.2),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: communicationMethods
                  .map(
                    (method) => Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                          style: ListTileStyle.drawer,
                          title: Text(method.name,
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                              )),
                          subtitle: Text(method.description),
                          onTap: () {
                            _dashboardCubit.communicationMethod = method.cloudLabel;
                            _dashboardCubit.displayMethodeName = method.name;
                            _dashboardCubit.closeWidgetShowed();
                          },
                          trailing: Text('${method.pricing}元/min')),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

enum CommunicationMethods { inApp, phone, tencentMeeting, zoom }

class Method {
  final String name;
  final String description;
  final String cloudLabel;
  final num pricing;

  Method(
      {required this.name,
      required this.description,
      required this.cloudLabel,
      required this.pricing});
}

class MethodItem extends StatefulWidget {
  final String communicationMethod;

  const MethodItem(this.communicationMethod, {Key? key}) : super(key: key);

  @override
  State<MethodItem> createState() => _MethodItemState();
}

class _MethodItemState extends State<MethodItem> {
  TranslatorDashboardCubit get _dashboardCubit =>
      BlocProvider.of<TranslatorDashboardCubit>(context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _dashboardCubit.communicationMethod = widget.communicationMethod;
        _dashboardCubit.closeWidgetShowed();
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/seat.svg',
                  color: textColor,
                ),
                const Space.X(20),
                Text(
                  widget.communicationMethod,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
                ),
              ],
            ),
            // Divider(
            //   thickness: 1,
            //   color: textColor.withOpacity(0.2),
            // ),
          ],
        ),
      ),
    );
  }
}

showSelectCommunicationMethodBottomSheet(context) {
  showBottomSheet(
    context: context,
    backgroundColor: Colors.grey.shade100,
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
    builder: (context) => BlocProvider.value(
      value: BlocProvider.of<TranslatorDashboardCubit>(context),
      child: const CommunicationMethod(),
    ),
  );
}
