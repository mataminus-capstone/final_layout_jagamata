import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  static const String prodBaseUrl = 'https://jagamata.web.id';
  static const String devBaseUrl = 'http://localhost:5000';

  // development / production
  static const String baseUrl = prodBaseUrl;

  static const Duration timeout = Duration(seconds: 30);

  static String? token;
  static Map<String, dynamic>? userData;

  static void setToken(String newToken) {
    token = newToken;
    _saveTokenToPrefs(newToken);
  }

  static void clearToken() {
    token = null;
    userData = null;
    _deleteTokenFromPrefs();
  }

  static Future<void> _saveTokenToPrefs(String newToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', newToken);
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  static Future<void> _deleteTokenFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
    } catch (e) {
      print('Error deleting token: $e');
    }
  }

  static Map<String, String> _getHeaders({bool authenticated = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authenticated && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    http.Client? client,
  }) async {
    try {
      final httpClient = client ?? http.Client();
      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/api/auth/register'),
            headers: _getHeaders(),
            body: jsonEncode({
              'email': email,
              'username': username,
              'password': password,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi berhasil',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // Unit testing
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    http.Client? client,
  }) async {
    try {
      final httpClient = client ?? http.Client();
      final response = await httpClient
          .post(
            Uri.parse('$baseUrl/api/auth/login'),
            headers: _getHeaders(),
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['data']?['token'];
        if (token != null) {
          setToken(token);
          userData = data['data'];
        }
        return {
          'success': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> loginWithGoogle({
    required String code,
    String? idToken,
  }) async {
    try {
      print(
        '[DEBUG] Sending Google OAuth data to backend: code=${code.isNotEmpty}, idToken=${idToken != null}',
      );

      final body = {'code': code, if (idToken != null) 'id_token': idToken};

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/auth/oauth/mobile/callback'),
            headers: _getHeaders(),
            body: jsonEncode(body),
          )
          .timeout(timeout);

      print('[DEBUG] OAuth response status: ${response.statusCode}');
      print('[DEBUG] OAuth response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['data']?['token'];
        if (token != null) {
          setToken(token);
          userData = data['data'];
        }
        return {
          'success': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Login Google gagal',
        };
      }
    } catch (e) {
      print('[DEBUG] OAuth error: $e');
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getArticles({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final url = '$baseUrl/api/articles?page=$page&per_page=$perPage';
      print('[DEBUG] Fetching articles from: $url');

      final response = await http
          .get(Uri.parse(url), headers: _getHeaders())
          .timeout(
            timeout,
            onTimeout: () {
              print(
                '[DEBUG] Articles request timeout after ${timeout.inSeconds}s',
              );
              throw TimeoutException('Request timeout', timeout);
            },
          );

      print('[DEBUG] Articles response status: ${response.statusCode}');
      print('[DEBUG] Articles response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[DEBUG] Decoded response: $data');

        final success = data['success'] ?? false;
        print('[DEBUG] Response success: $success');

        if (!success) {
          return {
            'success': false,
            'data': [],
            'message': data['message'] ?? 'Gagal mengambil artikel',
          };
        }

        final dataSection = data['data'] as Map<String, dynamic>? ?? {};
        final articlesData = dataSection['articles'] as List? ?? [];

        print('[DEBUG] Articles data length: ${articlesData.length}');

        final articles = List<Map<String, dynamic>>.from(
          articlesData.map(
            (article) => {
              'id': article['id'],
              'title': article['title'] ?? 'No Title',
              'content': article['content'] ?? 'No Content',
              'image_url': article['image_url'],
              'author': article['author'] ?? {'id': 0, 'username': 'Unknown'},
              'created_at': article['created_at'] ?? '',
              'updated_at': article['updated_at'] ?? '',
            },
          ),
        );

        print('[DEBUG] Parsed ${articles.length} articles');

        return {
          'success': true,
          'data': articles,
          'pagination': dataSection['pagination'] ?? {},
        };
      }

      print(
        '[DEBUG] Articles fetch failed with status: ${response.statusCode}',
      );
      print('[DEBUG] Response body: ${response.body}');

      return {
        'success': false,
        'data': [],
        'message': 'Gagal mengambil artikel (status: ${response.statusCode})',
      };
    } catch (e) {
      print('[DEBUG] Articles error: $e');
      String errorMsg = 'Error: ${e.toString()}';
      if (e is TimeoutException) {
        errorMsg = 'Koneksi timeout - pastikan server sedang berjalan';
      } else if (e.toString().contains('Connection refused')) {
        errorMsg =
            'Tidak bisa terhubung ke server - periksa URL dan koneksi internet';
      } else if (e.toString().contains('Connection reset')) {
        errorMsg = 'Koneksi diputus oleh server';
      }
      return {'success': false, 'data': [], 'message': errorMsg};
    }
  }

  static Future<Map<String, dynamic>> getArticleDetail(int articleId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/articles/$articleId'),
        headers: _getHeaders(authenticated: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': 'Artikel tidak ditemukan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> sendChatMessage(String message) async {
    try {
      print('[DEBUG] Sending message to chatbot: $message');
      print('[DEBUG] Using base URL: $baseUrl');

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/chatbot'),
            headers: _getHeaders(),
            body: jsonEncode({'message': message}),
          )
          .timeout(
            timeout,
            onTimeout: () {
              print(
                '[DEBUG] Chatbot request timeout after ${timeout.inSeconds}s',
              );
              throw TimeoutException('Request timeout', timeout);
            },
          );

      print('[DEBUG] Chatbot response status: ${response.statusCode}');
      print('[DEBUG] Chatbot response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[DEBUG] Decoded chatbot response: $data');

        final success = data['success'] ?? false;
        if (!success) {
          return {
            'success': false,
            'response': data['message'] ?? 'Chatbot sedang tidak aktif',
          };
        }

        final dataSection = data['data'] as Map<String, dynamic>? ?? {};
        final response_text =
            dataSection['response'] ?? 'Maaf, tidak ada respons';
        final doctor = dataSection['doctor'] ?? 'ChatBot AI';
        final confidence = (dataSection['confidence'] ?? 0).toDouble();

        print('[DEBUG] Chatbot response received: $response_text from $doctor');

        return {
          'success': true,
          'response': response_text,
          'doctor': doctor,
          'confidence': confidence,
        };
      } else {
        final data = jsonDecode(response.body);
        print('[DEBUG] Chatbot error response: $data');

        return {
          'success': false,
          'response': data['message'] ?? 'Chatbot sedang tidak aktif',
        };
      }
    } catch (e) {
      print('[DEBUG] Chatbot error: $e');
      String errorMsg = 'Error: ${e.toString()}';
      if (e is TimeoutException) {
        errorMsg = 'Koneksi timeout - pastikan server sedang berjalan';
      } else if (e.toString().contains('Connection refused')) {
        errorMsg =
            'Tidak bisa terhubung ke server - periksa URL dan koneksi internet';
      } else if (e.toString().contains('Connection reset')) {
        errorMsg = 'Koneksi diputus oleh server';
      }
      return {'success': false, 'response': errorMsg};
    }
  }

  static Future<Map<String, dynamic>> submitFeedback(String content) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/feedback/'),
            headers: _getHeaders(authenticated: true),
            body: jsonEncode({'content': content}),
          )
          .timeout(timeout);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengirim feedback',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // unit testing
  static Future<Map<String, dynamic>> getCurrentUser({
    http.Client? client,
  }) async {
    try {
      final httpClient = client ?? http.Client();

      final response = await httpClient.get(
        Uri.parse('$baseUrl/api/auth/me'),
        headers: _getHeaders(authenticated: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userData = data['data'];
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': 'Failed to get user'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? username,
    String? address,
    String? phoneNumber,
    XFile? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/api/auth/me'),
      );

      request.headers.addAll(_getHeaders(authenticated: true));
      // Remove Content-Type, let MultipartRequest handle it
      request.headers.remove('Content-Type');

      if (username != null) request.fields['username'] = username;
      if (address != null) request.fields['address'] = address;
      if (phoneNumber != null) request.fields['phone_number'] = phoneNumber;

      if (imageFile != null) {
        if (kIsWeb) {
          final bytes = await imageFile.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              'profile_picture',
              bytes,
              filename: imageFile.name,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              'profile_picture',
              imageFile.path,
            ),
          );
        }
      }

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (userData != null) {
          // Update local cache
          if (username != null) userData!['username'] = username;
          if (address != null) userData!['address'] = address;
          if (phoneNumber != null) userData!['phone_number'] = phoneNumber;
          if (data['data']['profile_picture'] != null) {
            userData!['profile_picture'] = data['data']['profile_picture'];
          }
        }
        return {'success': true, 'data': data['data']};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Update failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getClinics({http.Client? client}) async {
    try {
      final httpClient = client ?? http.Client();

      final response = await httpClient.get(
            Uri.parse('$baseUrl/api/clinics'),
            headers: _getHeaders(authenticated: true),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data']};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load clinics',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> detectDisease(XFile imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/detection/predict'),
      );

      request.headers.addAll(_getHeaders(authenticated: true));

      // Remove Content-Type from headers as MultipartRequest sets it automatically
      request.headers.remove('Content-Type');

      if (kIsWeb) {
        // On web, read bytes
        final bytes = await imageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: imageFile.name,
          ),
        );
      } else {
        // On mobile, we can also use bytes to be safe, or fromPath
        // Using fromPath is better for large files on mobile to avoid loading all into memory,
        // but fromBytes is safer for cross-platform.
        // Let's use fromBytes for consistency if file is not huge,
        // OR check kIsWeb.

        // safely use fromFilePath on mobile
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      print('[DEBUG] Detect response status: ${response.statusCode}');
      print('[DEBUG] Detect response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data']};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Deteksi gagal',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getDetectionHistory({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/api/detection/history?page=$page&per_page=$perPage',
            ),
            headers: _getHeaders(authenticated: true),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data']};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal memuat riwayat',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getMedicines({
    String? category,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      String url = '$baseUrl/api/medicines?page=$page&per_page=$perPage';
      if (category != null && category.isNotEmpty) {
        url += '&category=${Uri.encodeComponent(category)}';
      }

      final response = await http
          .get(Uri.parse(url), headers: _getHeaders(authenticated: true))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data']};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal memuat obat',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/categories'),
            headers: _getHeaders(authenticated: true),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': 'Gagal memuat kategori'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static void logout() {
    clearToken();
  }
}

class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  TimeoutException(this.message, this.timeout);

  @override
  String toString() => '$message (${timeout.inSeconds}s)';
}
