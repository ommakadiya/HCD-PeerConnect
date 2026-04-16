import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        // Services — created once, available app-wide
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<UserService>(create: (_) => UserService()),

        // App state — depends on AuthService
        ChangeNotifierProxyProvider<AuthService, AppStateProvider>(
          create: (ctx) => AppStateProvider(
            authService: ctx.read<AuthService>(),
            userService: ctx.read<UserService>(),
          ),
          update: (ctx, auth, prev) =>
              prev ?? AppStateProvider(authService: auth, userService: ctx.read<UserService>()),
        ),
      ],
      child: const PeerConnectApp(),
    ),
  );
}

// ──────────────────────────────────────────────────────────────────────────────
// ParentDetail helper model (used in parent profile setup)
// ──────────────────────────────────────────────────────────────────────────────

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

  Map<String, String> toMap() => {
        'name': name,
        'originCity': originCity,
        'phone': phone,
        'address': address,
        'occupation': occupation,
        'childEmailId': childEmailId,
      };
}

// ──────────────────────────────────────────────────────────────────────────────
// AppStateProvider — merges auth state + Firestore profile data
// ──────────────────────────────────────────────────────────────────────────────

class AppStateProvider extends ChangeNotifier {
  final AuthService _authService;
  final UserService _userService;

  AppStateProvider({
    required AuthService authService,
    required UserService userService,
  })  : _authService = authService,
        _userService = userService;

  // ── Auth ────────────────────────────────────────────────────────────────

  bool _isLoggedIn = false;
  bool _profileCompleted = false;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get profileCompleted => _profileCompleted;
  bool get isLoading => _isLoading;

  // ── Profile fields ────────────────────────────────────────────────────────

  String? _role; // 'child' or 'parent'
  String _userId = '';
  String _name = '';
  String _email = '';
  String _photoUrl = '';
  String _originCity = '';
  String _phone = '';
  String _address = '';
  String _occupation = '';

  // Child-specific
  String _migratedCity = '';
  String _parentName = '';
  String _parentEmail = '';

  // Parent-specific
  List<ParentDetail> _parentDetails = [ParentDetail()];

  // ── Getters ────────────────────────────────────────────────────────────────

  String? get role => _role;
  String get userId => _userId;
  String get name => _name;
  String get email => _email;
  String get photoUrl => _photoUrl;
  String get originCity => _originCity;
  String get phone => _phone;
  String get address => _address;
  String get occupation => _occupation;
  String get migratedCity => _migratedCity;
  String get parentName => _parentName;
  String get parentEmail => _parentEmail;
  List<ParentDetail> get parentDetails => _parentDetails;
  bool get isProfileComplete => _profileCompleted;

  // ─── Sign-In ──────────────────────────────────────────────────────────────

