import 'package:flutter/foundation.dart';

class VideoLog {
  VideoLog({
    @required this.title,
    @required this.url,
    @required this.date,
  });

  final String title;
  final String url;
  final DateTime date;
}
