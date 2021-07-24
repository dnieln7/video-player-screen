import 'package:video_player_screen/domain/video_log.dart';

abstract class VideoLogDataSource {
  List<VideoLog> findAll();

  void save(VideoLog videoLog);
}
