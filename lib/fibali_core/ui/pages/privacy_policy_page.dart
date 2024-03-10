import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as md;

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static show() => Get.to(() => const PrivacyPolicyPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RCCubit.instance.getText(R.privacyTerms)),
        leading: const PopButton(),
      ),
      body: Markdown(
        // style for user terms small GoogleFonts.cairo font size
        data: privacyPolicy,
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
    );
  }

  final privacyPolicy = '''### Privacy Policy

This privacy policy describes how Fibali (“we”, “us”, or “our”) collects, uses, and shares personal data from our users (“you”) when you use our app. 

#### What data do we collect? 

We collect the following types of data from you: 

**Account data:** When you sign up for Fibali, we ask you to provide your name, email address, password, and profile picture. You can also choose to add other information to your profile, such as your location, interests, preferences, and bio. 

**Item data:** When you post items for swapping on Fibali, we collect the information you provide about the items, such as the category, condition, value, description, and photos. We also collect the information about the items you browse, like, or request to swap on Fibali. 

**Chat data:** When you chat with other users on Fibali, we collect the content of your messages, as well as any photos, videos, or voice messages you send or receive. We also collect the metadata of your chats, such as the time and date of your messages and the status of your swaps. 

**Location data:** When you use Fibali, we collect your approximate location based on your IP address or GPS data (if you enable it). We use this data to show you items and users near you and to help you find a convenient place to meet up and complete the swap. 

**Device data:** When you use Fibali, we collect some information about your device, such as the type, model, operating system, browser, language, and unique identifiers. We use this data to provide and improve our app functionality and performance. 

**Usage data:** When you use Fibali, we collect some information about how you use our app, such as the pages you visit, the features you use, the actions you take, the errors you encounter, and the duration and frequency of your sessions. We use this data to analyze and improve our app quality and user experience. 

#### How do we use your data? 

We use your data for the following purposes: 

**To provide our app:** We use your data to enable you to access and use our app features and services. For example, we use your account data to create and manage your account; we use your item data to show you items for swapping; we use your chat data to facilitate communication between you and other users; we use your location data to show you items and users near you; we use your device data to ensure compatibility and functionality of our app; we use your usage data to monitor and improve our app performance and quality. 

**To personalize our app:** We use your data to customize and enhance our app for you. For example, we use your account data to show you relevant content based on your interests and preferences; we use your item data to recommend items that may interest you; we use your chat data to suggest potential matches based on your swapping history; we use your location data to show you local events and offers; we use your device data to optimize our app layout and design for your screen size; we use your usage data to tailor our app features and services for your needs. 

**To communicate with you:** We use your data to communicate with you about our app. For example, we use your account data to send you notifications about your account activity; we use your chat data to notify you about new messages or swap requests; we use your location data to send you reminders about upcoming swaps; we use your device data to send you updates or alerts about our app; we use your usage data to send you feedback requests or surveys. 

**To market our app:** We use your data to promote our app and our partners. For example, we use your account data to send you newsletters or promotional emails about our app or our partners; we use your item data to show you ads or sponsored content related to your items; we use your chat data to show you testimonials or reviews from other users; we use your location data to show you local deals or discounts from our partners; we use your device data to show you targeted ads or offers based on your device characteristics; we use your usage data to show you personalized ads or offers based on your app behavior. 

#### How do we share your data? 

We share your data with the following parties: 

**Other users:** We share some of your data with other users when you use our app. For example, we share your account data (except your email address and password) with other users when they view your profile; we share your item data with other users when they view your items; we share your chat data with other users when you chat with them; we share your location data with other users when you agree to meet up and complete the swap. 

**Service providers:** We share some of your data with third-party service providers who help us provide and improve our app. For example, we share your account data with service providers who help us store, secure, and manage your data; we share your item data with service providers who help us process, analyze, and display your items; we share your chat data with service providers who help us transmit, encrypt, and moderate your messages; we share your location data with service providers who help us map, geolocate, and navigate your location; we share your device data with service providers who help us monitor, test, and optimize our app functionality and performance; we share your usage data with service providers who help us measure, analyze, and improve our app quality and user experience. 

**Law enforcement and regulators:** We may share some of your data with law enforcement and regulators if required by law or if necessary to protect our rights and interests. For example, we may share your account data with law enforcement and regulators if they request it for legal purposes; we may share your item data with law enforcement and regulators if they investigate illegal or fraudulent activities involving our app; we may share your chat data with law enforcement and regulators if they monitor abusive or harmful behavior on our app; we may share your location data with law enforcement and regulators if they track criminal or suspicious activity on our app; we may share your device data with law enforcement and regulators if they identify malicious or unauthorized access to our app; we may share your usage data with law enforcement and regulators if they audit or enforce our compliance with the law. 

#### How do we protect your data? 

We take reasonable measures to protect your data from unauthorized access, use, disclosure, modification, or destruction. For example, we use encryption, authentication, firewalls, backups, and audits to safeguard your data. However, no method of transmission or storage is completely secure, so we cannot guarantee the absolute security of your data. 

#### How long do we keep your data? 

We keep your data for as long as necessary to provide our app features and services to you. For example, we keep your account data until you delete or deactivate your account; we keep your item data until you delete or swap the items; we keep your chat data until you delete the messages or swaps; we keep your location data until you turn off the location services or uninstall the app; we keep your device data until you stop using the app or change the device settings; we keep your usage data until you stop using the app or request that it be deleted. 

You can request that we delete some or all of your personal data at any time by contacting us at piicubic@gmail.com. We will respond to your request within a reasonable time frame. However, please note that some of your personal data may be retained for legal, regulatory, or operational purposes. 

#### What are your rights? 

You have the following rights regarding your personal data: 

**Access:** You have the right to access your personal data that we hold about you. 

**Correction:** You have the right to correct any inaccurate or incomplete personal data that we hold about you. 

**Deletion:** You have the right to request that we delete some or all of your personal data that we hold about you. 

**Objection:** You have the right to object to our processing of your personal data for certain purposes, such as marketing or profiling. 

**Restriction:** You have the right to request that we limit our processing of your personal data in certain circumstances, such as when you contest the accuracy or legality of our data processing. 

**Portability:** You have the right to request that we transfer your personal data to another service provider in a structured, commonly used, and machine-readable format. 

**Consent:** You have the right to withdraw your consent to our processing of your personal data at any time, where applicable. 

To exercise any of these rights, please contact us at piicubic@gmail.com. We will respond to your request within a reasonable time frame and in accordance with the law. Please note that some of these rights may be subject to limitations or exceptions based on the law, our legitimate interests, or contractual obligations. 

#### How do we use cookies and similar technologies? 

We use cookies and similar technologies, such as web beacons, pixels, and local storage, to collect and store some of your data when you use our app. Cookies are small files that are stored on your device by your browser. They allow us to recognize your device, remember your preferences, enhance your app experience, and deliver relevant ads or offers to you. You can manage your cookie settings in your browser or device settings. However, please note that disabling or blocking cookies may affect some of our app features and services. 

#### How do we update our privacy policy? 

We may update our privacy policy from time to time to reflect changes in our app features and services, legal requirements, or user feedback. We will notify you of any material changes by posting a notice on our app or by sending you an email. We encourage you to review our privacy policy periodically to stay informed about how we collect, use, and share your personal data. 

#### How do you contact us? 

If you have any questions, comments, or complaints about our privacy policy or data practices, please contact us at: 

 piicubic@gmail.com 

We will do our best to resolve any issues or concerns you may have. 

Thank you for using Fibali!''';
}
