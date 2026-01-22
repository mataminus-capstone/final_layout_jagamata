import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jagamata/services/api_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Get Clinics - Unit Test', () {
    test('Berhasil - daftar clinic diambil', () async {
      ApiService.token = 'dummy_token';

      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'data': [
              {
                'id': 1,
                'name': 'Klinik Sehat',
                'address': 'Jakarta',
                'phone_number': '08123456789',
                'image_url': 'image.png',
                'created_at': '2024-01-01T10:00:00'
              }
            ]
          }),
          200,
        );
      });

      final result = await ApiService.getClinics(client: mockClient);

      expect(result['success'], true);
      expect(result['data'].length, 1);
      expect(result['data'][0]['name'], 'Klinik Sehat');

      print('TEST PASSED: $result');
    });
    test('Gagal - unauthorized (token tidak ada)', () async {
      ApiService.token = null;

      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Unauthorized'}),
          401,
        );
      });

      final result = await ApiService.getClinics(client: mockClient);

      expect(result['success'], false);
      expect(result['message'], 'Unauthorized');

      print('TEST PASSED: $result');
    });
  });
}
