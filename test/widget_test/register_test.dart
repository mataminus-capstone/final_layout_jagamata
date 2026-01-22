import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jagamata/pages/registerpage.dart';

void main() {
  group('Register Page - Widget Test', () {
    testWidgets('Menampilkan error ketika form kosong dan tombol DAFTAR ditekan',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

        await tester.tap(find.text('DAFTAR'));
        await tester.pump();

        expect(find.text('Email tidak boleh kosong'), findsOneWidget);
        expect(find.text('Username tidak boleh kosong'), findsOneWidget);
        expect(find.text('Password tidak boleh kosong'), findsOneWidget);

        print('TEST PASSED: Validasi form kosong berjalan dengan baik');
      },
    );

    // ===========================

    testWidgets('User dapat mengisi email, username, dan password', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'username_test');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');

      expect(find.text('test@email.com'), findsOneWidget);
      expect(find.text('username_test'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);

      print('TEST PASSED: User berhasil mengisi seluruh field input');
    });

    // ===========================

    testWidgets('Navigasi ke halaman login saat teks Login ditekan', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {'/login': (_) => const Scaffold(body: Text('Login Page'))},
          home: const RegisterPage(),
        ),
      );

      final loginFinder = find.byKey(const Key('already_have_account'));

      await tester.ensureVisible(loginFinder);
      await tester.tap(loginFinder);
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);

      print('TEST PASSED: Navigasi ke halaman Login berhasil');
    });

    // ===========================

    testWidgets('Tombol Daftar dengan Google dapat ditekan', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));

      final googleButton = find.text('Daftar dengan Google');

      await tester.ensureVisible(googleButton);
      await tester.tap(googleButton);
      await tester.pump();

      expect(googleButton, findsOneWidget);

      print('TEST PASSED: Tombol Daftar dengan Google dapat ditekan');
    });
  });
}
