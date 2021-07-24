import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player_screen/data/source/video_log_data_source.dart';
import 'package:video_player_screen/data/source/video_log_in_memory_data_source.dart';
import 'package:video_player_screen/domain/video_log.dart';
import 'package:video_player_screen/utils/validation.dart';
import 'package:video_player_screen/widget/video_log_list_tile.dart';

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final VideoLogDataSource dataSource = VideoLogInMemoryDataSource();
  List<VideoLog> logs;

  String title;
  String url;

  @override
  void initState() {
    super.initState();

    title = '';
    url = '';

    fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Videos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'Add a video log',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        initialValue: '',
                        onSaved: (newValue) => setState(() => title = newValue),
                        validator: (value) => validateEmpty(value),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Url',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        initialValue: '',
                        onSaved: (newValue) => setState(() => url = newValue),
                        validator: (value) => validateEmpty(value),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: saveVideo,
                        child: Text('SAVE'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (ctx, i) => VideoLogListTile(videoLog: logs[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchVideos() {
    setState(() => logs = dataSource.findAll());
  }

  void saveVideo() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      dataSource.save(VideoLog(title: title, url: url, date: DateTime.now()));
      fetchVideos();
      formKey.currentState.reset();
    }
  }
}