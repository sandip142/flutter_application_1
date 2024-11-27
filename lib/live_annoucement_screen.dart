import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LiveAnnouncementScreen extends StatefulWidget {
  @override
  _LiveAnnouncementScreenState createState() => _LiveAnnouncementScreenState();
}

class _LiveAnnouncementScreenState extends State<LiveAnnouncementScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  String _selectedLanguage = 'en-US';
  bool _isPlaying = false;
  double _speechRate = 0.5;
  List<Map<String, dynamic>> _trains = []; // Placeholder for train data
  
  // Placeholder train data (replace with real-time data in production)
  final List<Map<String, dynamic>> _languages = [
    {
      'name': 'English (US)',
      'code': 'en-US',
      'sample': 'Train {name} ({number}) from {source} to {destination} is arriving on platform {platform}. Arrival: {arrival}, Departure: {departure}. Please stand back from the platform edge.'
    },
    
  ];

  @override
  void initState() {
    super.initState();
    _checkForAnnouncements(); // Initialize checking for announcements
  }

  // Check for announcement every minute
  void _checkForAnnouncements() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      String currentTime = TimeOfDay.now().format(context);
      for (var train in _trains) {
        if (train['arrivalTime'] == currentTime || train['departureTime'] == currentTime) {
          _announceTrainInfo(train);
          break;
        }
      }
    });
  }

  Future<void> _announceTrainInfo(Map<String, dynamic> train) async {
    final template = _languages.firstWhere((lang) => lang['code'] == _selectedLanguage)['sample']!;
    final announcement = template
        .replaceAll('{name}', train['trainName'])
        .replaceAll('{number}', train['trainNumber'])
        .replaceAll('{source}', train['source'])
        .replaceAll('{destination}', train['destination'])
        .replaceAll('{arrival}', train['arrivalTime'])
        .replaceAll('{departure}', train['departureTime'])
        .replaceAll('{platform}', train['platform'].toString());

    await _flutterTts.setLanguage(_selectedLanguage);
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.speak(announcement);
    setState(() => _isPlaying = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Train Announcements"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () => _selectLanguage(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _trains.length,
        itemBuilder: (context, index) {
          final train = _trains[index];
          return Card(
            child: ListTile(
              title: Text('${train['trainName']} (${train['trainNumber']})'),
              subtitle: Text('Arrival: ${train['arrivalTime']}, Departure: ${train['departureTime']}'),
              trailing: IconButton(
                icon: Icon(Icons.volume_up, color: Colors.green),
                onPressed: () => _announceTrainInfo(train),
              ),
            ),
          );
        },
      ),
    );
  }

  void _selectLanguage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languages.map((lang) {
              return RadioListTile(
                title: Text(lang['name']!),
                value: lang['code'],
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() => _selectedLanguage = value as String);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
