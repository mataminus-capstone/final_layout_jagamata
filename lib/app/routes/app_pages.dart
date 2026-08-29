import 'package:get/get.dart';

import '../../pages/analisis_kelelahan/bindings/analisis_kelelahan_binding.dart';
import '../../pages/analisis_kelelahan/views/analisis_kelelahan_view.dart';
import '../../pages/analisis_potensi/bindings/analisis_potensi_binding.dart';
import '../../pages/analisis_potensi/views/analisis_potensi_view.dart';
import '../../pages/riwayat_deteksi_mata/bindings/riwayat_deteksi_mata_binding.dart';
import '../../pages/riwayat_deteksi_mata/views/riwayat_deteksi_mata_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // Ubah INITIAL menjadi teks biasa '/' saja agar tidak error mencari Routes.HOME
  static const INITIAL = '/';

  static final routes = [
    GetPage(
      name: _Paths.ANALISIS_KELELAHAN,
      page: () => const AnalisisKelelahanView(),
      binding: AnalisisKelelahanBinding(),
    ),
    GetPage(
      name: _Paths.ANALISIS_POTENSI,
      page: () => const AnalisisPotensiView(),
      binding: AnalisisPotensiBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT_DETEKSI_MATA,
      page: () => const RiwayatDeteksiMataView(),
      binding: RiwayatDeteksiMataBinding(),
    ),
  ];
}
