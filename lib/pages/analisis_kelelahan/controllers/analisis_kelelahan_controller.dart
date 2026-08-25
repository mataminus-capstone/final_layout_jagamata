import 'package:get/get.dart';

class AnalisisKelelahanController extends GetxController {
  final isPusing = true.obs;

  void togglePusing(bool? value) {
    isPusing.value = value ?? false;
  }

  void mulaiTerapi() {
    if (isPusing.value) {
      // Jika pusing → Terapi Khusus
      Get.toNamed('/terapi-khusus');
    } else {
      // Jika tidak pusing → Terapi
      Get.toNamed('/terapi');
    }
  }
}