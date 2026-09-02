import 'package:flutter/material.dart';

class TranslationService {
  static final ValueNotifier<String> localeNotifier = ValueNotifier<String>('en');

  static String get currentLanguage => localeNotifier.value;

  static void toggleLanguage() {
    localeNotifier.value = localeNotifier.value == 'en' ? 'hi' : 'en';
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'dashboard': 'Dashboard',
      'prices': 'Prices',
      'price_ai': 'Price AI',
      'market': 'Market',
      'profile': 'Profile',
      'ai_bot': 'AI Bot',
      'weather': 'Weather',
      'map': 'Map',
      'crop_connect': 'Crop Connect',
      'mandi_prices': 'Mandi Prices',
      'favorites': 'My Favorites',
      'no_favorites': 'No Favorite Crops',
      'login': 'LOGIN',
      'register': 'Register',
      'logout': 'LOGOUT',
      'create_account': 'Create Account',
      'forgot_password': 'Forgot Password?',
      'full_name': 'Full Name',
      'email': 'Email',
      'mobile_number': 'Mobile Number',
      'password': 'Password',
      'submit_listing': 'Submit Listing',
      'crop_name': 'Crop Name',
      'quantity': 'Quantity',
      'price_qtl': 'Price Per Quintal',
      'location': 'Location',
      'buy': 'Buy',
      'sell': 'Sell',
      'orders': 'Orders',
      'disease_detection': 'Crop Disease Detection',
      'detect_disease': 'Detect Disease',
      'upload_leaf': 'Upload a crop leaf image',
      'nearby_markets': 'Nearby Markets',
      'predicted_price': 'Predicted price',
      'price_predict_btn': 'Predict Price',
      'crop_price_ai': 'Crop Price AI',
      'weather_clouds': 'Partly Cloudy',
      'export_report': 'Export PDF Report',
      'change_language': 'हिन्दी (Hindi)',
    },
    'hi': {
      'dashboard': 'डैशबोर्ड',
      'prices': 'कीमतें',
      'price_ai': 'कीमत अनुमान',
      'market': 'बाज़ार',
      'profile': 'प्रोफ़ाइल',
      'ai_bot': 'एआई बॉट',
      'weather': 'मौसम',
      'map': 'नक्शा',
      'crop_connect': 'क्रॉप कनेक्ट',
      'mandi_prices': 'मंडी भाव',
      'favorites': 'पसंदीदा फसलें',
      'no_favorites': 'कोई पसंदीदा फसल नहीं है',
      'login': 'लॉगिन',
      'register': 'रजिस्टर',
      'logout': 'लॉगआउट',
      'create_account': 'खाता बनाएं',
      'forgot_password': 'पासवर्ड भूल गए?',
      'full_name': 'पूरा नाम',
      'email': 'ईमेल',
      'mobile_number': 'मोबाइल नंबर',
      'password': 'पासवर्ड',
      'submit_listing': 'फसल की सूची जमा करें',
      'crop_name': 'फसल का नाम',
      'quantity': 'मात्रा (क्विंटल)',
      'price_qtl': 'मूल्य प्रति क्विंटल',
      'location': 'स्थान',
      'buy': 'खरीदें',
      'sell': 'बेचें',
      'orders': 'ऑर्डर',
      'disease_detection': 'फसल रोग पहचान',
      'detect_disease': 'रोग की पहचान करें',
      'upload_leaf': 'फसल की पत्ती का चित्र अपलोड करें',
      'nearby_markets': 'आस-पास के बाज़ार',
      'predicted_price': 'अनुमानित मूल्य',
      'price_predict_btn': 'कीमत का अनुमान लगाएं',
      'crop_price_ai': 'फसल मूल्य अनुमान',
      'weather_clouds': 'आंशिक रूप से बादल छाए रहेंगे',
      'export_report': 'पीडीएफ रिपोर्ट डाउनलोड करें',
      'change_language': 'English (अंग्रेज़ी)',
    }
  };

  static String translate(String key) {
    return _localizedValues[localeNotifier.value]?[key] ?? key;
  }
}
