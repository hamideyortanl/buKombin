import 'package:flutter/material.dart';

class OnboardingIconAssets {

  static String? styleAsset(String label, String? gender, {bool hijab = false}) {
    final styleFile = _styleFileMap[label];
    if (styleFile == null) return null;

    final folder = (gender == 'male')
        ? 'male'
        : (hijab ? 'hijab' : 'female');

    return 'assets/images/onboarding/style/$folder/$styleFile';
  }

  static String? styleAssetPath({
    required String label,
    required String gender,
    bool hijab = false,
  }) {
    return styleAsset(label, gender, hijab: hijab);
  }

  static String? activityAsset(String label) {
    final f = _activityFileMap[label];
    if (f == null) return null;
    return 'assets/images/onboarding/activity/$f';
  }

  static String? activityAssetPath({required String label}) {
    return activityAsset(label);
  }

  static String emojiForStyle(String label, String gender) {
    switch (label) {
      case 'Klasik':
        return gender == 'male' ? '🤵' : '👗';
      case 'Sokak':
        return '🧢';
      case 'Minimal':
        return '⚪';
      case 'Bohem':
        return '🌸';
      case 'Spor Şık':
        return '👟';
      case 'Vintage':
        return gender == 'male' ? '🎩' : '👒';
      case 'Ofis':
        return '💼';
      case 'Elegant':
        return '✨';
      case 'Günlük':
        return gender == 'male' ? '👕' : '👚';
      default:
        return '✨';
    }
  }

  static String emojiForEvent(String label, String gender) {
    switch (label) {
      case 'İş':
        return '💼';
      case 'Okul':
        return '🎒';
      case 'Düğün':
        return '💍';
      case 'Kahve':
        return '☕';
      case 'Spor':
        return '🏃';
      case 'Seyahat':
        return '✈️';
      case 'Parti':
        return '🎉';
      case 'Günlük':
        return '🗓️';
      case 'Özel Davet':
        return '✨';
      default:
        return '📌';
    }
  }

  static const Map<String, String> _styleFileMap = {
    'Klasik': 'classic.jpg',
    'Sokak': 'streetwear.jpg',
    'Minimal': 'minimalist.jpg',
    'Bohem': 'bohem.jpg',
    'Spor Şık': 'sporty.jpg',
    'Vintage': 'vintage.jpg',
    'Ofis': 'office.jpg',
    'Elegant': 'elegant.jpg',
    'Günlük': 'casual.jpg',
  };

  static const Map<String, String> _activityFileMap = {
    'İş': 'business.jpg',
    'Okul': 'school.jpg',
    'Düğün': 'wedding.jpg',
    'Kahve': 'coffee.jpg',
    'Spor': 'sports.jpg',
    'Seyahat': 'travel.jpg',
    'Parti': 'party.jpg',
    'Günlük': 'daily.jpg',
    'Özel Davet': 'special_event.jpg',
  };
}
