import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/HeadMaster/audio_recoder.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

class TrainStationScreen extends StatefulWidget {
  @override
  _TrainStationScreenState createState() => _TrainStationScreenState();
}

class _TrainStationScreenState extends State<TrainStationScreen> {
  final TextEditingController _stationController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  List<dynamic> _trains = [];
  bool _isLoading = false;
  bool _isPlaying = false;
  double _speechRate = 0.5;
  String _selectedLanguage = 'en-US'; // Default language

final List<Map<String, String>> _languages = [
  {
    'name': 'English (US)',
    'code': 'en-US',
    'sample': 'Attention please! Train {name} ({number}), running from {source} to {destination}, will arrive shortly on platform {platform}. Its arrival time is {arrival}. Please stay safe and away from the edge of the platform. Thank you!'
  },
  {
    'name': 'Hindi',
    'code': 'hi-IN',
    'sample': 'यात्रीगण कृपया ध्यान दें! गाड़ी संख्या {number}, {name}, {source} से {destination} के लिए चलने वाली है। यह प्लेटफॉर्म संख्या {platform} पर कुछ ही समय में पहुँचने वाली है, इसकी आगमन समय {arrival} बजे है। कृपया अपनी सुरक्षा का ध्यान रखें और प्लेटफॉर्म के किनारे से दूर रहें। धन्यवाद!'
  },
  {
    'name': 'Marathi',
    'code': 'mr-IN',
    'sample': 'प्रवासी कृपया लक्ष द्या! गाडी क्रमांक {number}, {name}, {source} वरून {destination} कडे जाणारी आहे. ती लवकरच प्लॅटफॉर्म क्रमांक {platform} वर येणार आहे, आगमन वेळ {arrival} वाजता आहे. कृपया सुरक्षित रहा आणि प्लॅटफॉर्मच्या कडेला उभे राहू नका. धन्यवाद!'
  },
  {
    'name': 'Tamil',
    'code': 'ta-IN',
    'sample': 'பயணிகள் கவனமாக இருங்கள்! {name} ({number}) ரயில் {source} இருந்து {destination} நோக்கி விரைவில் பிளாட்பாரம் {platform} இல் வந்து சேரும். அதன் வருகை நேரம் {arrival}. தயவுசெய்து பாதுகாப்பாக இருங்கள் மற்றும் பிளாட்பாரத்தின் விளிம்பில் இருந்து விலகி இருங்கள். நன்றி!'
  },
  {
    'name': 'Bengali',
    'code': 'bn-IN',
    'sample': 'যাত্রীবৃন্দ দয়া করে মনোযোগ দিন! ট্রেন {name} ({number}), {source} থেকে {destination} এর দিকে চলেছে। এটি শীঘ্রই প্ল্যাটফর্ম {platform} এ পৌঁছাবে, এর আগমনের সময় {arrival}। দয়া করে নিরাপদে থাকুন এবং প্ল্যাটফর্মের ধারে দাঁড়াবেন না। ধন্যবাদ!'
  },
  {
    'name': 'Gujarati',
    'code': 'gu-IN',
    'sample': 'મહેમાનગણ કૃપા કરીને ધ્યાન આપો! ટ્રેન {name} ({number}), {source} થી {destination} જવા માટે છે. તે ટૂંક સમયમાં પ્લેટફોર્મ {platform} પર પહોંચશે. તેનું આગમન સમય {arrival} છે. કૃપા કરીને સલામત રહો અને પ્લેટફોર્મના કિનારેથી દૂર રહો. આભાર!'
  },
  {
    'name': 'Kannada',
    'code': 'kn-IN',
    'sample': 'ಪ್ರಯಾಣಿಕರೇ, ದಯವಿಟ್ಟು ಗಮನ ಕೊಡಿ! ರೈಲು {name} ({number}), {source} ಇಂದ {destination} ಗೆ ಹೊರಡುತ್ತಿದೆ. ಇದು ಬೇಗನೇ ಪ್ಲಾಟ್‌ಫಾರ್ಮ್ {platform} ಗೆ ಬರುವುದು. ಅದರ ಆಗಮನ ಸಮಯ {arrival}. ದಯವಿಟ್ಟು ಸುರಕ್ಷಿತವಾಗಿರಿ ಮತ್ತು ಪ್ಲಾಟ್‌ಫಾರ್ಮ್‌ನ ಅಂಚಿನಲ್ಲಿ ನಿಲ್ಲಬೇಡಿ. ಧನ್ಯವಾದಗಳು!'
  },
  {
    'name': 'Hyderabadi Urdu',
    'code': 'ur-IN',
    'sample': 'सवारीजन ज़रा तवज्जो दें! ट्रेन {name} ({number}), {source} से {destination} जा रही है। जल्दी ही प्लेटफार्म {platform} पर आएगी, इसका वक़्त {arrival} बजे है। मेहरबानी करके महफ़ूज़ रहें और प्लेटफार्म के किनारे से दूर रहें। शुक्रिया!'
  },
  {
    'name': 'Bhojpuri',
    'code': 'bho-IN',
    'sample': 'यात्रीगण कृपया ध्यान दीं! गाड़ी {name} ({number}), {source} से {destination} के ओर जात बा। ई जल्दीए प्लेटफॉर्म {platform} पऽ पहुँच जाई, आ ओकर समय बा {arrival} बजे। कृपया सुरक्छित रहीं आ प्लेटफॉर्म के कगार से दूर रहीं। धन्यवाद!'
  },
  {
    'name': 'French',
    'code': 'fr-FR',
    'sample': 'Attention s’il vous plaît! Le train {name} ({number}), en provenance de {source} à destination de {destination}, arrivera sous peu sur la plateforme {platform}. L’heure d’arrivée est {arrival}. Veuillez rester en sécurité et à l’écart du bord de la plateforme. Merci!'
  },
  {
    'name': 'Spanish',
    'code': 'es-ES',
    'sample': 'Atención por favor! El tren {name} ({number}), desde {source} hacia {destination}, llegará en breve en la plataforma {platform}. La hora de llegada es {arrival}. Por favor, manténgase seguro y lejos del borde de la plataforma. ¡Gracias!'
  }
];


