import 'package:get/get.dart';

class AnalisisPotensiController extends GetxController {
  Map<String, dynamic> data = {};

  @override
  void onInit() {
    super.onInit();

    _loadArguments();
  }

  void _loadArguments() {
    final arguments = Get.arguments;

    print('========================================');
    print('[ANALISIS POTENSI CONTROLLER]');
    print('Get.arguments: $arguments');
    print('Type: ${arguments.runtimeType}');
    print('========================================');

    if (arguments is Map) {
      data = Map<String, dynamic>.from(arguments);

      print('[CONTROLLER] DATA BERHASIL DITERIMA');
      print('id: ${data['id']}');
      print('diagnosis: ${data['diagnosis']}');
      print('confidence: ${data['confidence']}');
      print('image_url: ${data['image_url']}');
      print('handling: ${data['handling']}');
      print('solution: ${data['solution']}');
    } else {
      print('[CONTROLLER] ERROR: arguments bukan Map');
      data = {};
    }

    print('========================================');
  }

  // ============================================================
  // GETTER
  // ============================================================

  String get diagnosis {
    final value = data['diagnosis'];

    if (value == null) {
      return 'Tidak Diketahui';
    }

    final result = value.toString().trim();

    if (result.isEmpty) {
      return 'Tidak Diketahui';
    }

    return result;
  }

  double get confidence {
    final value = data['confidence'];

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  String get imageUrl {
    final value = data['image_url'];

    if (value == null) {
      return '';
    }

    return value.toString().trim();
  }

  String get handling {
    final value = data['handling'];

    if (value == null) {
      return 'Informasi penanganan belum tersedia.';
    }

    return value.toString().trim();
  }

  String get solution {
    final value = data['solution'];

    if (value == null) {
      return 'Informasi solusi belum tersedia.';
    }

    return value.toString().trim();
  }

  int? get id {
    final value = data['id'];

    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  String get createdAt {
    final value = data['created_at'];

    if (value == null) {
      return '';
    }

    return value.toString();
  }

  // ============================================================
  // DEBUG
  // ============================================================

  void debugData() {
    print('========================================');
    print('[ANALISIS POTENSI - CURRENT DATA]');
    print('data: $data');
    print('id: $id');
    print('diagnosis: $diagnosis');
    print('confidence: $confidence');
    print('imageUrl: $imageUrl');
    print('handling: $handling');
    print('solution: $solution');
    print('createdAt: $createdAt');
    print('========================================');
  }
}
