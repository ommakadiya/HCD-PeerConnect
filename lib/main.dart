import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ],
      child: const PeerConnectApp(),
    ),
  );
}

class AppStateProvider extends ChangeNotifier {
  // Temporary provider setup
}

class PeerConnectApp extends StatelessWidget {
  const PeerConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PeerConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          // Ensure large default font sizes for accessibility
          bodyMedium: GoogleFonts.inter(fontSize: 16),
          bodyLarge: GoogleFonts.inter(fontSize: 18),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
