// import 'dart:js' as js;
// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:universal_html/html.dart' as html;

// class PayPalWidget extends StatefulWidget {
//   const PayPalWidget({super.key});

//   @override
//   PayPalState createState() => PayPalState();
// }

// class PayPalState extends State<PayPalWidget> {
//   late html.IFrameElement _element;

//   @override
//   void initState() {
//     _element = html.IFrameElement()
//       ..width = "200px"
//       ..height = "200px"
//       ..style.border = 'none'
//       ..srcdoc = """
//         <!DOCTYPE html>
//         <html>
//           <body>
//             <script src="https://www.paypal.com/sdk/js?client-id=sb"></script>
//             <script>
//               paypal.Buttons(
//                 {
//                   createOrder: function(data, actions) {
//                     return actions.order.create({
//                       purchase_units: parent.purchase_units
//                     });
//                   },
//                   onApprove: function(data, actions) {
//                     return actions.order.capture().then(function(details) {
//                       parent.flutter_feedback('Transaction completed by ' + details.payer.name.given_name);
//                     });
//                   }
//                 }

//               ).render('body');
//             </script>
//           </body>
//         </html>
//         """;

//     js.context["purchase_units"] = js.JsObject.jsify([
//       {
//         'amount': {'value': '0.02'}
//       }
//     ]);

//     js.context["flutter_feedback"] = (msg) {
//       Get.showSnackbar(GetSnackBar(message: msg.toString()));
//     };

//     // ignore:undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(
//       'PayPalButtons',
//       (int viewId) => _element,
//     );

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 220,
//       height: 220,
//       child: const HtmlElementView(viewType: 'PayPalButtons'),
//     );
//   }
// }

// // import 'dart:math';

// // import 'package:flutter/material.dart';
// // import 'package:webviewx_plus/webviewx_plus.dart';

// // class WebViewXPage extends StatefulWidget {
// //   const WebViewXPage({
// //     Key? key,
// //   }) : super(key: key);

// //   @override
// //   _WebViewXPageState createState() => _WebViewXPageState();
// // }

// // class _WebViewXPageState extends State<WebViewXPage> {
// //   late WebViewXController webviewController;
// //   final scrollController = ScrollController();

// //   final initialContent =
// //       '<h4> This is some hardcoded HTML code embedded inside the webview <h4> <h2> Hello world! <h2>';
// //   final executeJsErrorMessage =
// //       'Failed to execute this task because the current content is (probably) URL that allows iFrame embedding, on Web.\n\n'
// //       'A short reason for this is that, when a normal URL is embedded in the iFrame, you do not actually own that content so you cant call your custom functions\n'
// //       '(read the documentation to find out why).';

// //   Size get screenSize => MediaQuery.of(context).size;

