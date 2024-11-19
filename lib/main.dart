import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/screen/main_screen.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';
import 'model/meal.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SpeechToText speech = SpeechToText();
  late SpeechToTextProvider speechProvider;

  @override
  void initState() {
    super.initState();
    speechProvider = SpeechToTextProvider(speech);
    _initSpeechState();
  }

  Future<void> _initSpeechState() async {
    await speechProvider.initialize();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=>MealProvider()),
          ChangeNotifierProvider<SpeechToTextProvider>.value(value: speechProvider,)
        ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
