import 'package:fibali/fibali_core/ui/widgets/curved_button.dart';
import 'package:fibali/fibali_core/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:fibali/fibali_core/bloc/remote_config/remote_config_cubit.dart';
import 'package:fibali/fibali_core/models/translator.dart';
import 'package:fibali/fibali_core/ui/constants.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

class TranslatorCard extends StatelessWidget {
  const TranslatorCard({
    super.key,
    required this.translator,
  });

  final Translator translator;

  @override
  Widget build(BuildContext context) {
    final countTextStyle = TextStyle(
      color: Colors.blueGrey.withOpacity(.8),
      fontWeight: FontWeight.w600,
      height: 1,
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. ${translator.firstName}',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (translator.languages != null)
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 4,
                      children: translator.languages!
                          .map(
                            (language) => CurvedButton(
                              color: Colors.grey.shade300,
                              child: Text(
                                RCCubit.instance.getCloudText(context, language),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            RCCubit.instance.getText(R.rating),
                            style: TextStyle(
                              color: Colors.blueGrey.withOpacity(.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                translator.avgRating.toString(),
                                style: countTextStyle,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 16,
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                        child: VerticalDivider(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            RCCubit.instance.getText(R.translations),
                            style: TextStyle(
                              color: Colors.blueGrey.withOpacity(.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            translator.numCompletions.toString(),
                            style: countTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ]
                    .map((widget) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: widget,
                        ))
                    .toList(),
              ),
              const Spacer(),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  maxRadius: 53,
                  child: PhotoWidgetNetwork(
                    label: Utils.getInitial(
                        '${translator.firstName ?? ''} ${translator.lastName ?? ''}'),
                    photoUrl: translator.photoUrl ?? '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    boxShape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (translator.bio != null)
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: Text(
              RCCubit.instance.getText(R.biography),
              style: const TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              translator.bio ?? kFaker.lorem.sentences(3).join(),
              style: TextStyle(
                color: Colors.blueGrey.withOpacity(.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
