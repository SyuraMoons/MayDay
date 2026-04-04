import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appBlack = Color(0xFF050505);
    const cardBlack = Color(0xFF111111);
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
      dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(color: Colors.white),
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
      title: 'Body Setup',
      theme: theme,
      home: const AppShell(),
    );
  }
}

class UserProfile {
  const UserProfile({
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.photoPath,
  });

  final String height;
  final String weight;
  final String age;
  final String gender;
  final String photoPath;

  bool get isComplete =>
      height.isNotEmpty &&
      weight.isNotEmpty &&
      age.isNotEmpty &&
      gender.isNotEmpty;

  static const empty = UserProfile(
    height: '',
    weight: '',
    age: '',
    gender: '',
    photoPath: '',
  );

  UserProfile copyWith({
    String? height,
    String? weight,
    String? age,
    String? gender,
    String? photoPath,
  }) {
    return UserProfile(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _heightKey = 'profile_height';
  static const _weightKey = 'profile_weight';
  static const _ageKey = 'profile_age';
  static const _genderKey = 'profile_gender';
  static const _photoPathKey = 'profile_photo_path';

  int _selectedIndex = 0;
  bool _isLoading = true;
  UserProfile _profile = UserProfile.empty;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profile = UserProfile(
      height: prefs.getString(_heightKey) ?? '',
      weight: prefs.getString(_weightKey) ?? '',
      age: prefs.getString(_ageKey) ?? '',
      gender: prefs.getString(_genderKey) ?? '',
      photoPath: prefs.getString(_photoPathKey) ?? '',
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  Future<void> _saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_heightKey, profile.height);
    await prefs.setString(_weightKey, profile.weight);
    await prefs.setString(_ageKey, profile.age);
    await prefs.setString(_genderKey, profile.gender);
    if (profile.photoPath.isEmpty) {
      await prefs.remove(_photoPathKey);
    } else {
      await prefs.setString(_photoPathKey, profile.photoPath);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _profile = profile;
      _selectedIndex = 0;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Profile saved locally'),
          backgroundColor: Colors.black,
        ),
      );
  }

