import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TranslatorReviewPage extends StatefulWidget {
  final dynamic Function(
    num rating,
    String? ratingText,
  ) onSubmitted;
  const TranslatorReviewPage({super.key, required this.onSubmitted});

  @override
  TranslatorReviewPageState createState() => TranslatorReviewPageState();
}

class TranslatorReviewPageState extends State<TranslatorReviewPage> {
  final _commentController = TextEditingController();

  num _rating = 3;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: [
          Text(
            RCCubit.instance.getText(R.review),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const Divider(color: Colors.white),
          TextFormField(
            controller: _commentController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white),
              ),
              fillColor: Colors.white70.withOpacity(0.5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              floatingLabelStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            maxLength: 500,
            maxLines: 8,
            minLines: 4,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: RatingBar.builder(
                initialRating: 4,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                unratedColor: Colors.white70.withOpacity(0.5),
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _rating = rating;
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  RCCubit.instance.getText(R.submit),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

showReviewPage(
  context, {
  required dynamic Function(num rating, String? ratingText) onSubmitted,
}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TranslatorReviewPage(onSubmitted: onSubmitted),
    ),
  );
}