  /// Signs in with Google and loads the user profile from Firestore.
  /// Returns true if a profile was already completed (skip role selection).
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final credential = await _authService.signInWithGoogle();
      if (credential == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final firebaseUser = credential.user!;
      _userId = firebaseUser.uid;
      _name = firebaseUser.displayName ?? '';
      _email = firebaseUser.email ?? '';
      _photoUrl = firebaseUser.photoURL ?? '';
      _isLoggedIn = true;

      // Upsert base user document
      await _userService.createOrUpdateUser(
        userId: _userId,
        name: _name,
        email: _email,
        photoUrl: _photoUrl,
      );

      // Load existing profile if present
      final profileComplete = await loadUserProfile();
      _isLoading = false;
      notifyListeners();
      return profileComplete;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Loads user profile data from Firestore into state.
  /// Returns true if the profile was already completed.
  Future<bool> loadUserProfile() async {
    if (_userId.isEmpty) return false;

    final data = await _userService.getUser(_userId);
    if (data == null) return false;

    _role = data['role'] as String?;
    _profileCompleted = data['profileCompleted'] == true;

    if (_profileCompleted) {
      _name = data['name'] ?? _name;

      if (_role == 'child') {
        final cp = data['childProfile'] as Map<String, dynamic>? ?? {};
        _originCity = cp['originCity'] ?? '';
        _migratedCity = cp['migratedCity'] ?? '';
        _phone = cp['phone'] ?? '';
        _address = cp['address'] ?? '';
        _occupation = cp['occupation'] ?? '';
        _parentName = cp['parentName'] ?? '';
        _parentEmail = cp['parentEmail'] ?? '';
      } else if (_role == 'parent') {
        final pp = data['parentProfile'] as Map<String, dynamic>? ?? {};
        final List rawParents = pp['parents'] as List? ?? [];
        _parentDetails = rawParents.map((p) {
          final m = Map<String, String>.from(p as Map);
          return ParentDetail(
            name: m['name'] ?? '',
            originCity: m['originCity'] ?? '',
            phone: m['phone'] ?? '',
            address: m['address'] ?? '',
            occupation: m['occupation'] ?? '',
            childEmailId: m['childEmailId'] ?? '',
          );
        }).toList();
        if (_parentDetails.isNotEmpty) {
          _originCity = _parentDetails[0].originCity;
          _phone = _parentDetails[0].phone;
          _address = _parentDetails[0].address;
          _occupation = _parentDetails[0].occupation;
        }
      }
    }

    notifyListeners();
    return _profileCompleted;
  }

  /// Call on app start if a Firebase user is already signed in.
  Future<bool> tryRestoreSession() async {
    final user = _authService.currentUser;
    if (user == null) return false;

    _userId = user.uid;
    _name = user.displayName ?? '';
    _email = user.email ?? '';
    _photoUrl = user.photoURL ?? '';
    _isLoggedIn = true;

    return loadUserProfile();
  }

  // ── Role & Profile setters ─────────────────────────────────────────────────

  void setRole(String role) {
    _role = role;
    _parentDetails = [ParentDetail()];
    notifyListeners();
    // Persist role to Firestore (fire-and-forget, ignore error here)
    if (_userId.isNotEmpty) {
      _userService.setRole(_userId, role);
    }
  }

  Future<void> completeChildProfile({
    required String name,
    required String originCity,
    required String migratedCity,
    required String phone,
    required String address,
    required String occupation,
    required String parentName,
    required String parentEmail,
  }) async {
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

    await _userService.saveChildProfile(
      userId: _userId,
      name: name,
      originCity: originCity,
      migratedCity: migratedCity,
      phone: phone,
      address: address,
      occupation: occupation,
      parentName: parentName,
      parentEmail: parentEmail,
    );
  }

  Future<void> completeParentProfile({
    required List<ParentDetail> parents,
  }) async {
    _parentDetails = parents;
    if (parents.isNotEmpty) {
      _name = parents[0].name;
      _originCity = parents[0].originCity;
      _phone = parents[0].phone;
      _address = parents[0].address;
      _occupation = parents[0].occupation;
    }
    _profileCompleted = true;
    notifyListeners();

    await _userService.saveParentProfile(
      userId: _userId,
      parents: parents.map((p) => p.toMap()).toList(),
    );
  }

  // ── Sign-Out ───────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _authService.signOut();
    _isLoggedIn = false;
    _profileCompleted = false;
    _userId = '';
    _name = '';
    _email = '';
    _photoUrl = '';
    _role = null;
    _originCity = '';
    _migratedCity = '';
    _phone = '';
    _address = '';
    _occupation = '';
    _parentName = '';
    _parentEmail = '';
    _parentDetails = [ParentDetail()];
    notifyListeners();
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// App Root
// ──────────────────────────────────────────────────────────────────────────────

class PeerConnectApp extends StatelessWidget {
  const PeerConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PeerConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        primaryColor: const Color(0xFF003366),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003366),
          primary: const Color(0xFF003366),
          surface: Colors.white,
          error: const Color(0xFFFF7F50),
        ),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyLarge: GoogleFonts.inter(fontSize: 18, color: const Color(0xFF2D3436)),
          bodyMedium: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF2D3436)),
          bodySmall: GoogleFonts.inter(color: const Color(0xFF636E72)),
          titleLarge: GoogleFonts.inter(color: const Color(0xFF2D3436), fontWeight: FontWeight.w600),
          titleMedium: GoogleFonts.inter(color: const Color(0xFF2D3436), fontWeight: FontWeight.w500),
        ).apply(
          bodyColor: const Color(0xFF2D3436),
          displayColor: const Color(0xFF2D3436),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF2D3436)),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF003366)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF003366),
          unselectedItemColor: Color(0xFF636E72),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
