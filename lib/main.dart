// Developed by: Ahmar Yar Khan
// Insta: codexahmar
// Tiktok: codexahmar
// LinkedIn: https://www.linkedin.com/in/ahmaryarkhan/
// Download Islam Plus on Google Play: https://play.google.com/store/apps/details?id=com.codexahmar.islamplus

import 'package:asma_ul_husna/provider/audio_provider.dart';
import 'package:asma_ul_husna/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that JustAudioBackground can be set up correctly
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialization for just_audio_background.
  // This is mandatory for background audio playback and system notification controls.
  // It allows the audio to continue playing even when the app is minimized or the screen is locked.
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  
  runApp(
    MultiProvider(
      providers: [
        // Providing AudioProvider globally using Provider package for state management
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Asma-ul-Husna',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