  Future<void> _fetchTrainData(String stationCode) async {
    setState(() => _isLoading = true);
//https://railway-server-xo03.onrender.com/stations/$stationCode
    final url = Uri.parse('https://railway-server.vercel.app/stations/$stationCode');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _trains = data['trains'] ?? [];
          _isLoading = false;
        });
        if (_trains.isNotEmpty) _announceTrainInfo(_trains[0]);
      } else {
        _showError('Failed to load train data');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _announceTrainInfo(Map<String, dynamic> train) async {
    String template = _languages
        .firstWhere((lang) => lang['code'] == _selectedLanguage)['sample']!;
    String announcement = template
        .replaceAll('{name}', train['trainName'])
        .replaceAll('{number}', train['trainNumber'])
        .replaceAll('{source}', train['source'])
        .replaceAll('{destination}', train['destination'])
        .replaceAll('{arrival}', train['arrivalTime'])
        .replaceAll('{platform}','2');

    await _flutterTts.setLanguage(_selectedLanguage);
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.speak(announcement);

    setState(() => _isPlaying = true);
  }

  void _stopTTS() async {
    await _flutterTts.stop();
    setState(() => _isPlaying = false);
  }

  void _togglePauseTTS() async {
    if (_isPlaying) {
      await _flutterTts.pause();
    } 
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Train Announcements'),
        backgroundColor: Colors.deepPurple,
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            dropdownColor: Colors.deepPurple,
            icon: Icon(Icons.language, color: Colors.white),
            items: _languages.map((lang) {
              return DropdownMenuItem(
                value: lang['code'],
                child: Text(lang['name']!, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() => _selectedLanguage = value!);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                if (_stationController.text.isNotEmpty) {
                  _fetchTrainData(_stationController.text);
                }
              },
              icon: Icon(Icons.search),
              label: Text('Get Train Info'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 199, 176, 240),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _trains.length,
                      itemBuilder: (context, index) {
                        final train = _trains[index];
                        return _buildTrainCard(train);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _stationController,
      decoration: InputDecoration(
        labelText: 'Enter Station Code',
        prefixIcon: Icon(Icons.train),
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildTrainCard(Map<String, dynamic> train) {
    return InkWell
    (
      onTap: (){
         Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioRecorderScreen(trainNo: train['trainNumber']),
                ),
              );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(Icons.directions_railway, color: Colors.deepPurple),
          title: Text(
            '${train['trainName']} (${train['trainNumber']})',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'From ${train['source']} to ${train['destination']}\nArrival: ${train['arrivalTime']}',
          ),
          trailing: _isPlaying
              ? IconButton(
                  icon: Icon(Icons.pause, color: Colors.red),
                  onPressed: _togglePauseTTS,
                )
              : IconButton(
                  icon: Icon(Icons.volume_up, color: Colors.green),
                  onPressed: () => _announceTrainInfo(train),
                ),
        ),
      ),
    );
  }
}
