import 'package:get/get.dart';

import '../controllers/analisis_kelelahan_controller.dart';

class AnalisisKelelahanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalisisKelelahanController>(
      () => AnalisisKelelahanController(),
    );
  }
}
