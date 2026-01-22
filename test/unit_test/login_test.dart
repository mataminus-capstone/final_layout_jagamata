import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jagamata/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
   TestWidgetsFlutterBinding.ensureInitialized();//Menginisialisasi environment Flutter khusus untuk testing

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  group('Login API - Unit Test', () {

    test('Berhasil - login sukses', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'message': 'Login berhasil!',
            'data': {
              'token': 'dummy_token',
              'email': 'test@gmail.com',
              'username': 'testuser',
            }
          }),
          200,
        );
      });

      final result = await ApiService.login(
        email: 'test@gmail.com',
        password: '123456',
        client: mockClient,
      );

      expect(result['success'], true);
      expect(result['data']['token'], isNotNull);
      print('Login Berhasil: ${result['data']['username']}');
    });

    test('Gagal - email atau password salah', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'message': 'Email atau password salah!'
          }),
          401,
        );
      });

      final result = await ApiService.login(
        email: 'test@gmail.com',
        password: 'salah',
        client: mockClient,
      );

      expect(result['success'], false);
      expect(result['message'], 'Email atau password salah!');
      print('Login Gagal: ${result['message']}');
    });

    test('Gagal - email belum diverifikasi', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'message': 'Email belum diverifikasi.'
          }),
          403,
        );
      });

      final result = await ApiService.login(
        email: 'test@gmail.com',
        password: '123456',
        client: mockClient,
      );

      expect(result['success'], false);
      expect(result['message'], 'Email belum diverifikasi.');
      print('Login Gagal: ${result['message']}');
    });
    
  });
}
