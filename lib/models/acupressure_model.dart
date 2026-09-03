// Lokasi: lib/models/acupressure_model.dart
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

enum EyeSide { left, right }

/// Enum untuk menentukan kondisi mata berdasarkan hasil deteksi.
///
/// Mengikuti dokumentasi `titik-accupresure.md` yang membagi menjadi
/// 3 Mode Terapi Akupresur:
/// - [normal]                -> Mode Normal (semua titik, durasi standar)
/// - [fatigued]              -> Mode Kelelahan Tanpa Pusing (fokus Titik 1-3)
/// - [fatiguedWithDizziness] -> Mode Kelelahan dengan Pusing (fokus Titik 4-5, +2 detik)
enum EyeCondition {
  normal,
  fatigued,
  fatiguedWithDizziness;

  /// Apakah kondisi menunjukkan kelelahan mata (dengan/tanpa pusing)
  bool get isFatigued => this != EyeCondition.normal;

  /// Apakah kelelahan disertai sakit kepala/pusing
  bool get withDizziness => this == EyeCondition.fatiguedWithDizziness;
}

class AcupressurePoint {
  final String code; // Kode titik (BL-2, EX-HN4, dll)
  final String chineseName; // Nama dalam bahasa China
  final String title; // Nama/lokasi titik
  final String instruction; // Instruksi untuk pengguna
  final String description; // Alasan/manfaat
  final FaceLandmarkType landmarkType;
  final EyeSide side;
  final double offsetX; // Geser Horizontal
  final double offsetY; // Geser Vertikal
  final int? duration; // Durasi khusus per titik (null = pakai durasi config)
  final bool isPriority; // Titik prioritas / fokus pada mode tertentu

  AcupressurePoint({
    required this.code,
    required this.chineseName,
    required this.title,
    required this.instruction,
    required this.description,
    required this.landmarkType,
    required this.side,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.duration,
    this.isPriority = false,
  });
}

/// Konfigurasi terapi berdasarkan kondisi mata
class TherapyConfig {
  final int durationPerPoint; // Durasi dasar per titik dalam detik
  final int repetitions; // Jumlah pengulangan
  final String pressureLevel; // Level tekanan
  final String description; // Deskripsi terapi

  const TherapyConfig({
    required this.durationPerPoint,
    required this.repetitions,
    required this.pressureLevel,
    required this.description,
  });
}

/// Konfigurasi untuk mata normal (Mode Normal / Maintenance)
/// - Durasi standar: 5-10 detik per titik
/// - Tekanan: ringan
/// - Aman untuk pemakaian harian
const normalTherapyConfig = TherapyConfig(
  durationPerPoint: 6, // 5-10 detik, ambil rata-rata
  repetitions: 1,
  pressureLevel: "Ringan",
  description:
      "Terapi maintenance untuk menjaga kesehatan mata. Pijat dengan tekanan ringan pada semua titik (1-5).",
);

/// Konfigurasi untuk mata kelelahan TANPA pusing
/// - Fokus & prioritas pada Titik 1, 2, 3 (area alis)
/// - Waktu optimal: 10-15 detik/titik
/// - Tekanan: sedang - kuat
const fatigueTherapyConfig = TherapyConfig(
  durationPerPoint: 12, // 10-15 detik, ambil rata-rata
  repetitions: 2,
  pressureLevel: "Sedang - Kuat",
  description:
      "Terapi untuk mata lelah tanpa sakit kepala/pusing. Fokus pada Titik 1, 2, 3 (area alis) untuk relaksasi otot mata.",
);

/// Konfigurasi untuk mata kelelahan DENGAN pusing
/// - Fokus & prioritas pada Titik 4 & 5 (Jingming & Tongziliao)
/// - Durasi ekstra +2 detik pada Titik 4 & 5
/// - Tekanan: sedang - kuat
const fatigueDizzinessTherapyConfig = TherapyConfig(
  durationPerPoint: 12, // 10-15 detik, ambil rata-rata
  repetitions: 2,
  pressureLevel: "Sedang - Kuat",
  description:
      "Terapi untuk mata lelah disertai sakit kepala/pusing. Fokus pada Titik 4 & 5 dengan durasi ekstra +2 detik.",
);

// ==============================================================================
// 5 TITIK AKUPRESUR (per sisi) sesuai titik-accupresure.md
// ==============================================================================
// 1. BL-2 (Zanzhu)      - Pangkal alis
// 2. EX-HN4 (Yuyao)     - Tengah alis
// 3. TE-23 (Sizhukong)  - Ujung alis
// 4. BL-1 (Jingming)    - Sudut dalam mata
// 5. GB-1 (Tongziliao)  - Sudut luar mata
// ==============================================================================

/// Titik 1 kiri - Pangkal alis (Zanzhu)
AcupressurePoint _zanzhuLeft({bool priority = false, int? duration}) =>
    AcupressurePoint(
      code: "BL-2",
      chineseName: "Zanzhu (攢竹)",
      title: "Mata Kiri: Pangkal Alis",
      instruction:
          "Pijat pangkal alis kiri dekat hidung dengan tekanan sedang-kuat.",
      description: "Meredakan ketegangan otot mata & mata lelah",
      landmarkType: FaceLandmarkType.leftEye,
      side: EyeSide.left,
      offsetX: 8.0,
      offsetY: -28.0,
      isPriority: priority,
      duration: duration,
    );

