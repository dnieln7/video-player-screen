import 'dart:io';

import 'package:flutter/foundation.dart';

class VideoLog {
  final String title;
  String? url;
  File? file;
  VideoLogType? type;
  final DateTime date;

  VideoLog.fromFile({
    required this.title,
    @required this.file,
    required this.date,
  }) {
    this.url = '';
    this.type = VideoLogType.File;
  }

  VideoLog.fromUrl({
    required this.title,
    @required this.url,
    required this.date,
  }) {
    this.file = null;
    this.type = VideoLogType.Network;
  }
}

enum VideoLogType { File, Network }
