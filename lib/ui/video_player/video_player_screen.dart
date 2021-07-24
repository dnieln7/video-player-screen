import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({@required this.videoSource});

  final VideoSource videoSource;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  bool showUi = true;

  VideoPlayerController controller;
  Timer uiTimer;

  AnimationController opacityController;
  Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.videoSource is NetWorkVideoSource) {
      controller = VideoPlayerController.network(widget.videoSource.source)
        ..initialize().then((_) => setState(() {}));
    } else if (widget.videoSource is FileVideoSource) {
      controller = VideoPlayerController.file(widget.videoSource.source)
        ..initialize().then((_) => setState(() {}));
    }

    opacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    opacityAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(parent: opacityController, curve: Curves.easeIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.videoSource.title),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: onVideoClicked,
        child: Center(
          child: controller.value.isInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(
                        controller,
                      ),
                    ),
                    FadeTransition(
                      opacity: opacityAnimation,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          splashColor: Colors.white54,
                          onTap: () => changePlayerState(),
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.transparent,
                            child: Icon(
                              controller.value.isPlaying
                                  ? Icons.pause_circle_outline_sharp
                                  : Icons.play_circle_outline_sharp,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      child: FadeTransition(
                        opacity: opacityAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            children: [
                              VideoDurationIndicator(controller: controller),
                              Expanded(
                                child: VideoProgressIndicator(
                                  controller,
                                  allowScrubbing: showUi,
                                  colors: VideoProgressColors(
                                    backgroundColor: Colors.white54,
                                    bufferedColor: Colors.white60,
                                    playedColor: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    uiTimer.cancel();
  }

  Timer startTimeout() {
    cancelTimeout();

    return uiTimer = Timer(Duration(seconds: 3), hideUi);
  }

  void cancelTimeout() {
    if (uiTimer != null && uiTimer.isActive) {
      uiTimer.cancel();
    }
  }

  void onVideoClicked() {
    setState(() => showUi = !showUi);

    if (showUi) {
      opacityController.reverse();
    } else {
      opacityController.forward();
    }

    if (showUi && controller.value.isPlaying) {
      startTimeout();
    } else {
      cancelTimeout();
    }
  }

  void hideUi() {
    setState(() => showUi = false);
    opacityController.forward();
  }

  void changePlayerState() {
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });

    if (controller.value.isPlaying) {
      startTimeout();
    } else {
      opacityController.reverse();
      cancelTimeout();
    }
  }
}

class VideoDurationIndicator extends StatefulWidget {
  VideoDurationIndicator({
    @required this.controller,
  });

  final VideoPlayerController controller;

  @override
  _VideoDurationIndicatorState createState() => _VideoDurationIndicatorState();
}

class _VideoDurationIndicatorState extends State<VideoDurationIndicator> {
  Duration currentPosition;
  Duration totalDuration;
  Timer currentPositionTimer;

  @override
  void initState() {
    super.initState();

    totalDuration = widget.controller.value.duration;
    currentPositionTimer = Timer(Duration(seconds: 1), getCurrentPosition);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.caption.copyWith(
          color: Colors.white,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          currentPosition.toString().split('.')[0],
          style: theme,
        ),
        Text(
          totalDuration.toString().split('.')[0],
          style: theme,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    currentPositionTimer.cancel();
  }

  void getCurrentPosition() {
    setState(() => currentPosition = widget.controller.value.position);
    currentPositionTimer = Timer(Duration(seconds: 1), getCurrentPosition);
  }
}

abstract class VideoSource<T> {
  VideoSource({@required this.title, @required this.source});

  final String title;
  final T source;
}

class NetWorkVideoSource extends VideoSource<String> {
  NetWorkVideoSource({@required String title, @required String source})
      : super(title: title, source: source);
}

class FileVideoSource extends VideoSource<File> {
  FileVideoSource({@required String title, @required File source})
      : super(title: title, source: source);
}
