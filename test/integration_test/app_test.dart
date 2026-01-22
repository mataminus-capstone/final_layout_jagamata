
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jagamata/config/app_env.dart';
import 'package:jagamata/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  isIntegrationTest = true;

  testWidgets('E2E TEST: User Login Flow -> Berhasil Masuk Home', (
    WidgetTester tester,
  ) async {
    //  Mocking 
    SharedPreferences.setMockInitialValues({});

    app.main();
    await tester.pumpAndSettle(); // Tunggu render awal selesai

    // Definisi Finder (Biar kodingan lebih rapi dibaca)
    final emailField = find.byKey(const Key('login_email'));
    final passwordField = find.byKey(const Key('login_password'));
    final loginButton = find.byKey(const Key('login_button'));

    await tester.enterText(emailField, 'rhikisulistiyo@gmail.com');
    await tester.enterText(passwordField, 'rhiki123');

    // Tutup Keyboard (PENTING: Biar tombol tidak tertutup)
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    // Klik Tombol Login
    await tester.tap(loginButton);

    // Tunggu Proses Login & Transisi Layar
    // pumpAndSettle akan menunggu sampai semua animasi & loading selesai
    await tester.pumpAndSettle();
    
    print("=== TEKS YANG TAMPIL DI LAYAR SEKARANG ===");
    final allTextWidgets = find.byType(Text);
    for (var widget in allTextWidgets.evaluate()) {
      var textWidget = widget.widget as Text;
      print("-> ${textWidget.data}");
    }
    print("============================================");
    print('\n');

    // Verifikasi
    // Pastikan kita sudah pindah halaman dengan mengecek teks khas di Home
    expect(find.textContaining('Hello'), findsOneWidget);
    expect(find.textContaining('rhiki'), findsOneWidget);
    print('E2E Test: Login Flow berhasil. ${DateTime.now()}');

  });
}
