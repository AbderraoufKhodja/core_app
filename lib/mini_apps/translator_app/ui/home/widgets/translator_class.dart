import 'package:fibali/mini_apps/translator_app/bloc/dashboard/translator_dashboard_cubit.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/home_page.dart';
import 'package:fibali/fibali_core/ui/widgets/space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/codicon.dart';

class TranslatorClass extends StatefulWidget {
  const TranslatorClass({super.key});

  @override
  State<TranslatorClass> createState() => _TranslatorClassState();
}

class _TranslatorClassState extends State<TranslatorClass> {
  final translatorClass = ['ALL', 'FLUENT', 'EXPERT', 'PROFESSIONAL', 'CERTIFEID'];

  TranslatorDashboardCubit get _dashboardCubit =>
      BlocProvider.of<TranslatorDashboardCubit>(context);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        color: cards,
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
                    'Select Translator Class',
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
              children: [for (final i in translatorClass) ClassItem(i)],
            ),
          )
        ],
      ),
    );
  }
}

class ClassItem extends StatefulWidget {
  final String translatorClass;

  const ClassItem(this.translatorClass, {Key? key}) : super(key: key);

  @override
  State<ClassItem> createState() => _ClassItemState();
}

class _ClassItemState extends State<ClassItem> {
  TranslatorDashboardCubit get _dashboardCubit =>
      BlocProvider.of<TranslatorDashboardCubit>(context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _dashboardCubit.interClass = widget.translatorClass;
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
                  widget.translatorClass,
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

showSelectTranslatorClassBottomSheet(context) {
  showBottomSheet(
    context: context,
    backgroundColor: Colors.grey.shade100,
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
    builder: (context) => BlocProvider.value(
      value: BlocProvider.of<TranslatorDashboardCubit>(context),
      child: const TranslatorClass(),
    ),
  );
}
