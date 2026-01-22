import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jagamata/services/api_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Get Current User - Unit Test', () {

    test('Berhasil - data user diambil', () async {
      ApiService.token = 'dummy_token';

      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'data': {
              'user_id': 1,
              'username': 'testuser',
              'email': 'test@gmail.com',
              'role': 'user'
            }
          }),
          200,
        );
      });

      final result = await ApiService.getCurrentUser(
        client: mockClient,
      );

      expect(result['success'], true);
      expect(result['data']['email'], 'test@gmail.com');
      print("TEST PASSED: $result");
    });

    test('Gagal - token tidak valid / tidak ada', () async {
      ApiService.token = null;

      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'message': 'Token tidak valid'
          }),
          401,
        );
      });

      final result = await ApiService.getCurrentUser(
        client: mockClient,
      );

      expect(result['success'], false);
      print("TEST PASSED: $result");
    });

  });
}
