import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final profileImageProvider = NotifierProvider<ProfileImageNotifier, String?>(() {
  return ProfileImageNotifier();
});

class ProfileImageNotifier extends Notifier<String?> {
  static const _storageKey = 'profile_image_path';

  @override
  String? build() {
    _loadProfileImage();
    return null;
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_storageKey);
  }

  Future<void> updateProfileImage(String path) async {
    state = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, path);
  }
}
