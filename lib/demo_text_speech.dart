import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterTts ftts = FlutterTts();
  String _selectedLanguage = 'en-US'; // Default language

  final List<Map<String, String>> _languages = [
    {'name': 'English (US)', 'code': 'en-US', 'words': 'May I have your attention, please! Train number 12627, Chennai Central - New Delhi Tamil Nadu Express, scheduled to depart from platform number 3, will arrive shortly. Passengers are requested to proceed towards platform number 3. Kindly ensure that you have all your belongings with you. Thank you.'},
    {'name': 'Hindi', 'code': 'hi-IN', 'words': 'यात्रियों कृपया ध्यान दें! गाड़ी संख्या 12627, चेन्नई सेंट्रल - नई दिल्ली तमिलनाडु एक्सप्रेस, जो प्लेटफॉर्म संख्या 3 से प्रस्थान करेगी, कुछ ही समय में प्लेटफॉर्म पर आ रही है। कृपया अपने सामान का ध्यान रखें और प्लेटफॉर्म संख्या 3 पर जाने का कष्ट करें। धन्यवाद।'},
    {'name': 'French', 'code': 'fr-FR', 'words': 'Votre attention s\'il vous plaît ! Le train numéro 12627, Tamil Nadu Express de Chennai Central à New Delhi, prévu au départ de la voie numéro 3, arrivera sous peu. Veuillez vous diriger vers la voie numéro 3 et surveiller vos effets personnels. Merci.'},
    {'name': 'Spanish', 'code': 'es-ES', 'words': '¡Atención, por favor! El tren número 12627, Tamil Nadu Express de Chennai Central a Nueva Delhi, programado para salir de la plataforma número 3, llegará en breve. Se ruega a los pasajeros que se dirijan a la plataforma número 3 y cuiden sus pertenencias. Gracias.'},
    {'name': 'German', 'code': 'de-DE', 'words': 'Achtung bitte! Der Zug mit der Nummer 12627, Tamil Nadu Express von Chennai Central nach Neu-Delhi, der von Gleis 3 abfahren soll, wird in Kürze eintreffen. Bitte begeben Sie sich zu Gleis 3 und achten Sie auf Ihr Gepäck. Vielen Dank.'},
    {'name': 'Marathi', 'code': 'mr-IN', 'words': 'कृपया लक्ष द्या! गाडी क्रमांक 12627, चेन्नई सेंट्रल - नवी दिल्ली तमिळनाडू एक्सप्रेस, प्लॅटफॉर्म क्रमांक 3 वरून सुटणार आहे. ती लवकरच येत आहे. कृपया आपल्या सर्व सामानाची काळजी घ्या आणि प्लॅटफॉर्म क्रमांक 3 कडे जा. धन्यवाद!'},
    {'name': 'Punjabi', 'code': 'pa-IN', 'words': 'ਕਿਰਪਾ ਕਰਕੇ ਧਿਆਨ ਦਿਓ! ਟਰੇਨ ਨੰਬਰ 12627, ਚੇਨਈ ਸੈਂਟ੍ਰਲ - ਨਵੀਂ ਦਿੱਲੀ ਤਾਮਿਲ ਨਾਡੂ ਐਕਸਪ੍ਰੈਸ, ਪਲੇਟਫਾਰਮ ਨੰਬਰ 3 ਤੋਂ ਚਲਣ ਵਾਲੀ ਹੈ। ਇਸਦੀ ਆਮਦ ਸ਼ੁਰੂ ਹੋਣ ਵਾਲੀ ਹੈ। ਕਿਰਪਾ ਕਰਕੇ ਆਪਣੇ ਸਮਾਨ ਦੀ ਸੰਭਾਲ ਕਰੋ ਅਤੇ ਪਲੇਟਫਾਰਮ ਨੰਬਰ 3 ਤੇ ਪਹੁੰਚੋ। ਧੰਨਵਾਦ!'},
    {'name': 'Kannada', 'code': 'kn-IN', 'words': 'ದಯವಿಟ್ಟು ಗಮನಿಸಿ! ರೈಲು ಸಂಖ್ಯೆ 12627, ಚೆನ್ನೈ ಸೆಂಟ್ರಲ್ - ನವದೆಹಲಿ ತಮಿಳುನಾಡು ಎಕ್ಸ್‌ಪ್ರೆಸ್, ವೇದಿಕೆ ಸಂಖ್ಯೆ 3ರಿಂದ ನಿರ್ಗಮಿಸಲು ಪ್ಲಾನ್ ಮಾಡಲಾಗಿದೆ ಮತ್ತು ಶೀಘ್ರದಲ್ಲೇ ಆಗಮಿಸಲಿದೆ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಎಲ್ಲ ಸಾಮಾನುಗಳನ್ನು ಕಾಪಾಡಿಕೊಳ್ಳಿ ಮತ್ತು ವೇದಿಕೆ 3 ಕ್ಕೆ ತೆರಳಿರಿ. ಧನ್ಯವಾದಗಳು.'},
    {'name': 'Bengali', 'code': 'bn-IN', 'words': 'দয়া করে মনোযোগ দিন! ট্রেন নম্বর 12627, চেন্নাই সেন্ট্রাল - নিউ দিল্লি তামিলনাড়ু এক্সপ্রেস, প্ল্যাটফর্ম নম্বর 3 থেকে ছাড়ার জন্য নির্ধারিত এবং শীঘ্রই পৌঁছাবে। অনুগ্রহ করে আপনার সমস্ত জিনিসপত্রের যত্ন নিন এবং প্ল্যাটফর্ম নম্বর 3 এ যান। ধন্যবাদ।'},
    {'name': 'Tamil', 'code': 'ta-IN', 'words': 'தயவுசெய்து கவனம் செலுத்துங்கள்! ரயில் எண் 12627, சென்னை சென்ட்ரல் - டெல்லி தமிழ்நாடு எக்ஸ்பிரஸ், தளம் எண் 3-இல் இருந்து விரைவில் புறப்பட உள்ளது. தயவுசெய்து தங்கள் உடமைகளை பாதுகாத்து தளம் எண் 3-க்கு செல்க. நன்றி!'},
    {'name': 'Gujarati', 'code': 'gu-IN', 'words': 'કૃપા કરીને ધ્યાન આપો! ટ્રેન નંબર 12627, ચેન્નાઇ સેન્ટ્રલ - નવી દિલ્હી તમિલનાડુ એક્સપ્રેસ, પ્લેટફોર્મ નંબર 3 પરથી જલ્દી જ પ્રસ્થાન કરશે. કૃપા કરીને તમારું બેગેજ ચકાસી અને પ્લેટફોર્મ નંબર 3 પર પહોંચી જાઓ. ધન્યવાદ.'},
    {'name': 'Malayalam', 'code': 'ml-IN', 'words': 'ദയവായി ശ്രദ്ധിക്കുക! ട്രെയിൻ നമ്പർ 12627, ചെന്നൈ സെൻട്രൽ - ഡൽഹി തമിഴ്‌നാട് എക്സ്പ്രസ്, പ്ലാറ്റ്ഫോം നമ്പർ 3ൽ നിന്ന് യാത്ര തിരിക്കും. അത് ഉടൻ എത്തും. ദയവായി നിങ്ങളുടെ എല്ലാ സമ്പത്ത് ശ്രദ്ധിക്കൂ, പ്ലാറ്റ്ഫോം 3ലേക്ക് പോയി. നന്ദി!'}
  ];

  @override
  void initState() {
    super.initState();
    _checkTtsAvailability();
  }

  Future<void> _checkTtsAvailability() async {
    bool? isAvailable = await ftts.isLanguageAvailable(_selectedLanguage);
    if (!isAvailable!) {
      _showErrorDialog('TTS Engine Not Available', 'Please install a TTS engine or check language support.');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _speak() async {
    try {
      // Find the selected language and message
      String? message = _languages.firstWhere((lang) => lang['code'] == _selectedLanguage)['words'];

      await ftts.setLanguage(_selectedLanguage);
      await ftts.setSpeechRate(0.5);
      await ftts.setVolume(1.0);
      await ftts.setPitch(1.0);

      var result = await ftts.speak(message!);
      if (result != 1) {
        _showErrorDialog('Error', 'Failed to start TTS engine.');
      }
    } catch (e) {
      _showErrorDialog('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trains Annoucement"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedLanguage,
              items: _languages.map((language) {
                return DropdownMenuItem(
                  value: language['code'],
                  child: Text(language['name']!),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speak,
              child: Text("Speak"),
            ),
          ],
        ),
      ),
    );
  }
}
