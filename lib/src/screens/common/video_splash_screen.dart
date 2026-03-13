import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSplashScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const VideoSplashScreen({super.key, required this.onFinished});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late final VideoPlayerController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/buKombinSplash.mp4');
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _controller.setLooping(false);
      _controller.play();

      _controller.addListener(_onTick);
    });
  }

  void _onTick() {
    if (_navigated) return;
    final value = _controller.value;
    if (!value.isInitialized) return;
    if (value.position >= value.duration && !value.isPlaying) {
      _navigated = true;
      widget.onFinished();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            : const SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
