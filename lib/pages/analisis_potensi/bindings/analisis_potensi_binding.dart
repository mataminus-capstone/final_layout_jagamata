import 'package:get/get.dart';

import '../controllers/analisis_potensi_controller.dart';

class AnalisisPotensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalisisPotensiController>(
      () => AnalisisPotensiController(),
    );
  }
}
