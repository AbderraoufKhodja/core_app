import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:fibali/bloc/authentication/auth_bloc.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/post_report.dart';
import 'package:fibali/fibali_core/models/swap_item_report.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';

import 'package:flamingo/flamingo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SwapItemReportPage extends StatefulWidget {
  final String reportedUserName;
  final String reportedUserUID;
  final String reportedItemID;

  const SwapItemReportPage({
    super.key,
    required this.reportedUserName,
    required this.reportedUserUID,
    required this.reportedItemID,
  });

  static Future<dynamic>? showPage({
    required String reportedUserName,
    required String reportedUserUID,
    required String reportedItemID,
  }) async {
    final needLogIn = await BlocProvider.of<AuthBloc>(Get.context!).needLogIn();
    if (needLogIn) {
      return;
    }

    return Get.to(() => SwapItemReportPage(
          reportedUserName: reportedUserName,
          reportedUserUID: reportedUserUID,
          reportedItemID: reportedItemID,
        ));
  }

  @override
  SwapItemReportPageState createState() => SwapItemReportPageState();
}

class SwapItemReportPageState extends State<SwapItemReportPage> {
  String _selectedReason = '';
  final _reasons = [
    'Spam',
    'Harassment',
    'Inappropriate content',
    'Hate speech',
    'Fake news',
    'Violence',
    'Bullying',
    'Impersonation',
    'Trolling',
    'Sexual content',
    'Other'
  ];
  final TextEditingController _messageController = TextEditingController();
  List<File>? _pickedFiles;
  List<StorageFile>? storageFiles;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  Future<void> _getImage() async {
    SettingsCubit.handlePickMultiGalleryCamera(
        onImagesSelected: (pickedImages) {
          setState(() {
            if (pickedImages.isNotEmpty == true) {
              _pickedFiles = pickedImages.map((file) => File(file.path)).toList();
            }
          });
        },
        maxNumWarning: RCCubit.instance.getText(R.sixImagesMax));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        leading: const PopButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Reported item from ${widget.reportedUserName}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 32),
          const Text(
            'Describe the reported behavior:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              hintText: 'Enter message description',
            ),
            maxLines: null,
          ),
          const SizedBox(height: 32),
          const Text(
            'Add a screenshot (optional):',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          _pickedFiles == null
              ? ElevatedButton(
                  onPressed: _getImage,
                  child: const Text('Select image'),
                )
              : Stack(
                  children: [
                    Column(
                      children: _pickedFiles!.map((file) => Card(child: Image.file(file))).toList(),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _pickedFiles = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 32),
          const Text(
            'Select a reason for the report:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Column(
            children: _reasons
                .map(
                  (reason) => RadioListTile(
                    title: Text(reason),
                    value: reason,
                    groupValue: _selectedReason,
                    onChanged: (value) {
                      setState(() {
                        _selectedReason = value.toString();
                      });
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _selectedReason.isNotEmpty
                ? () async {
                    try {
                      await reportMessage(
                        messageContent:
                            _messageController.text.isNotEmpty ? _messageController.text : null,
                        reportedUser: widget.reportedUserUID,
                        reportingUser: _currentUser?.uid,
                        reason: _selectedReason,
                      );
                    } on Exception catch (e) {
                      if (storageFiles?.isNotEmpty == true) {
                        Future.wait(storageFiles!.map((file) => Storage().delete(file)));
                      }

                      Logger().e(e);
                      EasyLoading.showError("Couldn't send report!");
                    }
                  }
                : null,
            child: const Text('Submit Report'),
          )
        ],
      ),
    );
  }

  Future<void> reportMessage({
    required String? messageContent,
    required String reportedUser,
    required String? reportingUser,
    required String reason,
  }) async {
    if (_currentUser?.uid.isNotEmpty != true) {
      throw Exception('User is not logged in');
    }

    final reportRef = ReportPost.ref.doc();
    List<String>? screenshots;

    EasyLoading.show(status: 'Sending report...', dismissOnTap: true);

    if (_pickedFiles?.isNotEmpty == true) {
      storageFiles = await Future.wait(_pickedFiles!
              .map((file) => Storage().save(
                    ReportPost.storageRef(reportID: reportRef.id),
                    File(file.path),
                  ))
              .toList())
          .then((storageFiles) => storageFiles);

      screenshots = storageFiles!.map((file) => file.url).toList();
    }

    final report = SwapItemReport(
      reportID: reportRef.id,
      messageContent: messageContent,
      reportedUID: reportedUser,
      reportingUID: reportingUser,
      reason: reason,
      screenshots: screenshots,
      reportedItemID: widget.reportedItemID,
    );

    return FirebaseFunctions.instance
        .httpsCallable('createSwapItemReport')
        .call(report.toJson())
        .then((value) {
      EasyLoading.dismiss();
      Get.dialog(
        AlertDialog(
          title: const Text('Report submitted'),
          content: const Text(
              'Thank you for your report. We will review and take appropriate actions within 24h.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    });
  }
}
