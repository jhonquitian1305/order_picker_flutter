import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:order_picker/domain/entities/user.dart';
import 'package:order_picker/infrastructure/constants/url_string.dart';

class AuthProvider {
  const AuthProvider({required this.status, required this.loggedUser});

  final User? loggedUser;
  final AuthStatus status;

  AuthProvider copyWith({AuthStatus? status, User? loggedUser}) {
    return AuthProvider(
        status: status ?? AuthStatus.unauthenticated, loggedUser: loggedUser);
  }
}

class AuthNotifier extends StateNotifier<AuthProvider> {
  AuthNotifier()
      : super(const AuthProvider(
            status: AuthStatus.unauthenticated, loggedUser: null));

  void logout() {
    state =
        state.copyWith(status: AuthStatus.unauthenticated, loggedUser: null);
  }

  Future<bool> login(String email, String password) async {
    try {
      Response response = await post(Uri.parse('$url/auth/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'email': email, 'password': password}));
      if (response.statusCode == 200) {
        var token = jsonDecode(response.body.toString())['token'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        state = state.copyWith(
            status: AuthStatus.authenticated,
            loggedUser: User(
                id: decodedToken["id"],
                name: decodedToken["sub"],
                role: Role.values
                    .firstWhere((role) => role.value == decodedToken["role"]),
                jwt: token));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthProvider>((ref) => AuthNotifier());

enum AuthStatus { authenticated, unauthenticated }
