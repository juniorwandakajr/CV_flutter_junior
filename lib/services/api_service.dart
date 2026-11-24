import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/membre.dart';

class ApiService {
  // Sur Chrome Web (ton cas) : localhost marche.
  // Si tu testes sur émulateur Android : remplace par http://10.0.2.2/api-test/public
  static const String baseUrl = 'http://localhost/api-test/public';

  Map<String, String> get _jsonHeaders =>
      {'Content-Type': 'application/json'};

  void _check(Map<String, dynamic> body) {
    if (body['success'] == false) {
      final errors = body['errors'];
      if (errors is Map && errors.isNotEmpty) {
        throw Exception(errors.values.first.toString());
      }
      throw Exception(body['message'] ?? 'Erreur API');
    }
  }

  Future<List<Membre>> getMembres() async {
    final res = await http.get(Uri.parse('$baseUrl/famille-membres'));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    _check(body);
    final data = body['data'] as List;
    return data.map((e) => Membre.fromJson(e)).toList();
  }

  Future<Membre> createMembre(Membre membre, {File? image}) async {
    if (image == null) {
      // Sans image : JSON simple
      final res = await http.post(
        Uri.parse('$baseUrl/famille-membres'),
        headers: _jsonHeaders,
        body: jsonEncode(membre.toJson()),
      );
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      _check(body);
      return Membre.fromJson(body['data']);
    }
    // Avec image : multipart / form-data
    final req = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/famille-membres'));
    membre.toJson().forEach((k, v) => req.fields[k] = v);
    req.files.add(await http.MultipartFile.fromPath('image', image.path));
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    _check(body);
    return Membre.fromJson(body['data']);
  }

  Future<Membre> updateMembre(Membre membre) async {
    // Sans changer l'image : PUT JSON, image conservée
    final res = await http.put(
      Uri.parse('$baseUrl/famille-membres/${membre.id}'),
      headers: _jsonHeaders,
      body: jsonEncode(membre.toJson()),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    _check(body);
    return Membre.fromJson(body['data']);
  }

  Future<Membre> updateMembreWithImage(Membre membre, File image) async {
    // Avec nouvelle image : POST form-data sur /{id}
    // PHP ne lit pas les fichiers en PUT, d'où ce POST
    final req = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/famille-membres/${membre.id}'));
    membre.toJson().forEach((k, v) => req.fields[k] = v);
    req.files.add(await http.MultipartFile.fromPath('image', image.path));
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    _check(body);
    return Membre.fromJson(body['data']);
  }

  Future<void> deleteMembre(int id) async {
    final res =
        await http.delete(Uri.parse('$baseUrl/famille-membres/$id'));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    _check(body);
  }
}
