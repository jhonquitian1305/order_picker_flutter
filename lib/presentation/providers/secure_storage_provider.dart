import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/riverpod.dart';

final storageProvider = StateProvider((ref) {
  return const FlutterSecureStorage();
});