// //   @override
// //   void dispose() {
// //     webviewController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('WebViewX_Plus Page'),
// //       ),
// //       body: Center(
// //         child: Container(
// //           padding: const EdgeInsets.all(10.0),
// //           child: Column(
// //             children: <Widget>[
// //               buildSpace(direction: Axis.vertical, amount: 10.0, flex: false),
// //               Container(
// //                 padding: const EdgeInsets.only(bottom: 20.0),
// //                 child: Text(
// //                   'Play around with the buttons below',
// //                   style: Theme.of(context).textTheme.headline6,
// //                 ),
// //               ),
// //               buildSpace(direction: Axis.vertical, amount: 10.0, flex: false),
// //               Container(
// //                 decoration: BoxDecoration(
// //                   border: Border.all(width: 0.2),
// //                 ),
// //                 child: _buildWebViewX(),
// //               ),
// //               Expanded(
// //                 child: Scrollbar(
// //                   controller: scrollController,
// //                   thumbVisibility: true,
// //                   child: SizedBox(
// //                     width: min(screenSize.width * 0.8, 512),
// //                     child: ListView(
// //                       controller: scrollController,
// //                       children: _buildButtons(),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildWebViewX() {
// //     return WebViewX(
// //       key: const ValueKey('webviewx'),
// //       initialContent: initialContent,
// //       initialSourceType: SourceType.html,
// //       height: screenSize.height / 2,
// //       width: min(screenSize.width * 0.8, 1024),
// //       onWebViewCreated: (controller) => webviewController = controller,
// //       onPageStarted: (src) =>
// //           debugPrint('A new page has started loading: $src\n'),
// //       onPageFinished: (src) =>
// //           debugPrint('The page has finished loading: $src\n'),
// //       jsContent: const {
// //         EmbeddedJsContent(
// //           js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
// //         ),
// //         EmbeddedJsContent(
// //           webJs:
// //               "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
// //           mobileJs:
// //               "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
// //         ),
// //       },
// //       dartCallBacks: {
// //         DartCallback(
// //           name: 'TestDartCallback',
// //           callBack: (msg) => showSnackBar(msg.toString(), context),
// //         )
// //       },
// //       webSpecificParams: const WebSpecificParams(
// //         printDebugInfo: true,
// //       ),
// //       mobileSpecificParams: const MobileSpecificParams(
// //         androidEnableHybridComposition: true,
// //       ),
// //       navigationDelegate: (navigation) {
// //         debugPrint(navigation.content.sourceType.toString());
// //         return NavigationDecision.navigate;
// //       },
// //     );
// //   }

// //   void _setUrl() {
// //     webviewController.loadContent(
// //       'https://flutter.dev',
// //     );
// //   }

// //   void _setUrlBypass() {
// //     webviewController.loadContent(
// //       'https://news.ycombinator.com/',
// //       sourceType: SourceType.urlBypass,
// //     );
// //   }

// //   void _setHtml() {
// //     webviewController.loadContent(
// //       initialContent,
// //       sourceType: SourceType.html,
// //     );
// //   }

// //   void _setHtmlFromAssets() {
// //     webviewController.loadContent(
// //       'assets/test2.html',
// //       sourceType: SourceType.html,
// //       fromAssets: true,
// //     );
// //   }

// //   Future<void> _goForward() async {
// //     if (await webviewController.canGoForward()) {
// //       await webviewController.goForward();
// //       showSnackBar('Did go forward', context);
// //     } else {
// //       showSnackBar('Cannot go forward', context);
// //     }
// //   }

// //   Future<void> _goBack() async {
// //     if (await webviewController.canGoBack()) {
// //       await webviewController.goBack();
// //       showSnackBar('Did go back', context);
// //     } else {
// //       showSnackBar('Cannot go back', context);
// //     }
// //   }

// //   void _reload() {
// //     webviewController.reload();
// //   }

// //   void _toggleIgnore() {
// //     final ignoring = webviewController.ignoresAllGestures;
// //     webviewController.setIgnoreAllGestures(!ignoring);
// //     showSnackBar('Ignore events = ${!ignoring}', context);
// //   }

// //   Future<void> _evalRawJsInGlobalContext() async {
// //     try {
// //       final result = await webviewController.evalRawJavascript(
// //         '2+2',
// //         inGlobalContext: true,
// //       );
// //       showSnackBar('The result is $result', context);
// //     } catch (e) {
// //       showAlertDialog(
// //         executeJsErrorMessage,
// //         context,
// //       );
// //     }
// //   }

// //   Future<void> _callPlatformIndependentJsMethod() async {
// //     try {
// //       await webviewController.callJsMethod('testPlatformIndependentMethod', []);
// //     } catch (e) {
// //       showAlertDialog(
// //         executeJsErrorMessage,
// //         context,
// //       );
// //     }
// //   }

// //   Future<void> _callPlatformSpecificJsMethod() async {
// //     try {
// //       await webviewController
// //           .callJsMethod('testPlatformSpecificMethod', ['Hi']);
// //     } catch (e) {
// //       showAlertDialog(
// //         executeJsErrorMessage,
// //         context,
// //       );
// //     }
// //   }

// //   Future<void> _getWebviewContent() async {
// //     try {
// //       final content = await webviewController.getContent();
// //       showAlertDialog(content.source, context);
// //     } catch (e) {
// //       showAlertDialog('Failed to execute this task.', context);
// //     }
// //   }

