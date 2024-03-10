import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/user_terms.dart';
import 'package:fibali/fibali_core/ui/widgets/loading_grid.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:get/get.dart';

class UserTermsPage extends StatelessWidget {
  const UserTermsPage({super.key});

  static show() => Get.to(() => const UserTermsPage());

  @override
  Widget build(BuildContext context) {
    final settingsCubit = BlocProvider.of<SettingsCubit>(context);

    String userTerms = '';
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.termsAndConditions)),
        leading: const PopButton(),
      ),
      body: FutureBuilder<QuerySnapshot<UserTerms>?>(
        future: UserTerms.latestRef.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(RCCubit.instance.getText(R.error)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingGrid(width: Get.width - 16);
          }
          final docs = snapshot.data?.docs;
          if (docs?.isNotEmpty == true) {
            final interUserTerms =
                docs?.first.data().inter?[settingsCubit.state.appLanguage ?? 'us'] as String?;

            if (interUserTerms?.isNotEmpty == true) {
              userTerms = interUserTerms!;
            } else if (docs?.first.data().userTerms?.isNotEmpty == true) {
              userTerms = docs!.first.data().userTerms!;
            }

            return Column(
              children: [
                if (docs!.first.data().timestamp is Timestamp)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        (docs.first.data().timestamp as Timestamp).toDate().toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                Expanded(
                  child: Markdown(
                    // style for user terms small GoogleFonts.cairo font size
                    data: userTerms,
                    styleSheet: MarkdownStyleSheet(
                      h1: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      h2: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      h3: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      h4: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      h5: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      h6: GoogleFonts.cairo(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      p: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.normal),
                      blockquote: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.normal),
                      code: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.normal),
                      codeblockPadding: const EdgeInsets.all(8),
                      codeblockDecoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    extensionSet: md.ExtensionSet(
                      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                      [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No data'));
        },
      ),
    );
  }
}
