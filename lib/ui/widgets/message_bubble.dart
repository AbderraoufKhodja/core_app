import 'package:fibali/bloc/messaging/bloc.dart';
import 'package:fibali/mini_apps/swap_it_app/swap_message_bubble.dart';
import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:translator/translator.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final String currentUserId;
  final String receiverName;
  final String? receiverPhoto;
  final bool hasPendingWrites;
  final bool isShowTimestamp;

  const MessageBubble({
    super.key,
    required this.currentUserId,
    required this.message,
    required this.hasPendingWrites,
    required this.isShowTimestamp,
    required this.receiverName,
    this.receiverPhoto,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  MessagingBloc get _messagingBloc => BlocProvider.of<MessagingBloc>(context);

  String? translation;
  FutureBuilder? futureTranslation;

  @override
  Widget build(BuildContext context) {
    final String timeAgo =
        widget.message.timestamp != null ? timeago.format(widget.message.timestamp!.toDate()) : '';
    return GestureDetector(
      onLongPress: () async {
        await Get.dialog(
            Center(
              child: Card(
                color: Colors.blueGrey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.message.text != null)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    futureTranslation = FutureBuilder<Translation>(
                                        future: _messagingBloc.translator
                                            .translate(widget.message.text!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return SizedBox(
                                              width: 30,
                                              height: 20,
                                              child: SpinKitThreeBounce(
                                                size: 15,
                                                itemBuilder: (context, index) => const Icon(
                                                  Icons.circle_outlined,
                                                  size: 5,
                                                ),
                                              ),
                                            );
                                          }

                                          if (snapshot.data?.text != null) {
                                            return Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 2),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5)),
                                              child: Text(
                                                snapshot.data!.text,
                                                style: Theme.of(context).textTheme.bodySmall,
                                              ),
                                            );
                                          }

                                          return const Text('Uknown');
                                        });

                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.g_translate_sharp),
                                ),
                                Text(
                                  'Translate',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.format_quote),
                              ),
                              Text(
                                'Quote',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            barrierColor: Colors.transparent);
      },
      child: Column(
        crossAxisAlignment: widget.message.senderID == widget.currentUserId
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          widget.isShowTimestamp
              ? Center(
                  child: Text(timeAgo),
                )
              : const SizedBox(),
          Column(
            children: [
              buildMessage(),
            ],
          ),
          if (futureTranslation != null)
            const Text(
              '  Translation by Google  ',
              style: TextStyle(fontSize: 8),
            )
        ],
      ),
    );
  }

  Widget buildMessage() {
    switch (Utils.enumFromString(MessageTypes.values, widget.message.type ?? '')) {
      case MessageTypes.text:
        return buildTextWidget();
      case MessageTypes.newSwap:
        if (widget.message.senderItems != null && widget.message.otherItems != null) {
          return SwapMessageBubble(
            currentUserID: widget.currentUserId,
            message: widget.message,
            receiverName: widget.receiverName,
            receiverPhoto: widget.receiverPhoto,
          );
        } else {
          return const SizedBox();
        }
      case MessageTypes.swapAccepted:
        if (widget.message.senderItems != null && widget.message.otherItems != null) {
          return SwapMessageBubble(
            currentUserID: widget.currentUserId,
            message: widget.message,
            receiverName: widget.receiverName,
            receiverPhoto: widget.receiverPhoto,
          );
        } else {
          return const SizedBox();
        }
      case MessageTypes.call:
        return buildCallWidget();

      case MessageTypes.photo:
        return buildMessageWrap(
          size: Get.size,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.message.text != null)
                Text(
                  widget.message.text!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (widget.message.photoUrls != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.message.photoUrls!
                      .map((url) => Card(
                            child: PhotoWidget.network(
                              canDisplay: true,
                              photoUrl: url,
                            ),
                          ))
                      .toList(),
                )
              else if (widget.message.photoUrl != null)
                Card(
                  child: PhotoWidget.network(
                    canDisplay: true,
                    photoUrl: widget.message.photoUrl,
                  ),
                ),
            ],
          ),
        );
      case MessageTypes.location:
        if (widget.message.location != null) {
          return buildMessageWrap(
            size: Get.size,
            content: GestureDetector(
              onTap: () async {
                final availableMaps = await MapLauncher.installedMaps;
                debugPrint(availableMaps
                    .toString()); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                await availableMaps.first.showMarker(
                  coords: Coords(
                    widget.message.location!.latitude,
                    widget.message.location!.longitude,
                  ),
                  title: "Location",
                );
              },
              child: Card(
                child: SvgPicture.asset(
                  'assets/roadMap.svg',
                  height: Get.height / 5,
                  width: Get.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      case null:
        return const SizedBox();
    }
  }

  Widget buildTextWidget() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      children: <Widget>[
        widget.message.senderID == widget.currentUserId
            ? widget.hasPendingWrites
                ? SizedBox(
                    width: Get.width / 50,
                    height: Get.width / 50,
                    child: const CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 1,
                    ),
                  )
                : SizedBox(
                    width: Get.width / 50,
                    height: Get.width / 50,
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.blueAccent,
                      size: Get.width / 35,
                    ),
                  )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Get.width * 0.7),
            child: Container(
              decoration: BoxDecoration(
                color: widget.message.senderID == widget.currentUserId
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).cardColor,
                borderRadius: widget.message.senderID == widget.currentUserId
                    ? BorderRadius.only(
                        topLeft: Radius.circular(Get.height * 0.02),
                        topRight: Radius.circular(Get.height * 0.02),
                        bottomLeft: Radius.circular(Get.height * 0.02),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(Get.height * 0.02),
                        bottomLeft: Radius.circular(Get.height * 0.02),
                        bottomRight: Radius.circular(Get.height * 0.02),
                      ),
              ),
              padding: EdgeInsets.all(Get.height * 0.01),
              child: widget.message.text != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.message.text!,
                          style: widget.message.senderID == widget.currentUserId
                              ? const TextStyle(color: Colors.white)
                              : null,
                        ),
                        if (futureTranslation != null) futureTranslation!,
                      ],
                    )
                  : const Icon(Icons.info),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCallWidget() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      children: <Widget>[
        widget.message.senderID == widget.currentUserId
            ? widget.hasPendingWrites
                ? SizedBox(
                    width: Get.width / 50,
                    height: Get.width / 50,
                    child: const CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 1,
                    ),
                  )
                : SizedBox(
                    width: Get.width / 50,
                    height: Get.width / 50,
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.blueAccent,
                      size: Get.width / 35,
                    ),
                  )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Get.width * 0.7),
            child: Container(
              decoration: BoxDecoration(
                color: widget.message.senderID == widget.currentUserId
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                borderRadius: widget.message.senderID == widget.currentUserId
                    ? BorderRadius.only(
                        topLeft: Radius.circular(Get.height * 0.02),
                        topRight: Radius.circular(Get.height * 0.02),
                        bottomLeft: Radius.circular(Get.height * 0.02),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(Get.height * 0.02),
                        bottomLeft: Radius.circular(Get.height * 0.02),
                        bottomRight: Radius.circular(Get.height * 0.02),
                      ),
              ),
              padding: EdgeInsets.all(Get.height * 0.01),
              child: widget.message.status != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          RCCubit.instance.getCloudText(context, widget.message.status!),
                          style: widget.message.senderID == widget.currentUserId
                              ? const TextStyle(color: Colors.white)
                              : null,
                        ),
                        const Icon(
                          Icons.phone_rounded,
                          color: Colors.grey,
                        )
                      ],
                    )
                  : const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }

  Wrap buildMessageWrap({required Size size, required Widget content}) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      children: <Widget>[
        widget.message.senderID == widget.currentUserId
            ? widget.hasPendingWrites
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: const CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 1,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.blueAccent,
                      size: 10,
                    ),
                  )
            : const SizedBox(),
        Padding(
          padding: EdgeInsets.all(size.height * 0.01),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width * 0.7, maxHeight: size.width * 0.8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.height * 0.02),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size.height * 0.02),
                child: content,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
