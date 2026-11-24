import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/account.dart';

class AuthService {
  static const String baseUrl = 'http://localhost/api-test/public';
  static const _key = 'current_account';

  Future<Account> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/accounts/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['success'] == false) {
      throw Exception(body['message'] ?? 'Email ou mot de passe incorrect');
    }
    final account = Account.fromJson(body['data']);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(account.toJson()));
    return account;
  }

  Future<Account> register(String email, String password,
      {String? passwordConfirmation}) async {
    final res = await http.post(
      Uri.parse('$baseUrl/accounts/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['success'] == false) {
      final errors = body['errors'];
      if (errors is Map && errors.isNotEmpty) {
        throw Exception(errors.values.first.toString());
      }
      throw Exception(body['message'] ?? 'Erreur inscription');
    }
    return Account.fromJson(body['data']);
  }

  Future<Account?> currentAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key);
    if (str == null) return null;
    return Account.fromJson(jsonDecode(str));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