  Future<void> _clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_heightKey);
    await prefs.remove(_weightKey);
    await prefs.remove(_ageKey);
    await prefs.remove(_genderKey);
    await prefs.remove(_photoPathKey);

    if (!mounted) {
      return;
    }

    setState(() {
      _profile = UserProfile.empty;
      _selectedIndex = 2;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Local profile cleared'),
          backgroundColor: Colors.black,
        ),
      );
  }

  void _goToInputTab() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final pages = [
      HomeScreen(profile: _profile, onEditProfile: _goToInputTab),
      InputScreen(profile: _profile, onSave: _saveProfile),
      ProfileScreen(
        profile: _profile,
        onEditProfile: _goToInputTab,
        onClearProfile: _clearProfile,
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
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.tune_outlined),
                  selectedIcon: Icon(Icons.tune),
                  label: 'Input',
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.profile,
    required this.onEditProfile,
  });

  final UserProfile profile;
  final VoidCallback onEditProfile;

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
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: const Color(0xFF4B4B4B)),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.motion_photos_on, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text('Movement readiness', style: textTheme.displaySmall),
            const SizedBox(height: 12),
            Text(
              'Build the body profile that will drive future physics simulation and exercise prerequisite recommendations.',
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
                    isComplete ? 'Profile ready' : 'Profile incomplete',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isComplete
                        ? 'Your body data is saved locally and ready for the next analysis steps.'
                        : 'Add your core body measurements first so the app can estimate movement requirements later.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFB8B8B8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: onEditProfile,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE5E5E5),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      isComplete ? 'Edit body data' : 'Complete profile',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Current body inputs', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            _SummaryGrid(profile: profile),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                border: Border.all(color: const Color(0xFF4B4B4B)),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Simulation and posture scoring come next. This first version focuses on collecting clean body inputs and keeping them available across the app.',
                style: textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key, required this.profile, required this.onSave});

  final UserProfile profile;
  final Future<void> Function(UserProfile) onSave;

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _ageController;
  final _imagePicker = ImagePicker();
  String? _selectedGender;
  String _photoPath = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(text: widget.profile.height);
    _weightController = TextEditingController(text: widget.profile.weight);
    _ageController = TextEditingController(text: widget.profile.age);
    _selectedGender = widget.profile.gender.isEmpty
        ? null
        : widget.profile.gender;
    _photoPath = widget.profile.photoPath;
  }

  @override
  void didUpdateWidget(covariant InputScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _heightController.text = widget.profile.height;
      _weightController.text = widget.profile.weight;
      _ageController.text = widget.profile.age;
      _selectedGender = widget.profile.gender.isEmpty
          ? null
          : widget.profile.gender;
      _photoPath = widget.profile.photoPath;
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  String? _requiredNumber(String? value, String label) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '$label is required';
    }

    final parsed = num.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid $label';
    }

    return null;
  }

  Future<void> _pickPhoto(ImageSource source) async {
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
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final profile = UserProfile(
      height: _heightController.text.trim(),
      weight: _weightController.text.trim(),
      age: _ageController.text.trim(),
      gender: _selectedGender!,
      photoPath: _photoPath,
    );

    await widget.onSave(profile);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });
  }

  Widget _buildMetricField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          style: Theme.of(context).textTheme.bodyLarge,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) => _requiredNumber(value, label.toLowerCase()),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  String get _photoLabel {
    if (_photoPath.isEmpty) {
      return 'No photo selected';
    }

    final normalized = _photoPath.replaceAll('\\', '/');
    final segments = normalized.split('/');
    return segments.isEmpty ? 'Photo selected' : segments.last;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  border: Border.all(color: const Color(0xFF4B4B4B)),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.tune, color: Colors.white),
              ),
              const SizedBox(height: 28),
              Text('Body input', style: textTheme.displaySmall),
              const SizedBox(height: 12),
              Text(
                'Save the physical measurements that will later shape your movement simulation model.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF4B4B4B)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetricField(
                      label: 'Height',
                      hint: 'cm',
                      controller: _heightController,
                    ),
                    const SizedBox(height: 18),
                    _buildMetricField(
                      label: 'Weight',
                      hint: 'kg',
                      controller: _weightController,
                    ),
                    const SizedBox(height: 18),
                    _buildMetricField(
                      label: 'Age',
                      hint: 'years',
                      controller: _ageController,
                    ),
                    const SizedBox(height: 18),
                    Text('Gender', style: textTheme.bodyLarge),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      dropdownColor: const Color(0xFF171717),
                      iconEnabledColor: Colors.white,
                      style: textTheme.bodyLarge,
                      items: const [
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Gender is required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Select gender',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF4B4B4B)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Posture photo', style: textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Add a photo from your gallery or take a picture now. This stays optional and saves locally with your profile.',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF171717),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFF4B4B4B)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFF4B4B4B),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.photo_camera_back_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _photoPath.isEmpty
                                      ? 'Photo status'
                                      : 'Selected photo',
                                  style: textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(_photoLabel, style: textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          if (_photoPath.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _photoPath = '';
                                });
                              },
                              tooltip: 'Remove photo',
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickPhoto(ImageSource.gallery),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFF6A6A6A)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Add photo'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => _pickPhoto(ImageSource.camera),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFE5E5E5),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: const Icon(Icons.photo_camera_outlined),
                            label: const Text('Take picture'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  border: Border.all(color: const Color(0xFF4B4B4B)),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'This data stays on-device in v1 and updates the Home and Profile tabs immediately after save.',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE5E5E5),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text('Save profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onEditProfile,
    required this.onClearProfile,
  });

  final UserProfile profile;
  final VoidCallback onEditProfile;
  final Future<void> Function() onClearProfile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                border: Border.all(color: const Color(0xFF4B4B4B)),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(height: 28),
            Text('Profile', style: textTheme.displaySmall),
            const SizedBox(height: 12),
            Text(
              'Review the body data stored on this device and manage the local profile state.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            _SummaryCard(profile: profile),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onEditProfile,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE5E5E5),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Edit profile'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onClearProfile,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF6A6A6A)),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Clear local data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.profile});

  final UserProfile profile;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Saved profile', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          _SummaryGrid(profile: profile),
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
          label: 'Age',
          value: profile.age.isEmpty ? 'Not set' : '${profile.age} years',
        ),
        _SummaryTile(
          label: 'Gender',
          value: profile.gender.isEmpty ? 'Not set' : profile.gender,
        ),
      ],
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
