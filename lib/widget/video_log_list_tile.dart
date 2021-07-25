import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player_screen/domain/video_log.dart';
import 'package:video_player_screen/ui/video_player/video_player_screen.dart';

class VideoLogListTile extends StatelessWidget {
  VideoLogListTile({required this.videoLog});

  final VideoLog videoLog;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => navigateToVideoPlayer(context),
      leading: Icon(
        Icons.movie_sharp,
        size: 50,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(videoLog.title),
      subtitle: Text(videoLog.date.toString().substring(0, 10)),
    );
  }

  void navigateToVideoPlayer(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => VideoPlayerScreen(
        videoSource: videoLog.type == VideoLogType.Network
            ? NetWorkVideoSource(title: videoLog.title, source: videoLog.url!)
            : FileVideoSource(title: videoLog.title, source: videoLog.file ?? File('')) as VideoSource,
      ),
    ));
  }
}
