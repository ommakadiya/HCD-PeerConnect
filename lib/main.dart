import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

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

class ParentDetail {
  String name;
  String originCity;
  String phone;
  String address;
  String occupation;
  String childEmailId;

  ParentDetail({
    this.name = '',
    this.originCity = '',
    this.phone = '',
    this.address = '',
    this.occupation = '',
    this.childEmailId = '',
  });

  bool get isComplete =>
      name.isNotEmpty &&
      originCity.isNotEmpty &&
      phone.isNotEmpty &&
      address.isNotEmpty &&
      occupation.isNotEmpty &&
      childEmailId.isNotEmpty;
}

class AppStateProvider extends ChangeNotifier {
  // Role: 'child' or 'parent'
  String? _role;
  bool _profileCompleted = false;

  // Common fields
  String _name = '';
  String _originCity = '';
  String _phone = '';
  String _address = '';
  String _occupation = '';

  // Child-specific fields
  String _migratedCity = '';
  String _parentName = '';
  String _parentEmail = '';

  // Parent-specific: list of 1-2 parent details
  List<ParentDetail> _parentDetails = [ParentDetail()];

  // Getters
  String? get role => _role;
  bool get profileCompleted => _profileCompleted;
  String get name => _name;
  String get originCity => _originCity;
  String get phone => _phone;
  String get address => _address;
  String get occupation => _occupation;
  String get migratedCity => _migratedCity;
  String get parentName => _parentName;
  String get parentEmail => _parentEmail;
  List<ParentDetail> get parentDetails => _parentDetails;

  void setRole(String role) {
    _role = role;
    // Reset parent details when switching role
    _parentDetails = [ParentDetail()];
    notifyListeners();
  }

  void completeChildProfile({
    required String name,
    required String originCity,
    required String migratedCity,
    required String phone,
    required String address,
    required String occupation,
    required String parentName,
    required String parentEmail,
  }) {
    _name = name;
    _originCity = originCity;
    _migratedCity = migratedCity;
    _phone = phone;
    _address = address;
    _occupation = occupation;
    _parentName = parentName;
    _parentEmail = parentEmail;
    _profileCompleted = true;
    notifyListeners();
  }

  void completeParentProfile({
    required List<ParentDetail> parents,
  }) {
    _parentDetails = parents;
    // Use first parent's info as the main profile info
    if (parents.isNotEmpty) {
      _name = parents[0].name;
      _originCity = parents[0].originCity;
      _phone = parents[0].phone;
      _address = parents[0].address;
      _occupation = parents[0].occupation;
    }
    _profileCompleted = true;
    notifyListeners();
  }

  bool get isProfileComplete => _profileCompleted;
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
      home: const SplashScreen(),
    );
  }
}
