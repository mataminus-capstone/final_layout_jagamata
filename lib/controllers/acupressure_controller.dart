import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jagamata/models/acupressure_model.dart';

class AcupressureController extends ChangeNotifier {
  int _currentIndex = 0;
  int _secondsLeft = 10;
  bool _isActive = false;
  bool _isFinished = false;
  Timer? _timer;

  AcupressurePoint get currentPoint => acupressureSequence[_currentIndex];
  int get secondsLeft => _secondsLeft;
  bool get isActive => _isActive;
  bool get isFinished => _isFinished;

  void startSession() {
    _currentIndex = 0;
    _isFinished = false;
    _isActive = true;
    _startTimer();
    notifyListeners();
  }

  void stopSession() {
    _timer?.cancel();
    _isActive = false;
    notifyListeners();
  }

  void _startTimer() {
    _secondsLeft = 10;
    _timer?.cancel();
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        _secondsLeft--;
        notifyListeners();
      } else {
        _nextStep();
      }
    });
  }

  void _nextStep() {
    _timer?.cancel();
    if (_currentIndex < acupressureSequence.length - 1) {
      _currentIndex++;
      _startTimer();
    } else {
      _isActive = false;
      _isFinished = true;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}