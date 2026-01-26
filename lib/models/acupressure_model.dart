// Lokasi: lib/models/acupressure_model.dart
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

enum EyeSide { left, right }

/// Enum untuk menentukan kondisi mata berdasarkan hasil deteksi
enum EyeCondition {
  fatigued, // Mata Kelelahan
  normal, // Mata Normal/Tidak Kelelahan
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
  });
}

/// Konfigurasi terapi berdasarkan kondisi mata
class TherapyConfig {
  final int durationPerPoint; // Durasi per titik dalam detik
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

/// Konfigurasi untuk mata kelelahan
/// - Waktu optimal: 10-15 detik/titik
/// - Tekanan: sedang - kuat
/// - Ulangi 2-3 kali
const fatigueTherapyConfig = TherapyConfig(
  durationPerPoint: 12, // 10-15 detik, ambil rata-rata
  repetitions: 2,
  pressureLevel: "Sedang - Kuat",
  description:
      "Terapi untuk mata yang menunjukkan indikasi kelelahan. Pijat dengan tekanan sedang hingga kuat.",
);

/// Konfigurasi untuk mata normal
/// - Waktu optimal: 5-8 detik/titik
/// - Tekanan: ringan
/// - Aman untuk pemakaian harian
const normalTherapyConfig = TherapyConfig(
  durationPerPoint: 6, // 5-8 detik, ambil rata-rata
  repetitions: 1,
  pressureLevel: "Ringan",
  description:
      "Terapi pencegahan untuk menjaga kesehatan mata. Pijat dengan tekanan ringan.",
);

// ==============================================================================
// TITIK AKUPRESUR UNTUK MATA KELELAHAN (6 Titik per sisi)
// ==============================================================================
// Berdasarkan riset: Dipakai saat menunjukkan indikasi kelelahan

final List<AcupressurePoint> fatigueAcupressurePoints = [
  // ════════════════════════════════════════════════════════════════════════════
  // MATA KIRI (6 Titik untuk Kelelahan)
  // ════════════════════════════════════════════════════════════════════════════

  // 1. BL-2 (Zan Zhu) - Pangkal alis
  AcupressurePoint(
    code: "BL-2",
    chineseName: "Zan Zhu (攢竹)",
    title: "Mata Kiri: Pangkal Alis",
    instruction:
        "Pijat pangkal alis kiri dekat hidung dengan tekanan sedang-kuat. Tahan 12 detik.",
    description: "Relaksasi otot alis & mata",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: 8.0,
    offsetY: -28.0,
  ),

  // 2. EX-HN4 (Yuyao) - Tengah alis
  AcupressurePoint(
    code: "EX-HN4",
    chineseName: "Yuyao (魚腰)",
    title: "Mata Kiri: Tengah Alis",
    instruction: "Pijat tengah alis kiri dengan tekanan sedang-kuat.",
    description: "Eye strain akibat layar",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: -8.0,
    offsetY: -32.0,
  ),

  // 3. TE-23 (Sizhukong) - Ujung luar alis
  AcupressurePoint(
    code: "TE-23",
    chineseName: "Sizhukong (絲竹空)",
    title: "Mata Kiri: Ujung Luar Alis",
    instruction:
        "Pijat ujung alis kiri menuju pelipis dengan tekanan sedang-kuat.",
    description: "Nyeri & tegang sekitar mata",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: -35.0,
    offsetY: -18.0,
  ),

  // 4. EX-HN5 (Taiyang) - Pelipis
  AcupressurePoint(
    code: "EX-HN5",
    chineseName: "Taiyang (太陽)",
    title: "Mata Kiri: Pelipis",
    instruction: "Pijat area pelipis kiri dengan tekanan sedang-kuat.",
    description: "Sakit kepala + mata lelah",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: -50.0,
    offsetY: -5.0,
  ),

  // 5. GB-1 (Tongziliao) - Sudut luar mata
  AcupressurePoint(
    code: "GB-1",
    chineseName: "Tongziliao (瞳子髎)",
    title: "Mata Kiri: Sudut Luar Mata",
    instruction:
        "Pijat sudut luar mata kiri dekat pelipis dengan tekanan sedang-kuat.",
    description: "Ketegangan lateral mata",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: -38.0,
    offsetY: 0.0,
  ),

  // 6. ST-1 (Chengqi) - Bawah pupil
  AcupressurePoint(
    code: "ST-1",
    chineseName: "Chengqi (承泣)",
    title: "Mata Kiri: Bawah Pupil",
    instruction:
        "Pijat tulang bawah kelopak mata kiri tengah dengan tekanan sedang-kuat.",
    description: "Eye fatigue, mata kering",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: 0.0,
    offsetY: 25.0,
  ),

  // ════════════════════════════════════════════════════════════════════════════
  // MATA KANAN (6 Titik untuk Kelelahan)
  // ════════════════════════════════════════════════════════════════════════════

  // 7. BL-2 (Zan Zhu) - Pangkal alis kanan
  AcupressurePoint(
    code: "BL-2",
    chineseName: "Zan Zhu (攢竹)",
    title: "Mata Kanan: Pangkal Alis",
    instruction:
        "Pijat pangkal alis kanan dekat hidung dengan tekanan sedang-kuat. Tahan 12 detik.",
    description: "Relaksasi otot alis & mata",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: -8.0,
    offsetY: -28.0,
  ),

  // 8. EX-HN4 (Yuyao) - Tengah alis kanan
  AcupressurePoint(
    code: "EX-HN4",
    chineseName: "Yuyao (魚腰)",
    title: "Mata Kanan: Tengah Alis",
    instruction: "Pijat tengah alis kanan dengan tekanan sedang-kuat.",
    description: "Eye strain akibat layar",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 8.0,
    offsetY: -32.0,
  ),

  // 9. TE-23 (Sizhukong) - Ujung luar alis kanan
  AcupressurePoint(
    code: "TE-23",
    chineseName: "Sizhukong (絲竹空)",
    title: "Mata Kanan: Ujung Luar Alis",
    instruction:
        "Pijat ujung alis kanan menuju pelipis dengan tekanan sedang-kuat.",
    description: "Nyeri & tegang sekitar mata",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 35.0,
    offsetY: -18.0,
  ),

  // 10. EX-HN5 (Taiyang) - Pelipis kanan
  AcupressurePoint(
    code: "EX-HN5",
    chineseName: "Taiyang (太陽)",
    title: "Mata Kanan: Pelipis",
    instruction: "Pijat area pelipis kanan dengan tekanan sedang-kuat.",
    description: "Sakit kepala + mata lelah",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 50.0,
    offsetY: -5.0,
  ),

  // 11. GB-1 (Tongziliao) - Sudut luar mata kanan
  AcupressurePoint(
    code: "GB-1",
    chineseName: "Tongziliao (瞳子髎)",
    title: "Mata Kanan: Sudut Luar Mata",
    instruction:
        "Pijat sudut luar mata kanan dekat pelipis dengan tekanan sedang-kuat.",
    description: "Ketegangan lateral mata",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 38.0,
    offsetY: 0.0,
  ),

  // 12. ST-1 (Chengqi) - Bawah pupil kanan
  AcupressurePoint(
    code: "ST-1",
    chineseName: "Chengqi (承泣)",
    title: "Mata Kanan: Bawah Pupil",
    instruction:
        "Pijat tulang bawah kelopak mata kanan tengah dengan tekanan sedang-kuat.",
    description: "Eye fatigue, mata kering",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 0.0,
    offsetY: 25.0,
  ),
];

// ==============================================================================
// TITIK AKUPRESUR UNTUK MATA NORMAL/TIDAK KELELAHAN (4 Titik per sisi)
// ==============================================================================
// Berdasarkan riset: Aman untuk pemakaian harian (maintenance/pencegahan)

final List<AcupressurePoint> normalAcupressurePoints = [
  // ════════════════════════════════════════════════════════════════════════════
  // MATA KIRI (4 Titik untuk Maintenance)
  // ════════════════════════════════════════════════════════════════════════════

  // 1. BL-1 (Jingming) - Sudut dalam mata
  AcupressurePoint(
    code: "BL-1",
    chineseName: "Jingming (睛明)",
    title: "Mata Kiri: Sudut Dalam Mata",
    instruction:
        "Pijat sudut dalam mata kiri dekat hidung dengan tekanan ringan. Tahan 6 detik.",
    description: "Sirkulasi darah mata",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: 18.0,
    offsetY: 0.0,
  ),

  // 2. GB-1 (Tongziliao) - Sudut luar mata
  AcupressurePoint(
    code: "GB-1",
    chineseName: "Tongziliao (瞳子髎)",
    title: "Mata Kiri: Sudut Luar Mata",
    instruction:
        "Pijat sudut luar mata kiri dekat pelipis dengan tekanan ringan.",
    description: "Relaksasi ringan",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: -38.0,
    offsetY: 0.0,
  ),

  // 3. EX-HN5 (Taiyang) - Pelipis
  AcupressurePoint(
    code: "EX-HN5",
    chineseName: "Taiyang (太陽)",
    title: "Mata Kiri: Pelipis",
    instruction: "Pijat area pelipis kiri dengan tekanan ringan.",
    description: "Pencegahan tegang mata",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: -50.0,
    offsetY: -5.0,
  ),

  // 4. EX-HN4 (Yuyao) - Tengah alis
  AcupressurePoint(
    code: "EX-HN4",
    chineseName: "Yuyao (魚腰)",
    title: "Mata Kiri: Tengah Alis",
    instruction: "Pijat tengah alis kiri dengan tekanan ringan.",
    description: "Maintenance visual",
    landmarkType: FaceLandmarkType.leftEye,
    side: EyeSide.left,
    offsetX: -8.0,
    offsetY: -32.0,
  ),

  // ════════════════════════════════════════════════════════════════════════════
  // MATA KANAN (4 Titik untuk Maintenance)
  // ════════════════════════════════════════════════════════════════════════════

  // 5. BL-1 (Jingming) - Sudut dalam mata kanan
  AcupressurePoint(
    code: "BL-1",
    chineseName: "Jingming (睛明)",
    title: "Mata Kanan: Sudut Dalam Mata",
    instruction:
        "Pijat sudut dalam mata kanan dekat hidung dengan tekanan ringan. Tahan 6 detik.",
    description: "Sirkulasi darah mata",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: -18.0,
    offsetY: 0.0,
  ),

  // 6. GB-1 (Tongziliao) - Sudut luar mata kanan
  AcupressurePoint(
    code: "GB-1",
    chineseName: "Tongziliao (瞳子髎)",
    title: "Mata Kanan: Sudut Luar Mata",
    instruction:
        "Pijat sudut luar mata kanan dekat pelipis dengan tekanan ringan.",
    description: "Relaksasi ringan",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 38.0,
    offsetY: 0.0,
  ),

  // 7. EX-HN5 (Taiyang) - Pelipis kanan
  AcupressurePoint(
    code: "EX-HN5",
    chineseName: "Taiyang (太陽)",
    title: "Mata Kanan: Pelipis",
    instruction: "Pijat area pelipis kanan dengan tekanan ringan.",
    description: "Pencegahan tegang mata",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 50.0,
    offsetY: -5.0,
  ),

  // 8. EX-HN4 (Yuyao) - Tengah alis kanan
  AcupressurePoint(
    code: "EX-HN4",
    chineseName: "Yuyao (魚腰)",
    title: "Mata Kanan: Tengah Alis",
    instruction: "Pijat tengah alis kanan dengan tekanan ringan.",
    description: "Maintenance visual",
    landmarkType: FaceLandmarkType.rightEye,
    side: EyeSide.right,
    offsetX: 8.0,
    offsetY: -32.0,
  ),
];

/// Mendapatkan titik akupresur berdasarkan kondisi mata
List<AcupressurePoint> getAcupressurePointsByCondition(EyeCondition condition) {
  switch (condition) {
    case EyeCondition.fatigued:
      return fatigueAcupressurePoints;
    case EyeCondition.normal:
      return normalAcupressurePoints;
  }
}

/// Mendapatkan konfigurasi terapi berdasarkan kondisi mata
TherapyConfig getTherapyConfigByCondition(EyeCondition condition) {
  switch (condition) {
    case EyeCondition.fatigued:
      return fatigueTherapyConfig;
    case EyeCondition.normal:
      return normalTherapyConfig;
  }
}

// Backward compatibility - tetap menyediakan acupressureSequence default (fatigue)
final List<AcupressurePoint> acupressureSequence = fatigueAcupressurePoints;
