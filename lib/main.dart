import 'package:flutter/material.dart';
import 'package:flutter_application_1/HeadMaster/audio_recoder.dart';
import 'package:flutter_application_1/demo_text_speech.dart';
import 'package:flutter_application_1/station_train.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  TrainStationScreen()//AudioRecorderScreen()//TTSHomePage(),
    );
  }
}

