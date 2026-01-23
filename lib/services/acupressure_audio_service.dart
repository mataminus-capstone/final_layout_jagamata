import 'package:flutter_tts/flutter_tts.dart';

class AcupressureAudioService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> init() async {
    await _flutterTts.setLanguage('id-ID');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.4); // Lebih lambat agar jelas
  }

  Future<void> playNextPointInstruction(String instruction) async {
    await _flutterTts.speak(instruction); // Langsung speak instruksi lengkap
  }

  Future<void> playPointComplete() async {
    await _flutterTts.speak('Lanjut ke titik berikutnya');
  }

  Future<void> playSessionComplete() async {
    await _flutterTts.speak('Selamat! Terapi selesai.');
  }

  void dispose() {
    _flutterTts.stop();
  }
}
