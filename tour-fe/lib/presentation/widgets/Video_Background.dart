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

  final List<String> _videos = [
    '/video/video1.mp4',
    '/video/video2.mp4',
    '/video/video3.mp4',
    '/video/video4.mp4',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initVideo();
  }

  Future<void> _initVideo() async {
    final rnd = Random();
    final path = _videos[rnd.nextInt(_videos.length)];

    _videoController = VideoPlayerController.asset(path);
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
