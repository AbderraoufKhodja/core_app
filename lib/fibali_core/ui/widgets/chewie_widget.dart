import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ChewieWidget extends StatefulWidget {
  const ChewieWidget({
    super.key,
    required this.source,
  });

  final dynamic source;

  @override
  State<ChewieWidget> createState() => _ChewieWidgetState();
}

class _ChewieWidgetState extends State<ChewieWidget> {
  late final ChewieController? chewieController;
  @override
  void initState() {
    super.initState();
    if (widget.source is File) {
      chewieController = ChewieController(
        videoPlayerController: VideoPlayerController.file(widget.source),
        autoPlay: false,
        looping: false,
        showControls: true,
        allowFullScreen: false,
        allowPlaybackSpeedChanging: false,
        allowMuting: false,
        placeholder: const ColoredBox(color: Colors.black),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chewieController != null) {
      return SizedBox(height: Get.height / 3, child: Chewie(controller: chewieController!));
    }
    return const SizedBox();
  }
}
