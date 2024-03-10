import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ChewieVideoWidget extends StatefulWidget {
  const ChewieVideoWidget({
    super.key,
    required this.video,
  });

  final dynamic video;

  @override
  State<StatefulWidget> createState() {
    return _ChewieVideoWidgetState();
  }
}

class _ChewieVideoWidgetState extends State<ChewieVideoWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = widget.video is String
        ? VideoPlayerController.networkUrl(Uri.parse(widget.video))
        : VideoPlayerController.file(widget.video);

    await _videoPlayerController.initialize();
    _createChewieController();

    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      controlsSafeAreaMinimum:
          EdgeInsets.only(bottom: Get.bottomBarHeight * 2.5),
      draggableProgressBar: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      // subtitleBuilder: (context, dynamic subtitle) => Container(
      //   padding: const EdgeInsets.all(10.0),
      //   child: subtitle is InlineSpan
      //       ? RichText(
      //           text: subtitle,
      //         )
      //       : Text(
      //           subtitle.toString(),
      //           style: const TextStyle(color: Colors.black),
      //         ),
      // ),
      hideControlsTimer: const Duration(seconds: 4),
    );
  }

  int currPlayIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Center(
          child: _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(controller: _chewieController!)
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading'),
                  ],
                ),
        ),
        // TextButton(
        //   onPressed: () {
        //     _chewieController?.enterFullScreen();
        //   },
        //   child: const Text('Fullscreen'),
        // ),
        // Row(
        //   children: <Widget>[
        //     TextButton(
        //       onPressed: () {
        //         setState(() {
        //           _videoPlayerController1.pause();
        //           _videoPlayerController1.seekTo(Duration.zero);
        //           _createChewieController();
        //         });
        //       },
        //       child: const Padding(
        //         padding: EdgeInsets.symmetric(vertical: 16.0),
        //         child: Text("Landscape Video"),
        //       ),
        //     ),
        //   ],
        // ),
        // if (Platform.isAndroid)
        //   ListTile(
        //     title: const Text("Delay"),
        //     subtitle: DelaySlider(
        //       delay: _chewieController?.progressIndicatorDelay?.inMilliseconds,
        //       onSave: (delay) async {
        //         if (delay != null) {
        //           bufferDelay = delay == 0 ? null : delay;
        //           await initializePlayer();
        //         }
        //       },
        //     ),
        //   )
      ],
    );
  }
}

class DelaySlider extends StatefulWidget {
  const DelaySlider({super.key, required this.delay, required this.onSave});

  final int? delay;
  final void Function(int?) onSave;
  @override
  State<DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends State<DelaySlider> {
  int? delay;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    delay = widget.delay;
  }

  @override
  Widget build(BuildContext context) {
    const int max = 1000;
    return ListTile(
      title: Text(
        "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
      ),
      subtitle: Slider(
        value: delay != null ? (delay! / max) : 0,
        onChanged: (value) async {
          delay = (value * max).toInt();
          setState(() {
            saved = false;
          });
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.save),
        onPressed: saved
            ? null
            : () {
                widget.onSave(delay);
                setState(() {
                  saved = true;
                });
              },
      ),
    );
  }
}
