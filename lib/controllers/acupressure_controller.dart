import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jagamata/models/acupressure_model.dart';
import 'package:jagamata/services/acupressure_audio_service.dart';

class AcupressureController extends ChangeNotifier {
  final AcupressureAudioService _audioService =
      AcupressureAudioService(); // TAMBAHKAN INI

  int _currentIndex = 0;
  int _secondsLeft = 10;
  bool _isActive = false;
  bool _isFinished = false;
  Timer? _timer;

  AcupressurePoint get currentPoint => acupressureSequence[_currentIndex];
  int get secondsLeft => _secondsLeft;
  bool get isActive => _isActive;
  bool get isFinished => _isFinished;

  // TAMBAHKAN CONSTRUCTOR
  AcupressureController() {
    _audioService.init();
  }

  void startSession() {
    _currentIndex = 0;
    _isFinished = false;
    _isActive = true;
    _audioService.playNextPointInstruction(
      currentPoint.instruction,
    ); // TAMBAHKAN INI
    _startTimer();
    notifyListeners();
  }

  void pauseSession() {
    _timer?.cancel();
    _isActive = false;
    notifyListeners();
  }

  void resumeSession() {
    if (!_isFinished) {
      _isActive = true;
      _startTimer();
      notifyListeners();
    }
  }

  void stopSession() {
    _timer?.cancel();
    _isActive = false;
    _isFinished = true;
    notifyListeners();
  }

  void resetSession() {
    _timer?.cancel();
    _currentIndex = 0;
    _secondsLeft = 10;
    _isActive = false;
    _isFinished = false;
    notifyListeners();
  }

  void _startTimer() {
    _secondsLeft = 10;
    _timer?.cancel();
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        _secondsLeft--;
      } else {
        _nextStep();
      }
      notifyListeners();
    });
  }

  // GANTI MENJADI async
  Future<void> _nextStep() async {
    _timer?.cancel();
    await _audioService.playPointComplete(); // TAMBAHKAN await

    if (_currentIndex < acupressureSequence.length - 1) {
      _currentIndex++;
      await Future.delayed(const Duration(seconds: 2));
      await _audioService.playNextPointInstruction(
        currentPoint.instruction,
      ); // TAMBAHKAN
      _startTimer();
    } else {
      await _completeSession(); // GANTI MENJADI await
    }
    notifyListeners();
  }

  // GANTI MENJADI async
  Future<void> _completeSession() async {
    _isActive = false;
    _isFinished = true;
    await _audioService.playSessionComplete(); // TAMBAHKAN await
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioService.dispose(); // TAMBAHKAN INI
    super.dispose();
  }
}
