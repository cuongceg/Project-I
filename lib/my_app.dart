import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/core/colors.dart';
import 'package:recipe/model/user.dart';
import 'package:recipe/providers/comments_provider.dart';
import 'package:recipe/screens/main_screen.dart';
import 'package:recipe/services/authentication_service.dart';
import 'package:recipe/services/user_database.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text_provider.dart';
import 'providers/meal_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        StreamProvider<List<UserInformation>?>.value(value: UserDatabase().authData, initialData: null),
        StreamProvider<User?>.value(value:AuthService().authState, initialData: null),
        ChangeNotifierProvider(create: (context)=>MealProvider()),
        ChangeNotifierProvider<SpeechToTextProvider>.value(value: speechProvider,),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: ConstColor().primary,
        ),
        home: const MainScreen(),
      ),
    );
  }
}