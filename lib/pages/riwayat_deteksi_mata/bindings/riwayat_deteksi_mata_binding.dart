import 'package:get/get.dart';

import '../controllers/riwayat_deteksi_mata_controller.dart';

class RiwayatDeteksiMataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatDeteksiMataController>(
      () => RiwayatDeteksiMataController(),
    );
  }
}