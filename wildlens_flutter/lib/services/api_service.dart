import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // IMPORTANT: Set the correct backend URL for your environment.
  // For Android emulator: 'http://10.0.2.2:8000'
  // For iOS simulator:   'http://127.0.0.1:8000'
  // For real device:     'http://<YOUR_COMPUTER_LAN_IP>:8000'
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<Map<String, String>> _getHeaders({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await _getToken();
      print('[ApiService] Using JWT token: ' + (token ?? 'NULL'));
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<dynamic> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      final decoded = json.decode(response.body);
      return decoded;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  // --- AUTH ---
  Future<void> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _getHeaders(),
      body: json.encode(data),
    );
    await _handleResponse(response);
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'username=$email&password=$password',
    );
    final data = await _handleResponse(response);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', data['access_token']);
  }

  // --- USER PROFILE ---
  Future<dynamic> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: await _getHeaders(auth: true),
    );
    return _handleResponse(response);
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/me'),
      headers: await _getHeaders(auth: true),
      body: json.encode(data),
    );
    await _handleResponse(response);
  }

  // --- ANIMALS ---
  Future<List<dynamic>> getAnimals() async {
    final response = await http.get(
      Uri.parse('$baseUrl/animals/'),
      headers: await _getHeaders(),
    );
    return List<dynamic>.from(await _handleResponse(response));
  }

  Future<dynamic> getAnimal(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/animals/$id'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<void> createAnimal(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/animals/'),
      headers: await _getHeaders(auth: true),
      body: json.encode(data),
    );
    await _handleResponse(response);
  }

  Future<void> updateAnimal(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/animals/$id'),
      headers: await _getHeaders(auth: true),
      body: json.encode(data),
    );
    await _handleResponse(response);
  }

  Future<void> deleteAnimal(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/animals/$id'),
      headers: await _getHeaders(auth: true),
    );
    await _handleResponse(response);
  }

  // --- ECOSYSTEMS ---
  Future<List<dynamic>> getEcosystems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ecosystems/'),
      headers: await _getHeaders(),
    );
    return List<dynamic>.from(await _handleResponse(response));
  }

  Future<dynamic> getEcosystem(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ecosystems/$id'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<void> createEcosystem(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ecosystems/'),
      headers: await _getHeaders(auth: true),
      body: json.encode(data),
    );
    await _handleResponse(response);
  }

  Future<void> updateEcosystem(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/ecosystems/$id'),
      headers: await _getHeaders(auth: true),
      body: json.encode(data),
    );
    await _handleResponse(response);
  }

  Future<void> deleteEcosystem(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/ecosystems/$id'),
      headers: await _getHeaders(auth: true),
    );
    await _handleResponse(response);
  }

  // --- SCANS ---
  Future<List<dynamic>> getScans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/scans/'),
      headers: await _getHeaders(auth: true),
    );
    return List<dynamic>.from(await _handleResponse(response));
  }

  Future<dynamic> getScan(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/scans/$id'),
      headers: await _getHeaders(auth: true),
    );
    return _handleResponse(response);
  }

  Future<void> createScan(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scans/'),
      headers: await _getHeaders(auth: true),
      body: json.encode(data),
    );
    await _handleResponse(response);
  }

  Future<void> deleteScan(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/scans/$id'),
      headers: await _getHeaders(auth: true),
    );
    await _handleResponse(response);
  }

  // --- FAVORITES ---
  Future<List<dynamic>> getFavorites() async {
    final response = await http.get(
      Uri.parse('$baseUrl/favorites/'),
      headers: await _getHeaders(auth: true),
    );
    return List<dynamic>.from(await _handleResponse(response));
  }

  Future<void> addFavorite(int animalId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favorites/'),
      headers: await _getHeaders(auth: true),
      body: json.encode({'animal_id': animalId}),
    );
    await _handleResponse(response);
  }

  Future<void> removeFavorite(int animalId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/favorites/$animalId'),
      headers: await _getHeaders(auth: true),
    );
    await _handleResponse(response);
  }

  // --- BADGES ---
  Future<List<dynamic>> getBadges() async {
    final response = await http.get(
      Uri.parse('$baseUrl/badges/'),
      headers: await _getHeaders(auth: true),
    );
    return List<dynamic>.from(await _handleResponse(response));
  }

  Future<void> addBadge(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/badges/'),
      headers: await _getHeaders(auth: true),
      body: json.encode(data),
    );
    await _handleResponse(response);
  }

  Future<void> removeBadge(int badgeId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/badges/$badgeId'),
      headers: await _getHeaders(auth: true),
    );
    await _handleResponse(response);
  }

  // --- ACTIVITY HISTORY ---
  Future<List<dynamic>> getActivityHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/history/'),
      headers: await _getHeaders(auth: true),
    );
    return List<dynamic>.from(await _handleResponse(response));
  }

  Future<void> addHistory(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/history/'),
      headers: await _getHeaders(auth: true),
      body: json.encode(data),
    );
    await _handleResponse(response);
  }

  Future<void> removeHistory(int activityId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/history/$activityId'),
      headers: await _getHeaders(auth: true),
    );
    await _handleResponse(response);
  }

  // --- FOOTPRINT ANALYSIS ---
  Future<dynamic> analyzeFootprint(String filePath) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/analyze/footprint'));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  Future<Map<String, dynamic>> uploadAvatar(File file) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl/users/me/avatar');
    final request = http.MultipartRequest('PUT', uri);
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    // Determine content type from file extension
    String ext = file.path.split('.').last.toLowerCase();
    MediaType mediaType;
    if (ext == 'jpg' || ext == 'jpeg') {
      mediaType = MediaType('image', 'jpeg');
    } else if (ext == 'png') {
      mediaType = MediaType('image', 'png');
    } else if (ext == 'gif') {
      mediaType = MediaType('image', 'gif');
    } else {
      mediaType = MediaType('application', 'octet-stream');
    }
    request.files.add(await http.MultipartFile.fromPath('file', file.path, contentType: mediaType));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors du téléchargement de l\'avatar: ${response.statusCode}');
    }
  }
}
