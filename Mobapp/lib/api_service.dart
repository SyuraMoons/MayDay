import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseEnvironment {
  static const String url = 'https://jcdzfnptmdnapauuurjf.supabase.co';
  static const String publishableKey =
      'sb_publishable_BDTMt0gwg7FCDHrBKF5WhA_IBRzVPTg';
  static const String profileTable = 'profiles';
  static const String bodyRecordsTable = 'body_records';
  static const String photosBucket = 'profile-photos';
}

enum RegisterStatus { success, duplicateLoginId, confirmationRequired, failure }

enum LoginStatus { success, invalidCredentials, failure }

class RegisterResult {
  const RegisterResult(this.status, {this.message});

  final RegisterStatus status;
  final String? message;
}

class LoginResultData {
  const LoginResultData(this.status, {this.message});

  final LoginStatus status;
  final String? message;
}

class ApiService {
  bool _isInitialized = false;

  SupabaseClient get _client => Supabase.instance.client;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    await Supabase.initialize(
      url: SupabaseEnvironment.url,
      anonKey: SupabaseEnvironment.publishableKey,
    );
    _isInitialized = true;
  }

  String _normalizedEmail(String email) => email.trim().toLowerCase();

  String _safeFilename(String value) {
    return value.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  }

  String _contentTypeForFile(XFile photo) {
    final lower = photo.name.toLowerCase();
    if (lower.endsWith('.png')) {
      return 'image/png';
    }
    if (lower.endsWith('.webp')) {
      return 'image/webp';
    }
    return 'image/jpeg';
  }

  bool get isReady => _isInitialized;

  Future<RegisterResult> register({
    required String name,
    required String age,
    required String gender,
    required String email,
    required String password,
  }) async {
    if (!isReady) {
      return const RegisterResult(
        RegisterStatus.failure,
        message: 'Supabase is not initialized.',
      );
    }

    final normalizedEmail = _normalizedEmail(email);

    try {
      final existingProfile = await _client
          .from(SupabaseEnvironment.profileTable)
          .select('user_id')
          .eq('email', normalizedEmail)
          .maybeSingle();

      if (existingProfile != null) {
        return const RegisterResult(RegisterStatus.duplicateLoginId);
      }

      final authResponse = await _client.auth.signUp(
        email: normalizedEmail,
        password: password,
        data: <String, dynamic>{
          'email': normalizedEmail,
          'name': name.trim(),
          'age': age.trim(),
          'gender': gender,
        },
      );

      final user = authResponse.user;
      final session = authResponse.session;

      if (user == null) {
        return const RegisterResult(
          RegisterStatus.failure,
          message: 'Supabase did not return a user record.',
        );
      }

      if (session == null) {
        return const RegisterResult(
          RegisterStatus.confirmationRequired,
          message:
              'Sign-up succeeded, but email confirmation is enabled in Supabase Auth.',
        );
      }

      await _client.from(SupabaseEnvironment.profileTable).upsert(<String, dynamic>{
        'user_id': user.id,
        'email': normalizedEmail,
        'name': name.trim(),
        'age': age.trim(),
        'gender': gender,
      });

      return const RegisterResult(RegisterStatus.success);
    } on AuthException catch (error) {
      final message = error.message.toLowerCase();
      if (message.contains('already registered') ||
          message.contains('already been registered') ||
          message.contains('user already registered')) {
        return RegisterResult(
          RegisterStatus.duplicateLoginId,
          message: error.message,
        );
      }
      return RegisterResult(RegisterStatus.failure, message: error.message);
    } on PostgrestException catch (error) {
      final message = error.message.toLowerCase();
      if (message.contains('duplicate') || message.contains('unique')) {
        return RegisterResult(
          RegisterStatus.duplicateLoginId,
          message: error.message,
        );
      }
      return RegisterResult(RegisterStatus.failure, message: error.message);
    } catch (error) {
      return RegisterResult(
        RegisterStatus.failure,
        message: error.toString(),
      );
    }
  }

  Future<LoginResultData> login(String email, String password) async {
    if (!isReady) {
      return const LoginResultData(
        LoginStatus.failure,
        message: 'Supabase is not initialized.',
      );
    }

    try {
      await _client.auth.signInWithPassword(
        email: _normalizedEmail(email),
        password: password,
      );
      return const LoginResultData(LoginStatus.success);
    } on AuthException catch (error) {
      final message = error.message.toLowerCase();
      if (message.contains('invalid login credentials') ||
          message.contains('email not confirmed')) {
        return LoginResultData(
          LoginStatus.invalidCredentials,
          message: error.message,
        );
      }
      return LoginResultData(LoginStatus.failure, message: error.message);
    } catch (error) {
      return LoginResultData(LoginStatus.failure, message: error.toString());
    }
  }

  Future<Map<String, dynamic>?> getCurrentAccount() async {
    if (!isReady) {
      return null;
    }

    final user = _client.auth.currentUser;
    if (user == null) {
      return null;
    }

    try {
      final profile = await _client
          .from(SupabaseEnvironment.profileTable)
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (profile != null) {
        return Map<String, dynamic>.from(profile);
      }

      final metadata = user.userMetadata ?? const <String, dynamic>{};
      final fallback = <String, dynamic>{
        'user_id': user.id,
        'email': metadata['email'] ?? user.email ?? '',
        'name': metadata['name'] ?? '',
        'age': metadata['age']?.toString() ?? '',
        'gender': metadata['gender'] ?? '',
      };

      await _client.from(SupabaseEnvironment.profileTable).upsert(fallback);
      return fallback;
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getBodyRecords() async {
    if (!isReady || _client.auth.currentUser == null) {
      return const <Map<String, dynamic>>[];
    }

    try {
      final response = await _client
          .from(SupabaseEnvironment.bodyRecordsTable)
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (_) {
      return const <Map<String, dynamic>>[];
    }
  }

  Future<Map<String, dynamic>?> createBodyRecord({
    required double heightCm,
    required double weightKg,
    required String age,
    required String gender,
    XFile? photo,
  }) async {
    if (!isReady) {
      return null;
    }

    final user = _client.auth.currentUser;
    if (user == null) {
      return null;
    }

    String? photoPath;
    String? photoUrl;

    try {
      if (photo != null) {
        final Uint8List bytes = await photo.readAsBytes();
        final safeName = _safeFilename(photo.name);
        final path =
            '${user.id}/${DateTime.now().millisecondsSinceEpoch}_$safeName';

        await _client.storage.from(SupabaseEnvironment.photosBucket).uploadBinary(
              path,
              bytes,
              fileOptions: FileOptions(
                contentType: _contentTypeForFile(photo),
                upsert: false,
              ),
            );

        photoPath = path;
        photoUrl = _client.storage
            .from(SupabaseEnvironment.photosBucket)
            .getPublicUrl(path);
      }

      final inserted = await _client
          .from(SupabaseEnvironment.bodyRecordsTable)
          .insert(<String, dynamic>{
            'user_id': user.id,
            'height_cm': heightCm,
            'weight_kg': weightKg,
            'age': age.trim(),
            'gender': gender,
            'photo_path': photoPath,
            'photo_url': photoUrl,
          })
          .select()
          .single();

      return Map<String, dynamic>.from(inserted);
    } catch (_) {
      if (photoPath != null) {
        try {
          await _client.storage
              .from(SupabaseEnvironment.photosBucket)
              .remove(<String>[photoPath]);
        } catch (_) {}
      }
      return null;
    }
  }

  Future<bool> deleteBodyRecord(int id) async {
    if (!isReady || _client.auth.currentUser == null) {
      return false;
    }

    try {
      final record = await _client
          .from(SupabaseEnvironment.bodyRecordsTable)
          .select('photo_path')
          .eq('id', id)
          .maybeSingle();

      await _client
          .from(SupabaseEnvironment.bodyRecordsTable)
          .delete()
          .eq('id', id);

      final photoPath = record?['photo_path'] as String?;
      if (photoPath != null && photoPath.isNotEmpty) {
        await _client.storage
            .from(SupabaseEnvironment.photosBucket)
            .remove(<String>[photoPath]);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    if (!isReady) {
      return;
    }
    await _client.auth.signOut();
  }
}

final apiService = ApiService();
