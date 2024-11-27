import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class TrainDetailsPage extends StatefulWidget {
  final String trainNumber;
  TrainDetailsPage({required this.trainNumber});

  @override
  _TrainDetailsPageState createState() => _TrainDetailsPageState();
}

class _TrainDetailsPageState extends State<TrainDetailsPage> {
  Map<String, dynamic>? _trainDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrainDetails(widget.trainNumber);
  }

  Future<void> _fetchTrainDetails(String trainNumber) async {
    final url = Uri.parse('https://railway-server-xo03.onrender.com/trains/$trainNumber');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _trainDetails = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        _showError('Failed to load train details');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Train Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _trainDetails == null
              ? Center(child: Text('No details available'))
              : Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_trainDetails!['trainName']} (${_trainDetails!['trainNumber']})',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text('Source: ${_trainDetails!['source']}'),
                        Text('Destination: ${_trainDetails!['destination']}'),
                        Text('Arrival Time: ${_trainDetails!['arrivalTime']}'),
                        Text('Departure Time: ${_trainDetails!['departureTime']}'),
                        SizedBox(height: 20),
                        Text(
                          'Station Details:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _trainDetails!['stationIds']?.length ?? 0,
                            itemBuilder: (context, index) {
                              final station = _trainDetails!['stationIds'][index];
                              return ListTile(
                                title: Text(station['stationName']),
                                subtitle: Text('Code: ${station['stationCode']}'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
    );
  }
}
