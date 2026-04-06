import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await apiService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appBlack = Color(0xFF050505);
    const panelBlack = Color(0xFF171717);
    const softGrey = Color(0xFFB8B8B8);
    const borderGrey = Color(0xFF4B4B4B);
    const hintGrey = Color(0xFF8E8E8E);

    final theme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: appBlack,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Color(0xFFB8B8B8),
        onSecondary: Colors.black,
        surface: Color(0xFF111111),
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1.05,
          letterSpacing: -1.2,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.4,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.2,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: softGrey,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          letterSpacing: 0.2,
        ),
      ),
      dividerColor: borderGrey,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF1A1A1A),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF111111),
        indicatorColor: Color(0xFFE5E5E5),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: Color(0xFFB8B8B8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: panelBlack,
        hintStyle: const TextStyle(color: hintGrey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: softGrey, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionColor: Color(0x66FFFFFF),
        selectionHandleColor: Colors.white,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mayday',
      theme: theme,
      home: const AppBootstrap(),
    );
  }
}

class UserAccount {
  const UserAccount({
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
    required this.password,
  });

  final String name;
  final String age;
  final String gender;
  final String email;
  final String password;

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      name: json['name'] as String? ?? '',
      age: json['age']?.toString() ?? '',
      gender: json['gender'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: '',
    );
  }
}

class UserProfile {
  const UserProfile({
    this.id,
    required this.height,
    required this.weight,
    required this.photoPath,
  });

  final int? id;
  final String height;
  final String weight;
  final String photoPath;

  bool get isComplete => height.isNotEmpty && weight.isNotEmpty;

  static const empty = UserProfile(height: '', weight: '', photoPath: '');

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int?,
      height: json['height_cm']?.toString() ?? '',
      weight: json['weight_kg']?.toString() ?? '',
      photoPath: json['photo_path'] as String? ?? '',
    );
  }
}

class MovementGoal {
  const MovementGoal({
    required this.id,
    required this.name,
    required this.category,
    required this.summary,
    required this.focus,
    required this.benchmark,
    required this.jointDemand,
    required this.exercisePlan,
  });

  final String id;
  final String name;
  final String category;
  final String summary;
  final String focus;
  final String benchmark;
  final String jointDemand;
  final String exercisePlan;
}

const demoGoals = <MovementGoal>[
  MovementGoal(
    id: 'backflip',
    name: 'Backflip',
    category: 'Power',
    summary:
        'Build the lower-body and trunk force needed to rotate safely and leave the floor with margin.',
    focus: 'Hip extension, knee drive, and trunk stiffness',
    benchmark: 'Example benchmark: squat 100 kg with stable takeoff mechanics',
    jointDemand:
        'High ankle, knee, hip, and trunk torque during takeoff and rotation',
    exercisePlan:
        'Prioritize squats, jump progressions, posterior-chain work, and landing drills.',
  ),
  MovementGoal(
    id: 'pistol-squat',
    name: 'Pistol Squat',
    category: 'Control',
    summary:
        'Develop single-leg strength and balance so you can lower and stand without losing alignment.',
    focus: 'Single-leg knee strength, ankle mobility, and hip stability',
    benchmark:
        'Example benchmark: controlled split squat plus single-leg sit-to-stand capacity',
    jointDemand:
        'Sustained knee and hip torque with high balance demand on one leg',
    exercisePlan:
        'Prioritize split squats, heel-elevated work, tibialis training, and tempo control.',
  ),
  MovementGoal(
    id: 'handstand',
    name: 'Handstand',
    category: 'Skill',
    summary:
        'Improve overhead support strength and full-body line control so you can stack joints safely.',
    focus:
        'Shoulder elevation strength, wrist tolerance, and trunk line control',
    benchmark:
        'Example benchmark: overhead press and wall-supported line hold targets',
    jointDemand: 'High wrist, elbow, shoulder, and trunk stabilization demand',
    exercisePlan:
        'Prioritize pike presses, wall holds, scapular strength, and wrist loading progressions.',
  ),
];

