import 'package:fibali/fibali_core/models/swap.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:flutter/material.dart';

class SwapCard extends StatelessWidget {
  final Swap swap;

  const SwapCard({
    super.key,
    required this.swap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Swap Details',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    child: PhotoWidgetNetwork(
                      label: swap.senderName,
                      photoUrl: swap.senderPhoto,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    swap.senderName!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Items:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  // itemCount: swap.senderItemsID!.length,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(
                        // swap.senderItemImages[index],
                        kImages.reversed.toList()[index],
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.cover,
                      ),
                      // title: Text(swap.senderItems[index]),
                      title: Text(kFaker.lorem.word()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    child: PhotoWidgetNetwork(
                      photoUrl: swap.receiverPhoto,
                      label: swap.receiverName,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    swap.receiverName!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Items:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    // itemCount: swap.receiverItemsID!.length,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(
                          // swap.receiverItemsID![index],
                          kImages.reversed.toList()[index],

                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.cover,
                        ),
                        // title: Text(swap.receiverItemsID![index]),
                        title: Text(kFaker.lorem.word()),
                      );
                    }),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Swap Date: ',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Swap Location: ',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Swap Status: ',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
