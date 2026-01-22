import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:jagamata/pages/profil/profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PROFILE TEST - Widget Test', () {
    testWidgets('Profil page tampil', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Profil();
            },
          ),
        ),
      );

      // biar loading lewat
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Profil Saya'), findsOneWidget);
      print('PASS: Profil page tampil');
    });
    testWidgets('Klik icon edit membuka dialog Edit Profil', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Profil()));

      await tester.pump(const Duration(seconds: 1));

      // cari icon edit (yang kecil di avatar)
      final editIcon = find.byIcon(Icons.edit).first;

      expect(editIcon, findsOneWidget);

      await tester.tap(editIcon);
      await tester.pumpAndSettle();

      expect(find.text('Edit Profil'), findsOneWidget);
      print('PASS: Dialog Edit Profil tampil');
    });
    testWidgets('Input field Edit Profil dapat diisi', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Profil()));

      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Riki Test');
      await tester.enterText(find.byType(TextFormField).at(1), '08123456789');
      await tester.enterText(find.byType(TextFormField).at(2), 'Jakarta');

      expect(find.text('Riki Test'), findsOneWidget);
      expect(find.text('08123456789'), findsOneWidget);
      expect(find.text('Jakarta'), findsOneWidget);
      print('PASS: Input field dapat diisi');
    });

    testWidgets('Button Simpan dapat ditekan', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Profil(),
    ),
  );

  await tester.pump(const Duration(seconds: 1));

  await tester.tap(find.byIcon(Icons.edit).first);
  await tester.pumpAndSettle();

  final saveButton = find.text('Simpan');

  expect(saveButton, findsOneWidget);

  await tester.tap(saveButton);
  await tester.pump();

  // cukup lolos tanpa error
  expect(saveButton, findsOneWidget);
  print('PASS: Button Simpan dapat ditekan');
});

  });
}