enum SignUpResult { success, duplicate, confirmationRequired, failure }

enum LoginResult { success, invalid, failure }

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  bool _isLoading = true;
  UserAccount? _currentAccount;
  UserProfile _profile = UserProfile.empty;

  @override
  void initState() {
    super.initState();
    _loadAppState();
  }

  Future<void> _loadAppState() async {
    final userJson = await apiService.getCurrentAccount();
    if (userJson != null) {
      final records = await apiService.getBodyRecords();
      if (!mounted) return;
      setState(() {
        _currentAccount = UserAccount.fromJson(userJson);
        if (records.isNotEmpty) {
          _profile = UserProfile.fromJson(records.first);
        } else {
          _profile = UserProfile.empty;
        }
        _isLoading = false;
      });
    } else {
      await apiService.logout();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _currentAccount = null;
        _profile = UserProfile.empty;
      });
    }
  }

  Future<void> _saveProfile(UserProfile profile) async {
    final height = double.tryParse(profile.height) ?? 0.0;
    final weight = double.tryParse(profile.weight) ?? 0.0;
    final account = _currentAccount;

    if (account == null) {
      return;
    }

    final record = await apiService.createBodyRecord(
      heightCm: height,
      weightKg: weight,
      age: account.age,
      gender: account.gender,
      photo: profile.photoPath.isNotEmpty ? XFile(profile.photoPath) : null,
    );

    if (record != null && mounted) {
      setState(() {
        _profile = UserProfile.fromJson(record);
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Profile saved successfully')),
        );
    }
  }

  Future<void> _clearProfile() async {
    if (_profile.id != null) {
      await apiService.deleteBodyRecord(_profile.id!);
    }

    final records = await apiService.getBodyRecords();
    if (!mounted) return;

    if (records.isNotEmpty) {
      setState(() {
        _profile = UserProfile.fromJson(records.first);
      });
    } else {
      setState(() {
        _profile = UserProfile.empty;
      });
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Record deleted')));
  }

  Future<SignUpResult> _registerAccount(UserAccount account) async {
    final data = {
      'name': account.name,
      'age': account.age,
      'gender': account.gender,
      'email': account.email,
      'password': account.password,
    };
    final result = await apiService.register(
      name: data['name']!,
      age: data['age']!,
      gender: data['gender']!,
      email: data['email']!,
      password: data['password']!,
    );
    switch (result.status) {
      case RegisterStatus.success:
        return SignUpResult.success;
      case RegisterStatus.duplicateLoginId:
        return SignUpResult.duplicate;
      case RegisterStatus.confirmationRequired:
        return SignUpResult.confirmationRequired;
      case RegisterStatus.failure:
        return SignUpResult.failure;
    }
  }

  Future<LoginResult> _login(String email, String password) async {
    final result = await apiService.login(email, password);
    switch (result.status) {
      case LoginStatus.success:
        await _loadAppState();
        return LoginResult.success;
      case LoginStatus.invalidCredentials:
        return LoginResult.invalid;
      case LoginStatus.failure:
        return LoginResult.failure;
    }
  }

  Future<void> _logout() async {
    await apiService.logout();
    if (!mounted) return;
    setState(() {
      _currentAccount = null;
      _profile = UserProfile.empty;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_currentAccount == null) {
      return AuthFlow(onLogin: _login, onRegister: _registerAccount);
    }

    return AppShell(
      currentAccount: _currentAccount!,
      profile: _profile,
      onSaveProfile: _saveProfile,
      onClearProfile: _clearProfile,
      onLogout: _logout,
    );
  }
}

class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key, required this.onLogin, required this.onRegister});

  final Future<LoginResult> Function(String email, String password) onLogin;
  final Future<SignUpResult> Function(UserAccount account) onRegister;

  @override
  State<AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> {
  bool _showSignUp = false;
  String _prefilledEmail = '';

  void _openLogin([String email = '']) {
    setState(() {
      _showSignUp = false;
      _prefilledEmail = email;
    });
  }

  void _openSignUp() {
    setState(() {
      _showSignUp = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSignUp
        ? SignUpScreen(onRegister: widget.onRegister, onBackToLogin: _openLogin)
        : LoginScreen(
            onLogin: widget.onLogin,
            onOpenSignUp: _openSignUp,
            initialEmail: _prefilledEmail,
          );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onOpenSignUp,
    this.initialEmail = '',
  });

  final Future<LoginResult> Function(String email, String password) onLogin;
  final VoidCallback onOpenSignUp;
  final String initialEmail;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialEmail != widget.initialEmail) {
      _emailController.text = widget.initialEmail;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final result = await widget.onLogin(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (result == LoginResult.invalid) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
    } else if (result == LoginResult.failure) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Login failed. Check Supabase Auth configuration.'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    border: Border.all(color: const Color(0xFF4B4B4B)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.lock_outline, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Text('Login', style: textTheme.displaySmall),
                const SizedBox(height: 12),
                Text(
                  'Sign in with your email and password to access your body profile and movement workflow.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 28),
                _AuthCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AuthField(
                        label: 'Email',
                        child: TextFormField(
                          controller: _emailController,
                          style: textTheme.bodyLarge,
                          keyboardType: TextInputType.emailAddress,
                          validator: _requiredEmail('Email'),
                          decoration: const InputDecoration(
                            hintText: 'you@example.com',
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _AuthField(
                        label: 'Password',
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: textTheme.bodyLarge,
                          validator: _requiredField('Password'),
                          decoration: const InputDecoration(
                            hintText: 'Enter password',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: _primaryButtonStyle(),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: widget.onOpenSignUp,
                    style: _secondaryButtonStyle(),
                    child: const Text('Create account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.onRegister,
    required this.onBackToLogin,
  });

  final Future<SignUpResult> Function(UserAccount account) onRegister;
  final ValueChanged<String> onBackToLogin;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedGender;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final result = await widget.onRegister(
      UserAccount(
        name: _nameController.text.trim(),
        age: _ageController.text.trim(),
        gender: _selectedGender!,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (result == SignUpResult.duplicate) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('That email is already registered. Use another one.'),
          ),
        );
      return;
    }

    if (result == SignUpResult.confirmationRequired) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Sign up created the account, but email confirmation is enabled in Supabase.',
            ),
          ),
        );
      widget.onBackToLogin(_emailController.text.trim());
      return;
    }

    if (result == SignUpResult.failure) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Sign up failed. Verify the Supabase schema and Auth settings.',
            ),
          ),
        );
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Sign up complete')));
    widget.onBackToLogin(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    border: Border.all(color: const Color(0xFF4B4B4B)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.person_add_alt_1,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Text('Create account', style: textTheme.displaySmall),
                const SizedBox(height: 12),
                Text(
                  'Enter member information, add your email and password, then request registration.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 28),
                _AuthCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AuthField(
                        label: 'Name',
                        child: TextFormField(
                          controller: _nameController,
                          style: textTheme.bodyLarge,
                          validator: _requiredField('Name'),
                          decoration: const InputDecoration(
                            hintText: 'Your name',
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _AuthField(
                        label: 'Age',
                        child: TextFormField(
                          controller: _ageController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: textTheme.bodyLarge,
                          validator: _requiredPositiveNumber('Age'),
                          decoration: const InputDecoration(hintText: 'Age'),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _AuthField(
                        label: 'Gender',
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedGender,
                          dropdownColor: const Color(0xFF171717),
                          iconEnabledColor: Colors.white,
                          style: textTheme.bodyLarge,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Gender is required';
                            }
                            return null;
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Non-binary',
                              child: Text('Non-binary'),
                            ),
                            DropdownMenuItem(
                              value: 'Prefer not to say',
                              child: Text('Prefer not to say'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Select gender',
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _AuthField(
                        label: 'Email',
                        child: TextFormField(
                          controller: _emailController,
                          style: textTheme.bodyLarge,
                          keyboardType: TextInputType.emailAddress,
                          validator: _requiredEmail('Email'),
                          decoration: const InputDecoration(
                            hintText: 'you@example.com',
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _AuthField(
                        label: 'Password',
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: textTheme.bodyLarge,
                          validator: _requiredField('Password'),
                          decoration: const InputDecoration(
                            hintText: 'Create password',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: _primaryButtonStyle(),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text('Request registration'),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => widget.onBackToLogin(''),
                    style: _secondaryButtonStyle(),
                    child: const Text('Back to login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.currentAccount,
    required this.profile,
    required this.onSaveProfile,
    required this.onClearProfile,
    required this.onLogout,
  });

  final UserAccount currentAccount;
  final UserProfile profile;
  final Future<void> Function(UserProfile profile) onSaveProfile;
  final Future<void> Function() onClearProfile;
  final Future<void> Function() onLogout;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  MovementGoal? _selectedGoal;

  void _goToPlanTab() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void _goToProfileTab() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      GoalScreen(
        account: widget.currentAccount,
        profile: widget.profile,
        selectedGoal: _selectedGoal,
        onSelectGoal: (goal) {
          setState(() {
            _selectedGoal = goal;
          });
        },
        onOpenPlan: _goToPlanTab,
        onOpenProfile: _goToProfileTab,
      ),
      PlanScreen(
        profile: widget.profile,
        goal: _selectedGoal,
        onOpenProfile: _goToProfileTab,
        onOpenGoal: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
      ProfileScreen(
        account: widget.currentAccount,
        profile: widget.profile,
        onSaveProfile: widget.onSaveProfile,
        onOpenPlan: _goToPlanTab,
        onClearProfile: widget.onClearProfile,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: NavigationBar(
              height: 74,
              backgroundColor: const Color(0xFF111111),
              indicatorColor: const Color(0xFFE5E5E5),
              selectedIndex: _selectedIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.flag_outlined),
                  selectedIcon: Icon(Icons.flag),
                  label: 'Goal',
                ),
                NavigationDestination(
                  icon: Icon(Icons.rule_folder_outlined),
                  selectedIcon: Icon(Icons.rule_folder),
                  label: 'Plan',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoalScreen extends StatelessWidget {
  const GoalScreen({
    super.key,
    required this.account,
    required this.profile,
    required this.selectedGoal,
    required this.onSelectGoal,
    required this.onOpenPlan,
    required this.onOpenProfile,
  });

  final UserAccount account;
  final UserProfile profile;
  final MovementGoal? selectedGoal;
  final ValueChanged<MovementGoal> onSelectGoal;
  final VoidCallback onOpenPlan;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isComplete = profile.isComplete;
    final highlightedGoal = selectedGoal ?? demoGoals.first;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: const Color(0xFF4B4B4B)),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.flag, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text('Choose a goal', style: textTheme.displaySmall),
            const SizedBox(height: 12),
            Text(
              'Welcome ${account.name}. Start with the movement you want to achieve, then Mayday translates the required body capacity into simple training targets.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                border: Border.all(color: const Color(0xFF4B4B4B)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedGoal == null
                        ? 'No movement selected'
                        : 'Selected movement',
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedGoal == null
                        ? 'Pick a target movement first. The plan screen will turn that goal into understandable strength requirements.'
                        : '${highlightedGoal.name}: ${highlightedGoal.summary}',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton(
                        onPressed: onOpenPlan,
                        style: _primaryButtonStyle(),
                        child: const Text('Open plan'),
                      ),
                      OutlinedButton(
                        onPressed: onOpenProfile,
                        style: _secondaryButtonStyle(),
                        child: Text(
                          isComplete
                              ? 'Edit profile setup'
                              : 'Complete profile setup',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Search movements', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            _AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    readOnly: true,
                    style: textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: 'Search for a movement goal',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'UI-first concept state: search is present for the intended flow, and suggested goals below drive the current demo.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Suggested goals', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final goal in demoGoals) ...[
              _GoalCard(
                goal: goal,
                isSelected: selectedGoal?.id == goal.id,
                onTap: () => onSelectGoal(goal),
              ),
              if (goal != demoGoals.last) const SizedBox(height: 12),
            ],
            const SizedBox(height: 20),
            Text('Profile setup status', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            _SummaryGrid(profile: profile),
          ],
        ),
      ),
    );
  }
}

class PlanScreen extends StatelessWidget {
  const PlanScreen({
    super.key,
    required this.profile,
    required this.goal,
    required this.onOpenProfile,
    required this.onOpenGoal,
  });

  final UserProfile profile;
  final MovementGoal? goal;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenGoal;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isComplete = profile.isComplete;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Strength plan', style: textTheme.displaySmall),
            const SizedBox(height: 12),
            Text(
              'This screen translates a target movement into understandable body-capacity goals. The current build uses polished demo content to shape the future product.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            if (goal == null) ...[
              _AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select a movement first',
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose a goal in the Goal tab before Mayday can show what to strengthen and how to interpret the requirement.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onOpenGoal,
                        style: _primaryButtonStyle(),
                        child: const Text('Open goal selection'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (!isComplete) ...[
              _AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile setup required',
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your core measurements and skeletal reference photo in Profile Setup so future simulation can use the right body context.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onOpenProfile,
                        style: _primaryButtonStyle(),
                        child: const Text('Open profile setup'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (goal != null) ...[
              _AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goal!.name, style: textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(goal!.summary, style: textTheme.bodyMedium),
                    const SizedBox(height: 20),
                    _StatusStrip(label: 'Category', value: goal!.category),
                    _StatusStrip(label: 'Focus', value: goal!.focus),
                    _StatusStrip(label: 'Benchmark', value: goal!.benchmark),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'Required body capacity',
                body:
                    'Demo UI state. In the full product, physics simulation and reinforcement learning will estimate how much joint torque and support capacity this movement needs for your body.',
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Joint demand translation',
                body: goal!.jointDemand,
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Training direction',
                body: goal!.exercisePlan,
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Future movement capture',
                body:
                    'Movement capture is intentionally removed from the primary workflow for now. It may return later after the pose-estimation noise problem is solved.',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.account,
    required this.profile,
    required this.onSaveProfile,
    required this.onOpenPlan,
    required this.onClearProfile,
    required this.onLogout,
  });

  final UserAccount account;
  final UserProfile profile;
  final Future<void> Function(UserProfile profile) onSaveProfile;
  final VoidCallback onOpenPlan;
  final Future<void> Function() onClearProfile;
  final Future<void> Function() onLogout;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  final _imagePicker = ImagePicker();
  String _photoPath = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(text: widget.profile.height);
    _weightController = TextEditingController(text: widget.profile.weight);
    _photoPath = widget.profile.photoPath;
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _heightController.text = widget.profile.height;
      _weightController.text = widget.profile.weight;
      _photoPath = widget.profile.photoPath;
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickReferenceImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1600,
      imageQuality: 85,
    );

    if (image == null || !mounted) {
      return;
    }

    setState(() {
      _photoPath = image.path;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await widget.onSaveProfile(
      UserProfile(
        height: _heightController.text.trim(),
        weight: _weightController.text.trim(),
        photoPath: _photoPath,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile', style: textTheme.displaySmall),
            const SizedBox(height: 12),
            Text(
              'Review account details and complete profile setup for the movement-readiness model.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            _AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Member account', style: textTheme.titleMedium),
                  const SizedBox(height: 16),
                  _AccountInfoRow(label: 'Name', value: widget.account.name),
                  _AccountInfoRow(label: 'Age', value: widget.account.age),
                  _AccountInfoRow(
                    label: 'Gender',
                    value: widget.account.gender,
                  ),
                  _AccountInfoRow(label: 'Email', value: widget.account.email),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saved body setup', style: textTheme.titleMedium),
                  const SizedBox(height: 16),
                  _SummaryGrid(profile: widget.profile),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: _AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profile setup', style: textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Store the core body information used before generating a movement-readiness plan. The photo is used only for skeletal-structure identification.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    _AuthField(
                      label: 'Height',
                      child: TextFormField(
                        controller: _heightController,
                        style: textTheme.bodyLarge,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _requiredPositiveNumber('Height'),
                        decoration: const InputDecoration(hintText: 'cm'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _AuthField(
                      label: 'Weight',
                      child: TextFormField(
                        controller: _weightController,
                        style: textTheme.bodyLarge,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _requiredPositiveNumber('Weight'),
                        decoration: const InputDecoration(hintText: 'kg'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Skeletal reference photo',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _photoPath.isEmpty
                          ? 'No photo selected'
                          : _photoPath.split('/').last,
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use one clear full-body photo. This is not for live tracking or real-time posture correction.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _pickReferenceImage(ImageSource.gallery),
                            style: _secondaryButtonStyle(),
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Choose photo'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () =>
                                _pickReferenceImage(ImageSource.camera),
                            style: _primaryButtonStyle(),
                            icon: const Icon(Icons.photo_camera_outlined),
                            label: const Text('Take photo'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isSaving ? null : _submit,
                        style: _primaryButtonStyle(),
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Text('Save profile setup'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: widget.profile.isComplete ? widget.onOpenPlan : null,
                style: _primaryButtonStyle(),
                child: const Text('Open strength plan'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: widget.onClearProfile,
                style: _secondaryButtonStyle(),
                child: const Text('Delete latest record'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: widget.onLogout,
                style: _secondaryButtonStyle(),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF4B4B4B)),
      ),
      child: child,
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _AccountInfoRow extends StatelessWidget {
  const _AccountInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _SummaryTile(
          label: 'Height',
          value: profile.height.isEmpty ? 'Not set' : '${profile.height} cm',
        ),
        _SummaryTile(
          label: 'Weight',
          value: profile.weight.isEmpty ? 'Not set' : '${profile.weight} kg',
        ),
        _SummaryTile(
          label: 'Skeletal photo',
          value: profile.photoPath.isEmpty ? 'Not set' : 'Attached',
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  final MovementGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E1E1E) : const Color(0xFF171717),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? Colors.white : const Color(0xFF4B4B4B),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.track_changes, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.name, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 4),
                  Text(
                    '${goal.category} • ${goal.focus}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              isSelected ? Icons.check_circle : Icons.chevron_right,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _AuthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  const _StatusStrip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          border: Border.all(color: const Color(0xFF4B4B4B)),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

FormFieldValidator<String> _requiredField(String label) {
  return (value) {
    if ((value ?? '').trim().isEmpty) {
      return '$label is required';
    }
    return null;
  };
}

FormFieldValidator<String> _requiredEmail(String label) {
  return (value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) {
      return '$label is required';
    }
    final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid $label';
    }
    return null;
  };
}

FormFieldValidator<String> _requiredPositiveNumber(String label) {
  return (value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) {
      return '$label is required';
    }
    final parsed = num.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid $label';
    }
    return null;
  };
}

ButtonStyle _primaryButtonStyle() {
  return FilledButton.styleFrom(
    backgroundColor: const Color(0xFFE5E5E5),
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
}

ButtonStyle _secondaryButtonStyle() {
  return OutlinedButton.styleFrom(
    foregroundColor: Colors.white,
    side: const BorderSide(color: Color(0xFF6A6A6A)),
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
}
