import 'package:flutter/material.dart';
import 'package:fibali/fibali_core/models/post.dart';
import 'package:fibali/mini_apps/shopping_app/ui/widgets/post_image_page.dart';

class OpenPostPage extends StatefulWidget {
  const OpenPostPage({
    super.key,
    required this.post,
  });

  final Post? post;

  @override
  OpenPostPageState createState() => OpenPostPageState();
}

class OpenPostPageState extends State<OpenPostPage> {
  late bool animate;

  @override
  void initState() {
    animate = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      return Future.delayed(
        kThemeChangeDuration,
        () => setState(() => animate = !animate),
      );
    });
    super.initState();
  }

  //---------------------------------------------------
  // Customized Flight Hero
  // Modify the hero animation during the transition.
  //---------------------------------------------------
  Widget _customFlightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (HeroFlightDirection.push == direction)
          OpenPostPage(post: widget.post)
        else
          const ColoredBox(color: Colors.white),
        AnimatedBuilder(
          animation: animation,
          builder: (_, __) {
            return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(1.6 * animation.value),
                alignment: Alignment.centerLeft,
                child: PostImagePage(
                  photoUrl: widget.post!.photoUrls![0],
                  photoUrl100x100: widget.post!.getThumbnailUrl100x100(0),
                  photoUrl250x375: widget.post!.getThumbnailUrl250x375(0),
                  photoUrl500x500: widget.post!.getThumbnailUrl500x500(0),
                ));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Hero(
        tag: widget.post!.description!,
        flightShuttleBuilder: _customFlightShuttleBuilder,
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: animate
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'CHAPTER 1',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              color: Colors.grey,
                              icon: const Icon(Icons.close),
                              onPressed: () async {
                                // setState(() => animate = !animate);
                                // await Future.delayed(kThemeChangeDuration);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                        Text(
                          widget.post!.description!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey[800],
                            height: 2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  widget.post!.description!,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }
}
