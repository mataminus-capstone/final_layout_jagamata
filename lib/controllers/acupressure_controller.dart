import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jagamata/models/acupressure_model.dart';
import 'package:jagamata/services/acupressure_audio_service.dart';

class AcupressureController extends ChangeNotifier {
  final AcupressureAudioService _audioService = AcupressureAudioService();

  // Kondisi mata (default: fatigued untuk backward compatibility)
  EyeCondition _condition = EyeCondition.fatigued;

  // Data titik dan konfigurasi
  late List<AcupressurePoint> _points;
  late TherapyConfig _config;

  int _currentIndex = 0;
  int _secondsLeft = 10;
  int _currentRepetition = 1;
  bool _isActive = false;
  bool _isFinished = false;
  Timer? _timer;

  // Getters
  AcupressurePoint get currentPoint => _points[_currentIndex];
  int get secondsLeft => _secondsLeft;
  bool get isActive => _isActive;
  bool get isFinished => _isFinished;
  EyeCondition get condition => _condition;
  TherapyConfig get config => _config;
  int get currentRepetition => _currentRepetition;
  int get totalPoints => _points.length;
  int get currentPointIndex => _currentIndex + 1;
  String get pressureLevel => _config.pressureLevel;

  // Constructor - Initialize with default
  AcupressureController() {
    _audioService.init();
    _initializeForCondition(EyeCondition.fatigued);
  }

  /// Set kondisi mata dan inisialisasi titik-titik yang sesuai
  void setCondition(EyeCondition condition) {
    _condition = condition;
    _initializeForCondition(condition);
    notifyListeners();
  }

  void _initializeForCondition(EyeCondition condition) {
    _points = getAcupressurePointsByCondition(condition);
    _config = getTherapyConfigByCondition(condition);
    _secondsLeft = _config.durationPerPoint;
  }

  void startSession() {
    _currentIndex = 0;
    _currentRepetition = 1;
    _isFinished = false;
    _isActive = true;
    _secondsLeft = _config.durationPerPoint;
    _audioService.playNextPointInstruction(currentPoint.instruction);
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
    _currentRepetition = 1;
    _secondsLeft = _config.durationPerPoint;
    _isActive = false;
    _isFinished = false;
    notifyListeners();
  }

  void _startTimer() {
    _secondsLeft = _config.durationPerPoint;
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

  Future<void> _nextStep() async {
    _timer?.cancel();
    await _audioService.playPointComplete();

    if (_currentIndex < _points.length - 1) {
      // Lanjut ke titik berikutnya
      _currentIndex++;
      await Future.delayed(const Duration(seconds: 2));
      await _audioService.playNextPointInstruction(currentPoint.instruction);
      _startTimer();
    } else {
      // Sudah selesai semua titik
      if (_currentRepetition < _config.repetitions) {
        // Masih ada pengulangan
        _currentRepetition++;
        _currentIndex = 0;
        await Future.delayed(const Duration(seconds: 3));
        await _audioService.playNextPointInstruction(
          "Pengulangan ke-$_currentRepetition. ${currentPoint.instruction}",
        );
        _startTimer();
      } else {
        // Semua selesai
        await _completeSession();
      }
    }
    notifyListeners();
  }

  Future<void> _completeSession() async {
    _isActive = false;
    _isFinished = true;
    await _audioService.playSessionComplete();
    notifyListeners();
  }

  /// Info summary untuk ditampilkan di hasil
  Map<String, dynamic> getSessionInfo() {
    return {
      'condition': _condition == EyeCondition.fatigued
          ? 'Mata Kelelahan'
          : 'Mata Normal',
      'totalPoints': _points.length,
      'durationPerPoint': _config.durationPerPoint,
      'repetitions': _config.repetitions,
      'pressureLevel': _config.pressureLevel,
      'description': _config.description,
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioService.dispose();
    super.dispose();
  }
}
