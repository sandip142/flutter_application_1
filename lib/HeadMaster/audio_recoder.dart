import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderScreen extends StatefulWidget {
   final String trainNo;
   const AudioRecorderScreen({super.key,required this.trainNo});

  @override
  _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedFilePath;
  bool _isUploading = false; // For managing CircularProgressIndicator

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _initializePlayer();
  }

  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<void> _initializePlayer() async {
    await _player.openPlayer();
  }

  Future<void> _startRecording() async {
    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/audio_record.aac';

    try {
      await _recorder.startRecorder(
        toFile: filePath,
        codec: Codec.aacADTS,
      );
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      debugPrint('Error while starting recorder: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording failed: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    final String? path = await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
      _recordedFilePath = path;
    });
  }

  Future<void> _uploadAudioFile(String trainNumber) async {
    if (_recordedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No audio file to upload')),
      );
      return;
    }

    final Uri serverUri = Uri.parse('https://railway-server.vercel.app/trains/$trainNumber');
    final request = http.MultipartRequest('POST', serverUri);

    try {
      setState(() {
        _isUploading = true;
      });

      // Add the audio file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'audioFilePath', // Field name expected by the server
        _recordedFilePath!,
      ));

      // Set a timeout of 15 seconds
      final response = await request.send().timeout(
        const Duration(seconds: 50),
        onTimeout: () {
          throw Exception("timeout");
        },
      );

      setState(() {
        _isUploading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio file uploaded successfully')),
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        debugPrint('Failed to upload file. Server responded: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload audio file')),
        );
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      debugPrint('Exception occurred during file upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while uploading: $e')),
      );
    }
  }

  Future<void> _playAudio() async {
    if (_recordedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No audio file to play')),
      );
      return;
    }

    try {
      await _player.startPlayer(
        fromURI: _recordedFilePath,
        codec: Codec.aacADTS,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        },
      );
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      debugPrint('Error while playing audio: $e');
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _player.stopPlayer();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      debugPrint('Error while stopping audio: $e');
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRecording) ...[
              Text('Recording...'),
              ElevatedButton(
                onPressed: _stopRecording,
                child: Text('Stop Recording'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: _startRecording,
                child: Text('Start Recording'),
              ),
              if (_recordedFilePath != null) ...[
                SizedBox(height: 20),
                _isUploading
                    ? CircularProgressIndicator() // Show loading indicator
                    : ElevatedButton(
                        onPressed: () {
                          _uploadAudioFile(widget.trainNo);
                          print(_recordedFilePath); 
                          print('http://192.168.7.17:5000/trains/22913');// Specify train number
                        },
                        child: Text('Upload Recorded Audio'),
                      ),
                SizedBox(height: 20),
                _isPlaying
                    ? ElevatedButton(
                        onPressed: _stopAudio,
                        child: Text('Stop Playback'),
                      )
                    : ElevatedButton(
                        onPressed: _playAudio,
                        child: Text('Play Audio'),
                      ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
