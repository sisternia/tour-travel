// lib/presentation/widgets/Video_Background.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackground extends StatefulWidget {
  const VideoBackground({super.key});

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground>
    with WidgetsBindingObserver {
  late VideoPlayerController _videoController;

  final List<String> _cloudinaryVideos = [

    "https://res.cloudinary.com/dygkdxqmq/video/upload/v1764062986/video1_p5u2oc.mp4",
    "https://res.cloudinary.com/dygkdxqmq/video/upload/v1764063006/video2_kmstrz.mp4",
    "https://res.cloudinary.com/dygkdxqmq/video/upload/v1764062998/video3_sqybmc.mp4",
    "https://res.cloudinary.com/dygkdxqmq/video/upload/v1764062997/video4_lhjzgk.mp4",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initVideo();
  }

  Future<void> _initVideo() async {
    final rnd = Random();
    final url = _cloudinaryVideos[rnd.nextInt(_cloudinaryVideos.length)];

    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));

    await _videoController.initialize();
    _videoController.setLooping(true);
    _videoController.setVolume(0);
    await _videoController.play();

    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_videoController.value.isInitialized) return;

    if (state == AppLifecycleState.paused) {
      _videoController.pause();
    } else if (state == AppLifecycleState.resumed) {
      _videoController.play();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: _videoController.value.isInitialized
          ? Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  ),
                ),

                /// Overlay mờ
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.15),
                  ),
                ),
              ],
            )
          : Container(color: Colors.black),
    );
  }
}
