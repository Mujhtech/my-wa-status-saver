import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerBox extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final String videoSrc;
  final double aspectRatio;

  const VideoPlayerBox({
    @required this.videoPlayerController,
    this.looping,
    this.videoSrc,
    this.aspectRatio,
    Key key,
  }) : super(key: key);

  @override
  _VideoPlayerBoxState createState() => _VideoPlayerBoxState();
}

class _VideoPlayerBoxState extends State<VideoPlayerBox> {
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        autoInitialize: true,
        looping: widget.looping,
        allowFullScreen: true,
        aspectRatio: widget.videoPlayerController.value.aspectRatio,
        // autoPlay: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(errorMessage),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print(' aspect ratio: ${widget.videoPlayerController.value}');
    return Card(
      color: Colors.black,
      child: Container(
        height: 400,
        padding: const EdgeInsets.only(top: 0),
        child: Hero(
          tag: widget.videoSrc,
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
    //     ],
    //   ),
    // );
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
