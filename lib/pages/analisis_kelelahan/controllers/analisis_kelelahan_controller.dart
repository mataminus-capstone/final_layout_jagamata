import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jagamata/main.dart' show cameras;
import 'package:jagamata/models/acupressure_model.dart';
import 'package:jagamata/pages/treatment/acupressure_page.dart';

class AnalisisKelelahanController extends GetxController {
  // ============================================================
  // HASIL DETEKSI
  // ============================================================

  final RxMap<String, dynamic> result = <String, dynamic>{}.obs;

  // ============================================================
  // PUSING
  // ============================================================

  final RxBool isPusing = true.obs;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    _loadArguments();
  }

  // ============================================================
  // LOAD DATA DARI GET.ARGUMENTS
  // ============================================================

  void _loadArguments() {
    try {
      final arguments = Get.arguments;

      debugPrint('========================================');
      debugPrint('ANALISIS KELELAHAN CONTROLLER');
      debugPrint('Get.arguments: $arguments');
      debugPrint('Arguments type: ${arguments.runtimeType}');

      if (arguments is Map) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(arguments);

        // --------------------------------------------------------
        // Kemungkinan 1:
        //
        // {
        //   label: Non Drowsy,
        //   confidence: 0.99,
        //   image_url: ...
        // }
        // --------------------------------------------------------

        if (data.containsKey('label') ||
            data.containsKey('confidence') ||
            data.containsKey('image_url')) {
          result.assignAll(data);

          debugPrint('Data langsung berhasil dimasukkan.');
        }

        // --------------------------------------------------------
        // Kemungkinan 2:
        //
        // {
        //   data: {
        //      label: ...,
        //      confidence: ...,
        //      image_url: ...
        //   }
        // }
        // --------------------------------------------------------

        else if (data['data'] is Map) {
          final nestedData =
              Map<String, dynamic>.from(data['data'] as Map);

          result.assignAll(nestedData);

          debugPrint('Data nested berhasil dimasukkan.');
        }
      }

      debugPrint('RESULT CONTROLLER: ${result.toJson()}');
      debugPrint('RESULT LABEL: $label');
      debugPrint('RESULT CONFIDENCE: $confidence');
      debugPrint('RESULT IMAGE URL: $imageUrl');
      debugPrint('========================================');
    } catch (e, stackTrace) {
      debugPrint('ERROR LOAD ARGUMENTS: $e');
      debugPrint('$stackTrace');
    }
  }

  // ============================================================
  // TOGGLE PUSING
  // ============================================================

  void togglePusing(bool? value) {
    isPusing.value = value ?? false;
  }

  // ============================================================
  // MULAI TERAPI
  // ============================================================

  void mulaiTerapi() {
    // Tentukan mode akupresur berdasarkan hasil deteksi:
    // - Tidak lelah        -> Mode Normal
    // - Lelah tanpa pusing -> Mode Kelelahan Tanpa Pusing
    // - Lelah + pusing     -> Mode Kelelahan + Pusing
    final EyeCondition condition;
    if (!isFatigued) {
      condition = EyeCondition.normal;
    } else if (isPusing.value) {
      condition = EyeCondition.fatiguedWithDizziness;
    } else {
      condition = EyeCondition.fatigued;
    }

    Get.to(() => AcupressurePage(
          cameras: cameras,
          eyeCondition: condition,
        ));
  }

  // ============================================================
  // HELPER ARGUMENT
  // ============================================================

  Map<String, dynamic> get _argumentData {
    try {
      final arguments = Get.arguments;

      if (arguments is Map) {
        final data = Map<String, dynamic>.from(arguments);

        // Data langsung
        if (data.containsKey('label') ||
            data.containsKey('confidence') ||
            data.containsKey('image_url')) {
          return data;
        }

        // Data nested
        if (data['data'] is Map) {
          return Map<String, dynamic>.from(data['data'] as Map);
        }
      }
    } catch (_) {}

    return {};
  }

  // ============================================================
  // LABEL
  // ============================================================

  String get label {
    final value = result['label'];

    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }

    // Fallback langsung ke Get.arguments
    final argumentValue = _argumentData['label'];

    if (argumentValue != null &&
        argumentValue.toString().trim().isNotEmpty) {
      return argumentValue.toString();
    }

    return 'Unknown';
  }

  // ============================================================
  // CONFIDENCE
  // ============================================================

  double get confidence {
    dynamic value = result['confidence'];

    // Fallback kalau result kosong
    if (value == null) {
      value = _argumentData['confidence'];
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  // ============================================================
  // IMAGE URL
  // ============================================================

  String get imageUrl {
    dynamic value = result['image_url'];

    // Fallback langsung ke Get.arguments
    if (value == null ||
        value.toString().trim().isEmpty) {
      value = _argumentData['image_url'];
    }

    if (value != null) {
      return value.toString();
    }

    return '';
  }

  // ============================================================
  // STATUS KELELAHAN
  // ============================================================

  bool get isFatigued {
    final normalized = label.toLowerCase();

    // Jangan anggap "Non Drowsy" sebagai fatigue
    if (normalized.contains('non') ||
        normalized.contains('not') ||
        normalized.contains('tidak') ||
        normalized.contains('awake') ||
        normalized.contains('normal') ||
        normalized.contains('segar') ||
        normalized.contains('alert')) {
      return false;
    }

    return normalized.contains('drowsy') ||
        normalized.contains('fatigue') ||
        normalized.contains('tired') ||
        normalized.contains('kantuk') ||
        normalized.contains('lelah') ||
        normalized.contains('ngantuk');
  }
}