/// Titik 2 kiri - Tengah alis (Yuyao)
AcupressurePoint _yuyaoLeft({bool priority = false, int? duration}) =>
    AcupressurePoint(
      code: "EX-HN4",
      chineseName: "Yuyao (魚腰)",
      title: "Mata Kiri: Tengah Alis",
      instruction: "Pijat tengah alis kiri dengan tekanan sedang-kuat.",
      description: "Meredakan mata lelah, silau & kelelahan saraf penglihatan",
      landmarkType: FaceLandmarkType.leftEye,
      side: EyeSide.left,
      offsetX: -8.0,
      offsetY: -32.0,
      isPriority: priority,
      duration: duration,
    );

/// Titik 3 kiri - Ujung alis (Sizhukong)
AcupressurePoint _sizhukongLeft({bool priority = false, int? duration}) =>
    AcupressurePoint(
      code: "TE-23",
      chineseName: "Sizhukong (絲竹空)",
      title: "Mata Kiri: Ujung Alis",
      instruction:
          "Pijat ujung alis kiri menuju pelipis dengan tekanan sedang-kuat.",
      description: "Meredakan ketegangan mata & relaksasi area mata",
      landmarkType: FaceLandmarkType.leftEye,
      side: EyeSide.left,
      offsetX: -35.0,
      offsetY: -18.0,
      isPriority: priority,
      duration: duration,
    );

/// Titik 4 kiri - Sudut dalam mata (Jingming)
AcupressurePoint _jingmingLeft({bool priority = false, int? duration}) =>
    AcupressurePoint(
      code: "BL-1",
      chineseName: "Jingming (睛明)",
      title: "Mata Kiri: Sudut Dalam Mata",
      instruction:
          "Pijat sudut dalam mata kiri dekat pangkal hidung dengan tekanan sedang-kuat.",
      description: "Mata lelah menyebar ke hidung/dahi & sakit kepala ringan",
      landmarkType: FaceLandmarkType.leftEye,
      side: EyeSide.left,
      offsetX: 18.0,
      offsetY: 0.0,
      isPriority: priority,
      duration: duration,
    );

/// Titik 5 kiri - Sudut luar mata (Tongziliao)
AcupressurePoint _tongziliaoLeft({bool priority = false, int? duration}) =>
    AcupressurePoint(
      code: "GB-1",
      chineseName: "Tongziliao (瞳子髎)",
      title: "Mata Kiri: Sudut Luar Mata",
      instruction:
          "Pijat sudut luar mata kiri dekat pelipis dengan tekanan sedang-kuat.",
      description: "Meredakan pusing, migrain & sakit kepala bagian samping",
      landmarkType: FaceLandmarkType.leftEye,
      side: EyeSide.left,
      offsetX: -38.0,
      offsetY: 0.0,
      isPriority: priority,
      duration: duration,
    );

/// Titik 1 kanan - Pangkal alis (Zanzhu)
AcupressurePoint _zanzhuRight({bool priority = false, int? duration}) =>
    AcupressurePoint(
      code: "BL-2",
      chineseName: "Zanzhu (攢竹)",
      title: "Mata Kanan: Pangkal Alis",
      instruction:
          "Pijat pangkal alis kanan dekat hidung dengan tekanan sedang-kuat.",
      description: "Meredakan ketegangan otot mata & mata lelah",
      landmarkType: FaceLandmarkType.rightEye,
      side: EyeSide.right,
      offsetX: -8.0,
      offsetY: -28.0,
      isPriority: priority,
      duration: duration,
    );

/// Titik 2 kanan - Tengah alis (Yuyao)
AcupressurePoint _yuyaoRight({bool priority = false, int? duration}) =>
    AcupressurePoint(
      code: "EX-HN4",
      chineseName: "Yuyao (魚腰)",
      title: "Mata Kanan: Tengah Alis",
      instruction: "Pijat tengah alis kanan dengan tekanan sedang-kuat.",
      description: "Meredakan mata lelah, silau & kelelahan saraf penglihatan",
      landmarkType: FaceLandmarkType.rightEye,
      side: EyeSide.right,
      offsetX: 8.0,
      offsetY: -32.0,
      isPriority: priority,
      duration: duration,
    );

/// Titik 3 kanan - Ujung alis (Sizhukong)
AcupressurePoint _sizhukongRight({bool priority = false, int? duration}) =>
    AcupressurePoint(
      code: "TE-23",
      chineseName: "Sizhukong (絲竹空)",
      title: "Mata Kanan: Ujung Alis",
      instruction:
          "Pijat ujung alis kanan menuju pelipis dengan tekanan sedang-kuat.",
      description: "Meredakan ketegangan mata & relaksasi area mata",
      landmarkType: FaceLandmarkType.rightEye,
      side: EyeSide.right,
      offsetX: 35.0,
      offsetY: -18.0,
      isPriority: priority,
      duration: duration,
    );

