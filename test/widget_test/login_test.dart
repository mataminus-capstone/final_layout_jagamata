import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jagamata/pages/loginpage.dart';

void main() {
  group('LoginPage Widget Tests', () {
    
    testWidgets('Menampilkan error ketika form kosong dan tombol MASUK ditekan', 
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: LoginPage()));

        // Klik tombol MASUK
        await tester.tap(find.text('MASUK'));
        await tester.pump();

        expect(find.text('Isi email dan password terlebih dahulu!'), findsOneWidget);
        print('TEST PASSED: SnackBar muncul untuk form kosong');
    });

    testWidgets('User dapat mengisi email dan password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      await tester.enterText(find.byType(TextField).at(0), 'test@email.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');

      expect(find.text('test@email.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
      print('TEST PASSED: Input email dan password muncul');
    });

    testWidgets('Navigasi ke halaman register saat teks Daftar ditekan', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {'/register': (_) => const Scaffold(body: Text('Register Page'))},
          home: const LoginPage(),
        ),
      );

      final daftarFinder = find.text('Daftar');

      await tester.ensureVisible(daftarFinder);
      await tester.tap(daftarFinder);
      await tester.pumpAndSettle();

      expect(find.text('Register Page'), findsOneWidget);
      print('TEST PASSED: Navigasi ke register berhasil');
    });

    testWidgets('Tombol Masuk dengan Google dapat ditekan', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final googleButton = find.text('Masuk dengan Google');

      await tester.ensureVisible(googleButton);
      await tester.tap(googleButton);
      await tester.pump();

      expect(googleButton, findsOneWidget);
      print('TEST PASSED: Tombol Google login dapat ditekan');
    });

    testWidgets('Halaman login menampilkan teks selamat datang', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      expect(find.text('Selamat Datang!'), findsOneWidget);
      expect(find.text('Silakan masuk untuk melanjutkan'), findsOneWidget);
      print('TEST PASSED: Halaman login tampil lengkap');
    });

  });
}
