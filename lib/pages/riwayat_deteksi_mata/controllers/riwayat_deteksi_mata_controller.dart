import 'package:get/get.dart';

class RiwayatDeteksiMataController extends GetxController {
  // 0 = Potensi Penyakit
  // 1 = Kelelahan Mata
  final selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }
}