/// Titik 4 kanan - Sudut dalam mata (Jingming)
AcupressurePoint _jingmingRight({bool priority = false, int? duration}) =>
    AcupressurePoint(
      code: "BL-1",
      chineseName: "Jingming (睛明)",
      title: "Mata Kanan: Sudut Dalam Mata",
      instruction:
          "Pijat sudut dalam mata kanan dekat pangkal hidung dengan tekanan sedang-kuat.",
      description: "Mata lelah menyebar ke hidung/dahi & sakit kepala ringan",
      landmarkType: FaceLandmarkType.rightEye,
      side: EyeSide.right,
      offsetX: -18.0,
      offsetY: 0.0,
      isPriority: priority,
      duration: duration,
    );

/// Titik 5 kanan - Sudut luar mata (Tongziliao)
AcupressurePoint _tongziliaoRight({bool priority = false, int? duration}) =>
    AcupressurePoint(
      code: "GB-1",
      chineseName: "Tongziliao (瞳子髎)",
      title: "Mata Kanan: Sudut Luar Mata",
      instruction:
          "Pijat sudut luar mata kanan dekat pelipis dengan tekanan sedang-kuat.",
      description: "Meredakan pusing, migrain & sakit kepala bagian samping",
      landmarkType: FaceLandmarkType.rightEye,
      side: EyeSide.right,
      offsetX: 38.0,
      offsetY: 0.0,
      isPriority: priority,
      duration: duration,
    );

// ==============================================================================
// TITIK AKUPRESUR UNTUK MATA NORMAL (Mode Normal - 5 Titik per sisi)
// ==============================================================================
// Semua titik (1-5), fokus seimbang, durasi standar.

final List<AcupressurePoint> normalAcupressurePoints = [
  // MATA KIRI (5 Titik)
  _zanzhuLeft(),
  _yuyaoLeft(),
  _sizhukongLeft(),
  _jingmingLeft(),
  _tongziliaoLeft(),

  // MATA KANAN (5 Titik)
  _zanzhuRight(),
  _yuyaoRight(),
  _sizhukongRight(),
  _jingmingRight(),
  _tongziliaoRight(),
];

// ==============================================================================
// TITIK AKUPRESUR UNTUK MATA KELELAHAN TANPA PUSING (5 Titik per sisi)
// ==============================================================================
// Semua titik (1-5) dengan fokus/prioritas pada Titik 1, 2, 3 (area alis).

final List<AcupressurePoint> fatigueAcupressurePoints = [
  // MATA KIRI (5 Titik)
  _zanzhuLeft(priority: true),
  _yuyaoLeft(priority: true),
  _sizhukongLeft(priority: true),
  _jingmingLeft(),
  _tongziliaoLeft(),

  // MATA KANAN (5 Titik)
  _zanzhuRight(priority: true),
  _yuyaoRight(priority: true),
  _sizhukongRight(priority: true),
  _jingmingRight(),
  _tongziliaoRight(),
];

// ==============================================================================
// TITIK AKUPRESUR UNTUK MATA KELELAHAN DENGAN PUSING (5 Titik per sisi)
// ==============================================================================
// Semua titik (1-5) dengan fokus/prioritas pada Titik 4 & 5 (Jingming &
// Tongziliao) + durasi ekstra +2 detik dibanding titik lainnya.

final List<AcupressurePoint> fatigueDizzinessAcupressurePoints = [
  // MATA KIRI (5 Titik)
  _zanzhuLeft(),
  _yuyaoLeft(),
  _sizhukongLeft(),
  _jingmingLeft(priority: true, duration: 14), // 12 + 2 detik ekstra
  _tongziliaoLeft(priority: true, duration: 14), // 12 + 2 detik ekstra

  // MATA KANAN (5 Titik)
  _zanzhuRight(),
  _yuyaoRight(),
  _sizhukongRight(),
  _jingmingRight(priority: true, duration: 14), // 12 + 2 detik ekstra
  _tongziliaoRight(priority: true, duration: 14), // 12 + 2 detik ekstra
];

/// Mendapatkan titik akupresur berdasarkan kondisi mata
List<AcupressurePoint> getAcupressurePointsByCondition(EyeCondition condition) {
  switch (condition) {
    case EyeCondition.fatigued:
      return fatigueAcupressurePoints;
    case EyeCondition.fatiguedWithDizziness:
      return fatigueDizzinessAcupressurePoints;
    case EyeCondition.normal:
      return normalAcupressurePoints;
  }
}

/// Mendapatkan konfigurasi terapi berdasarkan kondisi mata
TherapyConfig getTherapyConfigByCondition(EyeCondition condition) {
  switch (condition) {
    case EyeCondition.fatigued:
      return fatigueTherapyConfig;
    case EyeCondition.fatiguedWithDizziness:
      return fatigueDizzinessTherapyConfig;
    case EyeCondition.normal:
      return normalTherapyConfig;
  }
}

// Backward compatibility - tetap menyediakan acupressureSequence default (fatigue)
final List<AcupressurePoint> acupressureSequence = fatigueAcupressurePoints;
