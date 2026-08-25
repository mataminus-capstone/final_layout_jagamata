part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const ANALISIS_KELELAHAN = _Paths.ANALISIS_KELELAHAN;
  static const ANALISIS_POTENSI = _Paths.ANALISIS_POTENSI;
  static const RIWAYAT_DETEKSI_MATA = _Paths.RIWAYAT_DETEKSI_MATA;
}

abstract class _Paths {
  _Paths._();
  static const ANALISIS_KELELAHAN = '/analisis-kelelahan';
  static const ANALISIS_POTENSI = '/analisis-potensi';
  static const RIWAYAT_DETEKSI_MATA = '/riwayat-deteksi-mata';
}
