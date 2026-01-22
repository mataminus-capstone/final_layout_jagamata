import 'package:flutter_test/flutter_test.dart';
import 'package:jagamata/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  group('Logout / Clear Token - Unit Test', () {
    test('Logout berhasil menghapus token dan userData', () {
      // Arrange (set kondisi awal)
      ApiService.token = 'dummy_token';
      ApiService.userData = {'email': 'test@gmail.com', 'username': 'testuser'};

      // Act (aksi logout)
      ApiService.logout();

      // Assert (hasil yang diharapkan)
      expect(ApiService.token, null);
      expect(ApiService.userData, null);
      print('TEST PASSED: Logout berhasil menghapus token [${ApiService.token}] dan userData [${ApiService.userData}]');
    });
  });
}
