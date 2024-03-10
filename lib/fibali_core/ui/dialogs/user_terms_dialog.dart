// GetX dialog asking users to accept terms and conditions
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserTermsDialog extends StatelessWidget {
  final String title;
  final String content;
  final String acceptButtonText;
  final String declineButtonText;
  final Function onAccept;
  final Function onDecline;

  const UserTermsDialog({
    super.key,
    required this.title,
    required this.content,
    required this.acceptButtonText,
    required this.declineButtonText,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Text(content),
      ),
      actions: [
        ElevatedButton(
          child: Text(acceptButtonText),
          onPressed: () {
            onAccept();
            Get.back();
          },
        ),
        ElevatedButton(
          child: Text(declineButtonText),
          onPressed: () {
            onDecline();
            Get.back();
          },
        ),
      ],
    );
  }
}
