import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoubleCirclesWidget extends StatelessWidget {
  const DoubleCirclesWidget({
    Key? key,
    required this.child,
    required this.title,
    required this.description,
  }) : super(key: key);

  final Widget child;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Get.width / 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey.shade300,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, top: 24.0),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey.shade400.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14.0, bottom: 14.0),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            if (description != null)
              Text(
                description!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
