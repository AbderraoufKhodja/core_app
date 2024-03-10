import 'package:fibali/support_web_page/swappers_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:markdown/markdown.dart' as md;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const MyHomePage(),
        '/privacyPolicy': (BuildContext context) => const MDPage(
              title: 'Privacy Policy',
              content: SwappersStrings.privacyPolicy,
            ),
        '/userTerms': (BuildContext context) => const MDPage(
              title: 'User Terms',
              content: SwappersStrings.userTerms,
            ),
        '/deleteAccount': (BuildContext context) => const MDPage(
              title: 'Delete Account',
              content: SwappersStrings.deleteAccount,
            ),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'web_assets/swappers_intro_image.webp',
              width: adaptScreenSize(context, size: 300.0),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/privacyPolicy');
                },
                child: const Text(
                  'Privacy',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const VerticalDivider(color: Colors.white),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/userTerms');
                },
                child: const Text(
                  'User Terms',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const VerticalDivider(color: Colors.white),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/deleteAccount');
                },
                child: const Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Adapts to different screen sizes
  double adaptScreenSize(BuildContext context, {required double size}) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Define breakpoints
    double mobileBreakpoint = 480; // 480px and below is considered mobile
    double tabletBreakpoint = 1024; // 481px to 1024px is considered tablet

    // Define scale factors
    double mobileScaleFactor = 0.5; // Scale factor for mobile
    double tabletScaleFactor = 0.75; // Scale factor for tablet
    double desktopScaleFactor = 1.0; // Scale factor for desktop

    if (screenWidth <= mobileBreakpoint) {
      // It's a phone
      return size * mobileScaleFactor;
    } else if (screenWidth <= tabletBreakpoint) {
      // It's a tablet
      return size * tabletScaleFactor;
    } else {
      // It's a desktop
      return size * desktopScaleFactor;
    }
  }
}

class MDPage extends StatelessWidget {
  const MDPage({super.key, required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: Markdown(
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
              p: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.normal),
              blockquote: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.normal),
              code: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.normal),
              codeblockPadding: const EdgeInsets.all(8),
              codeblockDecoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            data: content,
            extensionSet: md.ExtensionSet(
              md.ExtensionSet.gitHubFlavored.blockSyntaxes,
              [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
            ),
          ),
        ),
      ),
    );
  }
}
