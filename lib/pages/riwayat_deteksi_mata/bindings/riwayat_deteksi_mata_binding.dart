import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:jagamata/pages/riwayat_deteksi_mata/controllers/riwayat_deteksi_mata_controller.dart';

class RiwayatDeteksiMataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatDeteksiMataController>(
      () => RiwayatDeteksiMataController(),
    );
  }
}