import 'package:fibali/fibali_core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fibali/mini_apps/translator_app/utils/md_app_colors.dart';
import 'package:fibali/fibali_core/models/translator.dart';
import 'package:fibali/fibali_core/ui/widgets/photo_widget.dart';

class TopTranslatorCard extends StatelessWidget {
  const TopTranslatorCard({
    super.key,
    required this.translator,
  });

  final Translator translator;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //--------------------------------------------
        //------LIKE, REVIEWS AND MESSAGE BUTTONS
        //-------------------------------------------
        _WhiteBackground(translator: translator),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 150,
            child: Stack(
              children: <Widget>[
                //----------------------------------
                //-----BLUE BACKGROUND
                //---------------------------------
                Container(
                  width: 280,
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.only(
                    left: 120,
                    bottom: 5,
                    right: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        MdAppColors.kLightBlue,
                        MdAppColors.kBlue,
                      ],
                    ),
                  ),
                  child: _DoctorInformation(translator: translator),
                ),
                //-----------------------------
                //------PNG DOCTOR IMAGE
                //-----------------------------
                Positioned(
                  bottom: 20,
                  left: 8,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DoctorInformation extends StatelessWidget {
  const _DoctorInformation({
    required this.translator,
  });

  final Translator translator;

  @override
  Widget build(BuildContext context) {
    final countTextStyle = TextStyle(
      color: Colors.white.withOpacity(.8),
      fontWeight: FontWeight.w600,
      height: 1,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //--------------------------------------------
        //------NAME DOCTOR AND SPECIALIZATION
        //--------------------------------------------
        Text(
          'Dr. ${translator.firstName}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          translator.languages!.join(' | '),
          style: const TextStyle(
            height: 1,
            color: Colors.white70,
          ),
        ),
        const Spacer(),
        //-----------------------------------------------
        //-----INFORMATION
        //-----------------------------------------------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //-------------------------------
            //-----PATIENTS COUNT
            //-------------------------------
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Clients",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  translator.numCompletions.toString(),
                  style: countTextStyle,
                ),
              ],
            ),
            //-------------------------------
            //-----RATE
            //-------------------------------
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Rate",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
            )
          ],
        )
      ],
    );
  }
}

class _WhiteBackground extends StatelessWidget {
  const _WhiteBackground({
    required this.translator,
  });
  final Translator translator;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.fromLTRB(10, 70, 10, 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 20,
            offset: const Offset(-5, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildIconButton(
            iconData: Icons.favorite,
            label: "${translator.numLikes} likes",
          ),
          _buildIconButton(
            iconData: Icons.comment,
            label: "${translator.numReviews} reviews",
          ),
          _buildIconButton(
            iconData: Icons.send,
            label: "Message",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required String label,
    required IconData iconData,
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        Icon(
          iconData,
          color: MdAppColors.kDarkTeal,
          size: 16,
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: MdAppColors.kDarkTeal,
          ),
        ),
      ],
    );
  }
}
