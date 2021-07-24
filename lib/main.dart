import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player_screen/ui/video_list/video_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.teal,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              backwardsCompatibility: false,
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: VideoListScreen(),
    );
  }
}
