import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://d1zkw2jd-5000.asse.devtunnels.ms'; 
  static Map<String, dynamic>? userData;

  static Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );

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

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userData = data['user'];
        return {'success': true, 'message': data['message'], 'data': userData};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getArticles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/articles'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = List<Map<String, dynamic>>.from(
          (data['articles'] as List).map(
            (article) => {
              'id': article['id'],
              'title': article['title'],
              'content': article['content'],
              'author': article['author'],
              'created_at': article['created_at'],
            },
          ),
        );

        return {'success': true, 'data': articles};
      }
      return {'success': false, 'data': []};
    } catch (e) {
      return {
        'success': false,
        'data': [],
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> getArticleDetail(int articleId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/articles/$articleId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['article']};
      }
      return {'success': false, 'message': 'Artikel tidak ditemukan'};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> sendChatMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chatbot'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'response': data['response'],
          'doctor': data['doctor'] ?? 'ChatBot AI',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'response': data['response'] ?? 'Chatbot sedang tidak aktif',
        };
      }
    } catch (e) {
      return {'success': false, 'response': 'Error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> loginWithGoogle({
    required String email,
    required String name,
    required String googleId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': name,
          'oauth_provider': 'google',
          'oauth_id': googleId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userData = data['user'];
        return {'success': true, 'data': userData};
      } else {
        return {'success': false, 'message': 'Login Google gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static void logout() {
    userData = null;
  }
}
