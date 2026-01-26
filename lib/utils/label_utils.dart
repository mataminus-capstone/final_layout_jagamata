/// Helper utilities untuk aplikasi JagaMata

/// Menerjemahkan label kelelahan dari API ke bahasa Indonesia
/// "Drowsy" -> "Kelelahan"
/// "Non Drowsy" -> "Tidak Kelelahan"
String translateDrowsinessLabel(String? originalLabel) {
  if (originalLabel == null || originalLabel.isEmpty) {
    return 'Tidak diketahui';
  }

  final String labelLower = originalLabel.toLowerCase().trim();

  // Check for Non Drowsy / Not Drowsy / Awake variations
  if (labelLower.contains('non') ||
      labelLower.contains('not') ||
      labelLower.contains('awake') ||
      labelLower.contains('alert') ||
      labelLower.contains('normal')) {
    return 'Tidak Kelelahan';
  }

  // Check for Drowsy / Fatigue / Tired variations
  if (labelLower.contains('drowsy') ||
      labelLower.contains('fatigue') ||
      labelLower.contains('tired') ||
      labelLower.contains('sleepy')) {
    return 'Kelelahan';
  }

  // Already in Indonesian
  if (labelLower.contains('tidak kelelahan') ||
      labelLower.contains('tidak lelah') ||
      labelLower.contains('segar')) {
    return 'Tidak Kelelahan';
  }

  if (labelLower.contains('kelelahan') ||
      labelLower.contains('lelah') ||
      labelLower.contains('kantuk') ||
      labelLower.contains('ngantuk')) {
    return 'Kelelahan';
  }

  // Return original if no match
  return originalLabel;
}

/// Mengecek apakah label menunjukkan kondisi kelelahan
bool isDrowsinessLabelFatigued(String? label) {
  if (label == null || label.isEmpty) return false;

  final String labelLower = label.toLowerCase().trim();

  // First check for NON-fatigued indicators
  final bool isNotFatigued =
      labelLower.contains('non') ||
      labelLower.contains('not') ||
      labelLower.contains('tidak') ||
      labelLower.contains('awake') ||
      labelLower.contains('normal') ||
      labelLower.contains('segar') ||
      labelLower.contains('alert');

  // Check for fatigue indicators
  final bool hasFatigueKeyword =
      labelLower.contains('drowsy') ||
      labelLower.contains('fatigue') ||
      labelLower.contains('tired') ||
      labelLower.contains('kantuk') ||
      labelLower.contains('lelah') ||
      labelLower.contains('kelelahan') ||
      labelLower.contains('ngantuk');

  // Fatigued only if has fatigue keyword AND not marked as non-fatigued
  return hasFatigueKeyword && !isNotFatigued;
}
