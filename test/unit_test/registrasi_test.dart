import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jagamata/services/api_service.dart';

void main() {
  group('Register API - Unit Test', () {

    test('Gagal - email sudah terdaftar', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Email sudah terdaftar!'}),
          400,
        );
      });

      final result = await ApiService.register(
        email: 'test@gmail.com',
        username: 'test',
        password: '123456',
        client: mockClient,
      );

      expect(result['success'], false);
      expect(result['message'], 'Email sudah terdaftar!');
      print('TEST PASSED: $result');
      print("======================================================================");
    });
    
    test('Gagal - password kurang dari 6 karakter', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Password minimal 6 karakter!'}),
          400,
        );
      });

      final result = await ApiService.register(
        email: 'test@gmail.com',
        username: 'test',
        password: '123',
        client: mockClient,
      );

      expect(result['success'], false);
      expect(result['message'], 'Password minimal 6 karakter!');
      print('TEST PASSED: $result');
      print("======================================================================");
    });
    
    test('Gagal - data kosong', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Username, email, dan password harus diisi!'}),
          400,
        );
      });

      final result = await ApiService.register(
        email: '',
        username: '',
        password: '',
        client: mockClient,
      );

      expect(result['success'], false);
      expect(result['message'], 'Username, email, dan password harus diisi!');
      print('TEST PASSED: $result');
      print("======================================================================");
    });
    
    test('Gagal - server error', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Terjadi kesalahan saat registrasi.'}),
          500,
        );
      });

      final result = await ApiService.register(
        email: 'test@gmail.com',
        username: 'test',
        password: '123456',
        client: mockClient,
      );

      expect(result['success'], false);
      expect(result['message'], 'Terjadi kesalahan saat registrasi.');
      print('TEST PASSED: $result');
      print("======================================================================");
    });
    
    test('Berhasil - registrasi sukses', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'message': 'Registrasi berhasil!'}),
          201,
        );
      });

      final result = await ApiService.register(
        email: 'new@gmail.com',
        username: 'newuser',
        password: '123456',
        client: mockClient,
      );

      expect(result['success'], true);
      expect(result['message'], 'Registrasi berhasil!');
      print('TEST PASSED: $result');
      print("======================================================================");
    });

  });
}



// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences.setMockInitialValues({}); // Tetap butuh ini buat simpan token

//   group('Login Unit Test (Pakai Mock)', () {
    
//     test('Login Sukses (Simulasi Server Balas 200 OK)', () async {
      
//       // --- BAGIAN 1: BIKIN SKENARIO (MOCKING) ---
//       final mockClient = MockClient((request) async {
//         // Cek: Apakah ApiService nembak ke URL yang benar?
//         if (request.method == 'POST' && request.url.toString().contains('/auth/login')) {
          
//           print('MOCK: Menerima tembakan ke Login, membalas dengan SUKSES...');
          
//         // Kita manual bikin respon JSON palsu (TIRUAN)
//           return http.Response(jsonEncode({
//             "success": true, // Respon API Jagamata kalau sukses
//             "message": "Login berhasil (Ini Palsu)",
//             "data": {
//               "token": "token_rahasia_palsu_12345",
//               "user_id": 99,
//               "username": "tester_ganteng"
//             }
//           }), 200); // Kode 200 artinya OK
//         }

//       //   // Kalau URL salah, balas 404
//         return http.Response("Not Found", 404);
//       });

//       // --- BAGIAN 2: EKSEKUSI (TESTING) ---
//       // Panggil fungsi asli, TAPI masukkan 'mockClient' kita tadi
//       final result = await ApiService.login(
//         email: 'rhiki6009.com', 
//         password: 'password_rahasia',
//         client: mockClient, // INI CARA PAKAINYA (Dependency Injection)
//       );

//       // --- BAGIAN 3: VERIFIKASI (ASSERT) ---
//       print('HASIL TEST: $result');
//       // Pastikan logika ApiService lu berhasil membaca JSON palsu tadi
//       expect(result['success'], true);
//       expect(result['data']['token'], 'token_rahasia_palsu_12345');
      
//       // Buktikan bahwa token tersimpan di memori (variable static)
//       expect(ApiService.token, 'token_rahasia_palsu_12345');
//     });

//   });


// }