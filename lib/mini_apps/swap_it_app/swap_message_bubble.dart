import 'package:fibali/ui/swap_events_page.dart';
import 'package:fibali/fibali_core/models/message.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SwapMessageBubble extends StatelessWidget {
  const SwapMessageBubble({
    super.key,
    required this.currentUserID,
    required this.message,
    required this.receiverName,
    required this.receiverPhoto,
  });

  final String currentUserID;
  final Message message;
  final String receiverName;
  final String? receiverPhoto;

  @override
  Widget build(BuildContext context) {
    final list1 = message.otherItems?.values
        .whereType<List<dynamic>>()
        .where((list) => list.isNotEmpty)
        .map((list) => PhotoWidget.network(
              photoUrl: list[0],
              fit: BoxFit.cover,
              width: Get.width / 2,
            ))
        .toList();

    final list2 = message.senderItems?.values
        .whereType<List<dynamic>>()
        .where((list) => list.isNotEmpty)
        .map((list) => PhotoWidget.network(
              photoUrl: list[0],
              fit: BoxFit.cover,
              width: Get.width / 2,
            ))
        .toList();

    return Padding(
      padding: currentUserID == message.senderID
          ? EdgeInsets.only(
              left: Get.width / 8,
              right: Get.width / 40,
              top: Get.width / 20,
              bottom: Get.width / 20,
            )
          : EdgeInsets.only(
              left: Get.width / 40,
              right: Get.width / 8,
              top: Get.width / 20,
              bottom: Get.width / 20,
            ),
      child: GestureDetector(
        onTap: () {
          SwapEventsPage.showPage(swapID: message.swap?['swapID']);
        },
        child: Card(
          color: Colors.white,
          elevation: 0,
          child: Column(
            children: [
              ListTile(
                leading: PhotoWidget.network(photoUrl: message.senderPhoto),
                title: Text(message.senderName!),
                dense: true,
                // trailing: Text(
                //     message.timestamp != null
                //         ? timeago.format(message.timestamp!.toDate())
                //         : '',
                //     style: const TextStyle(
                //       fontSize: 12,
                //       fontWeight: FontWeight.bold,
                //     )),
                subtitle: Text(
                  message.type!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (list1?.isNotEmpty == true)
                        Column(
                            children: list1!
                                .map(
                                  (image) => SizedBox(
                                    height: Get.width / 3.5,
                                    width: Get.width / 3.5,
                                    child: Card(child: image),
                                  ),
                                )
                                .toList())
                      else
                        const SizedBox(),
                      const VerticalDivider(thickness: 2),
                      if (list2?.isNotEmpty == true)
                        Column(
                            mainAxisSize: MainAxisSize.max,
                            children: list2!
                                .map((image) => SizedBox(
                                      height: Get.width / 3.5,
                                      width: Get.width / 3.5,
                                      child: Card(child: image),
                                    ))
                                .toList())
                      else
                        const SizedBox()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildElevatedButton({
    required String label,
    Function()? onPressed,
  }) {
    return Column(
      children: [
        const Divider(),
        TextButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.specialElite(
              fontSize: 15,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
