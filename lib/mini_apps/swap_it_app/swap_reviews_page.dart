import 'package:fibali/fibali_core/models/swap_review.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/ui/widgets/pop_button.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:get/get.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class SwapReviewsPage extends StatelessWidget {
  const SwapReviewsPage({
    super.key,
    required this.userID,
  });
  final String userID;

  static Future<dynamic>? showPage({
    required String userID,
  }) {
    return Get.to(() => SwapReviewsPage(userID: userID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          RCCubit.instance.getText(R.reviews),
          style: GoogleFonts.fredokaOne(color: Colors.grey),
        ),
        elevation: 0,
        leading: const PopButton(),
      ),
      body: Column(
        children: [
          const Divider(
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          Expanded(
            child: FirestoreQueryBuilder<SwapReview>(
              query: SwapReview.ref(userID: userID),
              pageSize: 4,
              builder: (context, snapshot, _) {
                if (snapshot.isFetching) {
                  return const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Text('error ${snapshot.error}');
                }

                if (snapshot.docs.isEmpty) {
                  return const SizedBox();
                }

                final reviews = snapshot.docs
                    .map((query) => query.data())
                    .where((review) => review.isValid())
                    .toList();

                if (reviews.isEmpty) return const SizedBox();

                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: reviews.length,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    // if we reached the end of the currently obtained items, we try to
                    // obtain more items
                    if (snapshot.hasMore && itemIndex + 1 == reviews.length) {
                      // Tell FirestoreQueryBuilder to try to obtain more items.
                      // It is safe to call this function from within the build method.
                      snapshot.fetchMore();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                          trailing: reviews[itemIndex].rating != null
                              ? RatingBarIndicator(
                                  rating: reviews[itemIndex].rating!.toDouble(),
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 18.0,
                                )
                              : null,
                          title: reviews[itemIndex].userName != null
                              ? Text(
                                  reviews[itemIndex].userName!,
                                  style: const TextStyle(),
                                )
                              : null,
                          subtitle: reviews[itemIndex].reviewText != null
                              ? Text(
                                  reviews[itemIndex].reviewText!,
                                  style: const TextStyle(),
                                )
                              : null,
                          horizontalTitleGap: 0,
                        ),
                        if (reviews[itemIndex].photoUrls?.isNotEmpty == true)
                          Wrap(
                            alignment: WrapAlignment.end,
                            children: reviews[itemIndex]
                                .photoUrls!
                                .map((photo) => Card(
                                      child: PhotoWidget.network(
                                        photoUrl: photo,
                                        canDisplay: true,
                                        height: 70,
                                        width: 70,
                                      ),
                                    ))
                                .toList(),
                          )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
