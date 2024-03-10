import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibali/bloc/authentication/bloc.dart';
import 'package:fibali/bloc/messaging/messaging_bloc.dart';
import 'package:fibali/fibali_core/bloc/settings/cubit/settings_cubit.dart';
import 'package:fibali/fibali_core/models/chat.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/ui/pages/google_map_page.dart';
import 'package:fibali/ui/widgets/confirm_send_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MessagingTextField extends StatefulWidget {
  final ChatTypes type;
  final String chatID;
  final AppUser otherUser;
  final String receiverName;
  final String? receiverPhoto;

  const MessagingTextField({
    Key? key,
    required this.type,
    required this.chatID,
    required this.otherUser,
    required this.receiverName,
    required this.receiverPhoto,
  }) : super(key: key);

  @override
  MessagingTextFieldState createState() => MessagingTextFieldState();
}

class MessagingTextFieldState extends State<MessagingTextField> {
  final _messageTextController = TextEditingController();
  final _picker = ImagePicker();

  String get _chatID => widget.chatID;

  AppUser? get _currentUser => BlocProvider.of<AuthBloc>(context).currentUser;

  MessagingBloc get _messagingBloc => BlocProvider.of<MessagingBloc>(context);

  @override
  void initState() {
    super.initState();
    _messageTextController.text = '';
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(45),
              elevation: 0,
              child: TextField(
                maxLines: 5,
                minLines: 1,
                controller: _messageTextController,
                textInputAction: TextInputAction.send,
                onSubmitted: (str) => _onMessageSubmitted(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.only(left: 20),
                  suffixIcon: buildSuffixIcons(),
                ),
                textAlignVertical: TextAlignVertical.center,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            borderRadius: BorderRadius.circular(45),
            elevation: 0,
            child: GestureDetector(
              onTap: _onMessageSubmitted,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Colors.black],
                    end: Alignment.topLeft,
                    begin: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.send,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSuffixIcons() {
    return IconButton(
      onPressed: () async {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.grey.shade100,
          constraints: BoxConstraints(
            maxHeight: Get.height,
            minHeight: Get.height * 0.4,
          ),
          isScrollControlled: true,
          builder: (context) => Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: buildBottomSheet(),
          ),
        );
      },
      icon: const Icon(
        Icons.add_circle_outline_rounded,
        color: Colors.grey,
        size: 30,
      ),
    );
  }

  Widget buildBottomSheet() {
    return SizedBox(
      height: 80,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: 50,
                width: 50,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                  onPressed: () async {
                    if (mounted) Navigator.pop(context);
                    XFile? imageFile;
                    try {
                      imageFile = await _picker.pickImage(
                        source: ImageSource.camera,
                        maxHeight: 1024,
                        maxWidth: 1024,
                      );
                    } catch (error) {
                      if (error is PlatformException) {
                        if (error.code == 'camera_access_denied') {
                          SettingsCubit.askSettingsCameraPermission();
                        }
                      }
                    }
                    if (imageFile != null) {
                      ConfirmSendImage.show(
                        chatID: widget.chatID,
                        imageFiles: [imageFile],
                        otherUser: widget.otherUser,
                        type: widget.type,
                        receiverName: widget.receiverName,
                        receiverPhoto: widget.receiverPhoto,
                      );
                    }
                  },
                ),
              ),
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                height: 50,
                width: 50,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.image,
                    size: 40,
                  ),
                  onPressed: () async {
                    if (mounted) Navigator.pop(context);
                    List<XFile>? imageFiles;
                    try {
                      imageFiles = await _picker.pickMultiImage(
                        maxHeight: 1024,
                        maxWidth: 1024,
                      );
                    } catch (error) {
                      if (error is PlatformException) {
                        if (error.code == 'photo_access_denied') {
                          SettingsCubit.askSettingsPhotosPermission();
                        }
                      }
                    }
                    if (imageFiles?.isNotEmpty == true) {
                      ConfirmSendImage.show(
                        chatID: widget.chatID,
                        imageFiles: imageFiles!,
                        otherUser: widget.otherUser,
                        type: widget.type,
                        receiverName: widget.receiverName,
                        receiverPhoto: widget.receiverPhoto,
                      );
                    }
                    // SettingsCubit.checkPhotoPermission(actionOnGranted: () async {
                    // });
                  },
                ),
              ),
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                height: 50,
                width: 50,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.location_on,
                    size: 40,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    final location = await showGoogleMaps();
                    if (location?.containsKey('geopoint') == true) {
                      if (location!['geopoint'] != null) {
                        MessagingBloc.sendMessage(
                          message: Message(
                            chatID: _chatID,
                            messageID: null,
                            type: MessageTypes.location.name,
                            item: null,
                            photoUrl: null,
                            order: null,
                            swap: null,
                            text: null,
                            senderItems: null,
                            otherItems: null,
                            location: location['geopoint'],
                            receiverID: widget.otherUser.uid,
                            senderName: _currentUser!.name,
                            senderID: _currentUser!.uid,
                            timestamp: FieldValue.serverTimestamp(),
                            appointmentID: null,
                            channelName: null,
                            createAt: null,
                            receiverName: null,
                            receiverPhoto: null,
                            senderPhoto: null,
                            status: null,
                            token: null,
                            photoUrls: null,
                          ),
                          type: widget.type,
                          senderID: _currentUser!.uid,
                          senderName: _currentUser!.name,
                          senderPhoto: _currentUser!.photoUrl,
                          receiverName: widget.receiverName,
                          receiverPhoto: widget.receiverPhoto,
                          photoFiles: null,
                          receiverID: widget.otherUser.uid,
                          chatID: _chatID,
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMessageSubmitted() {
    if (_messageTextController.text.isNotEmpty) {
      MessagingBloc.sendMessage(
        message: Message(
          messageID: null,
          chatID: _chatID,
          type: MessageTypes.text.name,
          text: _messageTextController.text,
          senderID: _currentUser!.uid,
          senderName: _currentUser!.name,
          receiverID: widget.otherUser.uid,
          location: null,
          senderItems: null,
          otherItems: null,
          photoUrl: null,
          item: null,
          order: null,
          swap: null,
          timestamp: FieldValue.serverTimestamp(),
          appointmentID: null,
          channelName: null,
          createAt: null,
          receiverName: null,
          receiverPhoto: null,
          senderPhoto: null,
          status: null,
          token: null,
          photoUrls: null,
        ),
        type: widget.type,
        senderID: _currentUser!.uid,
        senderName: _currentUser!.name,
        senderPhoto: _currentUser!.photoUrl,
        receiverID: widget.otherUser.uid,
        receiverName: widget.receiverName,
        receiverPhoto: widget.receiverPhoto,
        chatID: _chatID,
        photoFiles: null,
      );

      _messageTextController.clear();
    }
  }
}