// //   Widget buildSpace({
// //     Axis direction = Axis.horizontal,
// //     double amount = 0.2,
// //     bool flex = true,
// //   }) {
// //     return flex
// //         ? Flexible(
// //             child: FractionallySizedBox(
// //               widthFactor: direction == Axis.horizontal ? amount : null,
// //               heightFactor: direction == Axis.vertical ? amount : null,
// //             ),
// //           )
// //         : SizedBox(
// //             width: direction == Axis.horizontal ? amount : null,
// //             height: direction == Axis.vertical ? amount : null,
// //           );
// //   }

// //   List<Widget> _buildButtons() {
// //     return [
// //       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
// //       Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Expanded(child: createButton(onTap: _goBack, text: 'Back')),
// //           buildSpace(amount: 12, flex: false),
// //           Expanded(child: createButton(onTap: _goForward, text: 'Forward')),
// //           buildSpace(amount: 12, flex: false),
// //           Expanded(child: createButton(onTap: _reload, text: 'Reload')),
// //         ],
// //       ),
// //       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
// //       createButton(
// //         text:
// //             'Change content to URL that allows iFrames embedding\n(https://flutter.dev)',
// //         onTap: _setUrl,
// //       ),
// //       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
// //       createButton(
// //         text:
// //             'Change content to URL that doesnt allow iFrames embedding\n(https://news.ycombinator.com/)',
// //         onTap: _setUrlBypass,
// //       ),
// //       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
// //       createButton(
// //         text: 'Change content to HTML (hardcoded)',
// //         onTap: _setHtml,
// //       ),
// //       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
// //       createButton(
// //         text: 'Change content to HTML (from assets)',
// //         onTap: _setHtmlFromAssets,
// //       ),
// //       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
// //       createButton(
// //         text: 'Toggle on/off ignore any events (click, scroll etc)',
// //         onTap: _toggleIgnore,
// //       ),
// //       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
// //       createButton(
// //         text: 'Evaluate 2+2 in the global "window" (javascript side)',
// //         onTap: _evalRawJsInGlobalContext,
// //       ),
// //       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
// //       createButton(
// //         text: 'Call platform independent Js method (console.log)',
// //         onTap: _callPlatformIndependentJsMethod,
// //       ),
// //       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
// //       createButton(
// //         text:
// //             'Call platform specific Js method, that calls back a Dart function',
// //         onTap: _callPlatformSpecificJsMethod,
// //       ),
// //       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
// //       createButton(
// //         text: 'Show current webview content',
// //         onTap: _getWebviewContent,
// //       ),
// //     ];
// //   }
// // }

// // /// This dialog will basically show up right on top of the webview.
// // ///
// // /// AlertDialog is a widget, so it needs to be wrapped in `WebViewAware`, in order
// // /// to be able to interact (on web) with it.
// // ///
// // /// Read the `Readme.md` for more info.
// // void showAlertDialog(String content, BuildContext context) {
// //   showDialog(
// //     context: context,
// //     builder: (_) => WebViewAware(
// //       child: AlertDialog(
// //         content: Text(content),
// //         actions: [
// //           TextButton(
// //             onPressed: Navigator.of(context).pop,
// //             child: const Text('Close'),
// //           ),
// //         ],
// //       ),
// //     ),
// //   );
// // }

// // void showSnackBar(String content, BuildContext context) {
// //   ScaffoldMessenger.of(context)
// //     ..hideCurrentSnackBar()
// //     ..showSnackBar(
// //       SnackBar(
// //         content: Text(content),
// //         duration: const Duration(seconds: 1),
// //       ),
// //     );
// // }

// // Widget createButton({
// //   VoidCallback? onTap,
// //   required String text,
// // }) {
// //   return ElevatedButton(
// //     onPressed: onTap,
// //     style: ElevatedButton.styleFrom(
// //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
// //     ),
// //     child: Text(text),
// //   );
// // }
