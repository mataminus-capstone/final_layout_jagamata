import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jagamata/services/api_service.dart';


class RiwayatDeteksiMataController extends GetxController {
  // ============================================================
  // TAB
  // ============================================================

  // 0 = Potensi Penyakit
  // 1 = Kelelahan Mata
  final selectedTab = 0.obs;

  // ============================================================
  // HISTORY DATA
  // ============================================================

  final RxList<Map<String, dynamic>> diseaseHistory =
      <Map<String, dynamic>>[].obs;

  final RxList<Map<String, dynamic>> fatigueHistory =
      <Map<String, dynamic>>[].obs;

  // ============================================================
  // STATE
  // ============================================================

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    debugPrint('');
    debugPrint('========================================');
    debugPrint('[RIWAYAT] CONTROLLER INIT');
    debugPrint('========================================');

    loadHistory();
  }

  // ============================================================
  // CHANGE TAB
  // ============================================================

  void changeTab(int index) {
    debugPrint('[RIWAYAT] Change tab: $index');

    selectedTab.value = index;
  }

  // ============================================================
  // LOAD ALL HISTORY
  // ============================================================

  Future<void> loadHistory() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      debugPrint('');
      debugPrint('========================================');
      debugPrint('[RIWAYAT] START LOAD HISTORY');
      debugPrint('========================================');

      // Jalankan dua request sekaligus
      final results = await Future.wait([
        ApiService.getDetectionHistory(),
        ApiService.getDrowsinessHistory(),
      ]);

      final diseaseResult = results[0];
      final fatigueResult = results[1];

      // ========================================================
      // DISEASE
      // ========================================================

      debugPrint('');
      debugPrint('[RIWAYAT] DISEASE API RESULT');
      debugPrint('success: ${diseaseResult['success']}');
      debugPrint('data type: ${diseaseResult['data'].runtimeType}');
      debugPrint('data: ${diseaseResult['data']}');

      if (diseaseResult['success'] == true) {
        diseaseHistory.assignAll(
          _parseHistoryList(diseaseResult['data']),
        );
      } else {
        debugPrint(
          '[RIWAYAT] Disease history gagal: '
          '${diseaseResult['message']}',
        );
      }

      // ========================================================
      // FATIGUE
      // ========================================================

      debugPrint('');
      debugPrint('[RIWAYAT] FATIGUE API RESULT');
      debugPrint('success: ${fatigueResult['success']}');
      debugPrint('data type: ${fatigueResult['data'].runtimeType}');
      debugPrint('data: ${fatigueResult['data']}');

      if (fatigueResult['success'] == true) {
        fatigueHistory.assignAll(
          _parseHistoryList(fatigueResult['data']),
        );
      } else {
        debugPrint(
          '[RIWAYAT] Fatigue history gagal: '
          '${fatigueResult['message']}',
        );
      }

      // ========================================================
      // SUMMARY
      // ========================================================

      debugPrint('');
      debugPrint('========================================');
      debugPrint('[RIWAYAT] LOAD HISTORY SELESAI');
      debugPrint('Disease count: ${diseaseHistory.length}');
      debugPrint('Fatigue count: ${fatigueHistory.length}');
      debugPrint('========================================');
      debugPrint('');
    } catch (e, stackTrace) {
      errorMessage.value = e.toString();

      debugPrint('');
      debugPrint('========================================');
      debugPrint('[RIWAYAT] ERROR LOAD HISTORY');
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace');
      debugPrint('========================================');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // PARSE HISTORY
  // ============================================================

  List<Map<String, dynamic>> _parseHistoryList(dynamic data) {
    debugPrint('[RIWAYAT] Parsing history data...');
    debugPrint('[RIWAYAT] Raw data: $data');
    debugPrint('[RIWAYAT] Raw type: ${data.runtimeType}');

    if (data is List) {
      final result = data
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList();

      debugPrint(
        '[RIWAYAT] Parsed list langsung: ${result.length} item',
      );

      return result;
    }

    // Antisipasi kalau backend mengembalikan:
    //
    // {
    //   "history": [...]
    // }
    //

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);

      final possibleKeys = [
        'history',
        'detections',
        'results',
        'items',
      ];

      for (final key in possibleKeys) {
        if (map[key] is List) {
          final result = (map[key] as List)
              .whereType<Map>()
              .map(
                (item) => Map<String, dynamic>.from(item),
              )
              .toList();

          debugPrint(
            '[RIWAYAT] Parsed dari key "$key": '
            '${result.length} item',
          );

          return result;
        }
      }
    }

    debugPrint('[RIWAYAT] Tidak menemukan list history.');

    return [];
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshHistory() async {
    debugPrint('[RIWAYAT] Refresh history');

    await loadHistory();
  }

  // ============================================================
  // HELPER CONFIDENCE
  // ============================================================

  double parseConfidence(dynamic value) {
    if (value is num) {
      final number = value.toDouble();

      // Kalau API mengirim 0.928
      if (number <= 1) {
        return number * 100;
      }

      // Kalau API mengirim 92.8
      return number;
    }

    if (value is String) {
      final cleaned = value.replaceAll('%', '').trim();

      final number = double.tryParse(cleaned);

      if (number == null) {
        return 0;
      }

      if (number <= 1) {
        return number * 100;
      }

      return number;
    }

    return 0;
  }

  // ============================================================
  // DEBUG MANUAL
  // ============================================================

  void debugHistory() {
    debugPrint('');
    debugPrint('========================================');
    debugPrint('[RIWAYAT DEBUG]');
    debugPrint('Selected tab: ${selectedTab.value}');
    debugPrint('Loading: ${isLoading.value}');
    debugPrint('Disease count: ${diseaseHistory.length}');
    debugPrint('Fatigue count: ${fatigueHistory.length}');
    debugPrint('');
    debugPrint('DISEASE DATA:');

    for (final item in diseaseHistory) {
      debugPrint(item.toString());
    }

    debugPrint('');
    debugPrint('FATIGUE DATA:');

    for (final item in fatigueHistory) {
      debugPrint(item.toString());
    }

    debugPrint('========================================');
  }
}