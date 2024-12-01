import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/providers/comments_provider.dart';
import 'package:recipe/screens/main_screen.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';
import 'firebase_options.dart';
import 'providers/meal_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          ChangeNotifierProvider<SpeechToTextProvider>.value(value: speechProvider,),
          ChangeNotifierProvider(create: (_) => CommentProvider()),
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
