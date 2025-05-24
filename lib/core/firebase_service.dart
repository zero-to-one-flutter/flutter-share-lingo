// firebase analytics 전역 인스턴스화
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseService {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
}
