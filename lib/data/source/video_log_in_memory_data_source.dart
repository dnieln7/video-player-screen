import 'package:video_player_screen/data/source/video_log_data_source.dart';
import 'package:video_player_screen/domain/video_log.dart';

class VideoLogInMemoryDataSource implements VideoLogDataSource {
  List<VideoLog> logs = [
    VideoLog(
      title: 'Sample video',
      url:
          'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4',
      date: DateTime.now(),
    ),
  ];

  @override
  List<VideoLog> findAll() {
    return [...logs];
  }

  @override
  void save(VideoLog videoLog) {
    logs.add(videoLog);
  }
}
