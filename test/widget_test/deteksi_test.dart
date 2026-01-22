import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jagamata/pages/rekomendasi/rekomendasi.dart';

void main() {
  testWidgets('REKOMENDASI PAGE - Halaman Rekomendasi tampil', (tester) async {
    await tester.binding.setSurfaceSize(const Size(414, 896));

    await tester.pumpWidget(
      const MaterialApp(
        home: Rekomendasi(),
      ),
    );

    expect(find.text('Rekomendasi'), findsOneWidget);
    expect(find.text('Rekomendasi Kesehatan'), findsOneWidget);
    print('PASS: Halaman Rekomendasi tampil');
  });

  testWidgets('REKOMENDASI PAGE - Card Klinik Mata dapat ditekan', (tester) async {
  await tester.binding.setSurfaceSize(const Size(414, 896));

  await tester.pumpWidget(
    MaterialApp(
      routes: {
        '/klinik': (context) => const Scaffold(body: Text('Klinik Page')),
      },
      home: const Rekomendasi(),
    ),
  );

  await tester.tap(find.text('Klinik Mata'));
  await tester.pumpAndSettle();

  expect(find.text('Klinik Page'), findsOneWidget);
  print('PASS: Card Klinik Mata dapat ditekan');
});

  testWidgets('REKOMENDASI PAGE - Card Obat Mata dapat ditekan', (tester) async {
  await tester.binding.setSurfaceSize(const Size(414, 896));

  await tester.pumpWidget(
    MaterialApp(
      routes: {
        '/obat': (context) => const Scaffold(body: Text('Obat Page')),
      },
      home: const Rekomendasi(),
    ),
  );

  await tester.tap(find.text('Obat Mata'));
  await tester.pumpAndSettle();

  expect(find.text('Obat Page'), findsOneWidget);
  print('PASS: Card Obat Mata dapat ditekan');
});

}
