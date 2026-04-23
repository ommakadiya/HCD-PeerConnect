import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'providers/user_provider.dart';
import 'providers/connection_provider.dart';
import 'providers/data_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()..loadData()),
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
  bool _isDarkMode = false;

  // Common fields
  String _name = '';
  String _originCity = '';
  String _phone = '';
  String _address = '';
  String _occupation = '';

  // Child-specific fields
  String _university = '';
  String _course = '';
  String _migratedCity = '';
  String _migratedCountry = '';
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
  String get university => _university;
  String get course => _course;
  String get migratedCity => _migratedCity;
  String get migratedCountry => _migratedCountry;
  String get parentName => _parentName;
  String get parentEmail => _parentEmail;
  List<ParentDetail> get parentDetails => _parentDetails;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void setRole(String role) {
    _role = role;
    // Reset parent details when switching role
    _parentDetails = [ParentDetail()];
    notifyListeners();
  }

  void completeChildProfile({
    required String name,
    required String originCity,
    required String university,
    required String course,
    required String migratedCity,
    required String migratedCountry,
    required String phone,
    required String address,
    required String occupation,
    required String parentName,
    required String parentEmail,
  }) {
    _name = name;
    _originCity = originCity;
    _university = university;
    _course = course;
    _migratedCity = migratedCity;
    _migratedCountry = migratedCountry;
    _phone = phone;
    _address = address;
    _occupation = occupation;
    _parentName = parentName;
    _parentEmail = parentEmail;
    _profileCompleted = true;
    notifyListeners();
  }

  void updateProfile({String? name, String? university, String? course}) {
    if (name != null && name.isNotEmpty) _name = name;
    if (university != null && university.isNotEmpty) _university = university;
    if (course != null && course.isNotEmpty) _course = course;
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

  void resetData() {
    _role = null;
    _profileCompleted = false;
    _name = '';
    _originCity = '';
    _phone = '';
    _address = '';
    _occupation = '';
    _university = '';
    _course = '';
    _migratedCity = '';
    _migratedCountry = '';
    _parentName = '';
    _parentEmail = '';
    _parentDetails = [ParentDetail()];
    notifyListeners();
  }

  bool get isProfileComplete => _profileCompleted;
}

class PeerConnectApp extends StatelessWidget {
  const PeerConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppStateProvider>(context);

    return MaterialApp(
      title: 'PeerConnect',
      debugShowCheckedModeBanner: false,
      themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
