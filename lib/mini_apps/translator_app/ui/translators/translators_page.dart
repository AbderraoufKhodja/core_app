import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/translator.dart';
import 'package:fibali/mini_apps/translator_app/ui/home/widgets/home_widgets.dart';
import 'package:fibali/mini_apps/translator_app/utils/md_app_colors.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TranslatorsPage extends StatelessWidget {
  const TranslatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 130,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [MdAppColors.kBlue, MdAppColors.kDarkBlue],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
              ),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        RCCubit.instance.getText(R.findTranslator),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        RCCubit.instance.getText(R.bestTranslatorsCatalog),
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.search,
                    color: Colors.white70,
                    size: 50,
                  )
                ],
              ),
            ),
          ),
          const Expanded(child: _BodyHome(contentPadding: EdgeInsets.all(0))),
        ],
      ),
    );
  }
}

class _BodyHome extends StatelessWidget {
  const _BodyHome({
    this.contentPadding,
  });
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final sectionStyle = GoogleFonts.poppins(
      fontSize: 18,
      color: MdAppColors.kDarkTeal,
      fontWeight: FontWeight.w600,
    );

    return FirestoreListView<Translator>(
      // scrollDirection: Axis.horizontal,

      query: Translator.ref.orderBy('avgRating', descending: true),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      physics: const BouncingScrollPhysics(),
      itemExtent: 200,
      loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
      itemBuilder: (context, snapshot) {
        final translator = snapshot.data();

        if (translator.isValid()) {
          return TopTranslatorCard(translator: translator);
        } else {
          return const SizedBox();
        }
      },
    );
    return ListView(
      padding: contentPadding,
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: Text(
        //     RCCubit.instance.getText(R.languages),
        //     style: sectionStyle,
        //   ),
        // ),
        // //------------------------------------------
        // //------CATEGORIES LIST
        // //------------------------------------------
        // const SizedBox(height: 10),
        // SizedBox(
        //   height: MediaQuery.of(context).size.width * .27,
        //   child: ListView.builder(
        //     itemExtent: MediaQuery.of(context).size.width * .4,
        //     scrollDirection: Axis.horizontal,
        //     itemCount: TranslatorCategory.categories.length,
        //     physics: const BouncingScrollPhysics(),
        //     padding: const EdgeInsets.symmetric(horizontal: 20),
        //     itemBuilder: (context, index) {
        //       final category = TranslatorCategory.categories[index];
        //       return CategoryCard(category: category);
        //     },
        //   ),
        // ),
        // const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(RCCubit.instance.getText(R.topTranslators), style: sectionStyle),
        ),
        //---------------------------------
        //------TOP TRANSLATORS LIST
        //---------------------------------
        SizedBox(
          height: 200,
          child: FirestoreListView<Translator>(
            // scrollDirection: Axis.horizontal,
            query: Translator.ref.orderBy('avgRating', descending: true),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            physics: const BouncingScrollPhysics(),
            itemExtent: 320,
            loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
            itemBuilder: (context, snapshot) {
              final translator = snapshot.data();

              if (translator.isValid()) {
                return TopTranslatorCard(translator: translator);
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }
}
