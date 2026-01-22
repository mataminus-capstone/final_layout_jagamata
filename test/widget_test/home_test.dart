import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jagamata/pages/homepage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HOMEPAGE TEST - Widget Test', () {
    testWidgets('Menampilkan header Hello dan username', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Homopage()));

      expect(find.text('Hello!'), findsOneWidget);
      expect(find.text('User'), findsOneWidget);

      print('PASS: Header tampil');
    });

    testWidgets('Search bar dapat diisi', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Homopage()));

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'mata minus');

      expect(find.text('mata minus'), findsOneWidget);
      print('PASS: Search bar dapat diisi');
    });

    testWidgets('Search bar dapat diisi', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Homopage()));

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'deteksi');

      expect(find.text('deteksi'), findsOneWidget);
      print('PASS: Search bar dapat diisi');
    });

    testWidgets('Icon Deteksi dapat ditekan', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/deteksi': (_) => const Scaffold(body: Text('Deteksi Page')),
          },
          home: const Homopage(),
        ),
      );

      await tester.pumpAndSettle();

      // TAP ICON, BUKAN TEXT
      final deteksiIcon = find.byIcon(Icons.remove_red_eye_rounded);

      expect(deteksiIcon, findsOneWidget);

      await tester.tap(deteksiIcon);
      await tester.pumpAndSettle();

      expect(find.text('Deteksi Page'), findsOneWidget);
      print('PASS: Icon Deteksi dapat ditekan');
    });

    testWidgets('Teks Lihat Semua dapat ditekan', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/artikelnew': (_) => const Scaffold(body: Text('Artikel Page')),
          },
          home: const Homopage(),
        ),
      );

      await tester.tap(find.text('Lihat Semua'));
      await tester.pumpAndSettle();

      expect(find.text('Artikel Page'), findsOneWidget);
      print('PASS: Lihat Semua navigasi');
    });
  });
}
