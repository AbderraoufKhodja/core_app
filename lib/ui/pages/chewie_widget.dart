import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';

class ChewieDemo extends StatefulWidget {
  const ChewieDemo({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  List<String> srcs = [
    // "https://d168n50kvmcuuc.cloudfront.net/f51aa3f6-86c5-480d-a859-f7536386dbe0/f51aa3f6-86c5-480d-a859-f7536386dbe0.m3u8?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9kMTY4bjUwa3ZtY3V1Yy5jbG91ZGZyb250Lm5ldC9mNTFhYTNmNi04NmM1LTQ4MGQtYTg1OS1mNzUzNjM4NmRiZTAvKiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTY5MTM3ODQ4NX19fV19&Key-Pair-Id=K32KC21VLEWAHV&Signature=JcX0cJsbP5mTqNQCJol0YvecjPnM~AUs-wNSnauVlBHPhs~p5siRYWKViMUfTxr8zEUMq3VQXoNl-nWwB6264fTlyU3ufz~UQtbuu9GfYC44YgDaERTbzD6-hhRO5E77Nmg8au6SHdPmMX1i~Qqt0204a9ZIE2qaRjBhkMVgu04kFqSlEUTGAfgsu1MUmd7JKg60iqQ4NA65RNM8Xvdb2pLePnDMDUg-3jnK6SC-qq2E9sxxCCvEyb-FiyUtFmm9b4j5pJTOKTmx~TLqkNboba7CyCtpNfYTgCQZwFkNxNmhG-MznE2ClfNkPqvEhreoYdZTQunQc9d-N9GNVgdlRw__",
    // "https://d168n50kvmcuuc.cloudfront.net/f51aa3f6-86c5-480d-a859-f7536386dbe0/f51aa3f6-86c5-480d-a859-f7536386dbe0_3000.m3u8",
    "https://d168n50kvmcuuc.cloudfront.net/f51aa3f6-86c5-480d-a859-f7536386dbe0/f51aa3f6-86c5-480d-a859-f7536386dbe0_3000.m3u8?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9kMTY4bjUwa3ZtY3V1Yy5jbG91ZGZyb250Lm5ldC9mNTFhYTNmNi04NmM1LTQ4MGQtYTg1OS1mNzUzNjM4NmRiZTAvKiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTY5MTM3ODQ4Nn19fV19&Key-Pair-Id=K32KC21VLEWAHV&Signature=ReaADOI-DcH8ywCCugmJW5K9nvBohKekVZqQr3YJoM2uEAMbKfeHOfCf5-MRTfMCb7WtLMykqcN1aXyi72a6gVutNRVSHJy4qVT5uLYElSaVzRJOZI22ptRmAzckx1stN9N7kacyF4AeGJSEdydX~m3dNS5-4jT9wT-II9FJK7SL2TBf12oIrqUZPV0oq-3t8NKwbCkTwXQ7Zb37JyP8V~vO4zLv30MoPIv9Jy85U22yKeO40qUaOujvcAjweGIgoX~DhZm8koUtrYLg6GkWnVnoIkL~2zU7CH2s64r-kTqIr6t8QOZWzB5SukrewBup3hU94eOX052cP2JS-Glvzw__",
    // "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.networkUrl(Uri.parse(srcs[currPlayIndex]));
    _videoPlayerController2 = VideoPlayerController.networkUrl(Uri.parse(srcs[currPlayIndex]));
    await Future.wait([_videoPlayerController1.initialize(), _videoPlayerController2.initialize()]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    // final subtitles = [
    //     Subtitle(
    //       index: 0,
    //       start: Duration.zero,
    //       end: const Duration(seconds: 10),
    //       text: 'Hello from subtitles',
    //     ),
    //     Subtitle(
    //       index: 0,
    //       start: const Duration(seconds: 10),
    //       end: const Duration(seconds: 20),
    //       text: 'Whats up? :)',
    //     ),
    //   ];

    final subtitles = [
      Subtitle(
        index: 0,
        start: Duration.zero,
        end: const Duration(seconds: 10),
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Hello',
              style: TextStyle(color: Colors.red, fontSize: 22),
            ),
            TextSpan(
              text: ' from ',
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
            TextSpan(
              text: 'subtitles',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            )
          ],
        ),
      ),
      Subtitle(
        index: 0,
        start: const Duration(seconds: 10),
        end: const Duration(seconds: 20),
        text: 'Whats up? :)',
        // text: const TextSpan(
        //   text: 'Whats up? :)',
        //   style: TextStyle(color: Colors.amber, fontSize: 22, fontStyle: FontStyle.italic),
        // ),
      ),
    ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay: bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: toggleVideo,
            iconData: Icons.live_tv_sharp,
            title: 'Toggle Video Src',
          ),
        ];
      },
      subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),

      hideControlsTimer: const Duration(seconds: 1),

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _chewieController != null &&
                      _chewieController!.videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController!)
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
            ),
          ),
          TextButton(
            onPressed: () {
              _chewieController?.enterFullScreen();
            },
            child: const Text('Fullscreen'),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _videoPlayerController1.pause();
                      _videoPlayerController1.seekTo(Duration.zero);
                      _createChewieController();
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text("Landscape Video"),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _videoPlayerController2.pause();
                      _videoPlayerController2.seekTo(Duration.zero);
                      _chewieController = _chewieController!.copyWith(
                        videoPlayerController: _videoPlayerController2,
                        autoPlay: true,
                        looping: true,
                        /* subtitle: Subtitles([
                          Subtitle(
                            index: 0,
                            start: Duration.zero,
                            end: const Duration(seconds: 10),
                            text: 'Hello from subtitles',
                          ),
                          Subtitle(
                            index: 0,
                            start: const Duration(seconds: 10),
                            end: const Duration(seconds: 20),
                            text: 'Whats up? :)',
                          ),
                        ]),
                        subtitleBuilder: (context, subtitle) => Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            subtitle,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ), */
                      );
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text("Portrait Video"),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _platform = TargetPlatform.android;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text("Android controls"),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _platform = TargetPlatform.iOS;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text("iOS controls"),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _platform = TargetPlatform.windows;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text("Desktop controls"),
                  ),
                ),
              ),
            ],
          ),
          if (Platform.isAndroid)
            ListTile(
              title: const Text("Delay"),
              subtitle: DelaySlider(
                delay: _chewieController?.progressIndicatorDelay?.inMilliseconds,
                onSave: (delay) async {
                  if (delay != null) {
                    bufferDelay = delay == 0 ? null : delay;
                    await initializePlayer();
                  }
                },
              ),
            )
        ],
      ),
    );
  }
}

class DelaySlider extends StatefulWidget {
  const DelaySlider({Key? key, required this.delay, required this.onSave}) : super(key: key);

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
