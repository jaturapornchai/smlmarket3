import 'package:flutter/foundation.dart';

/// Global configuration for SML Market app
class GlobalConfig {
  // กำหนด base URL ตามโหมด debug/release
  static String get apiBaseUrl {
    return kDebugMode
        ? 'http://localhost:8008/v1/'
        : 'https://smlgoapi.dedepos.com/v1/';
  }

  // API endpoints
  static const String searchEndpoint = 'search-by-vector';
  static const String pgSelectEndpoint = 'pgselect';
  static const String pgCommandEndpoint = 'pgcommand';
  static const String clickHouseCommandEndpoint = 'command';
  static const String healthEndpoint = 'health';
  static const String statusEndpoint = 'status';

  // App configuration
  static const String appName = 'SML Market';
  static const String appVersion = '1.0.0';
  static const String userAgent = 'SMLMarket/1.0.0';

  // API timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const Duration healthCheckTimeout = Duration(seconds: 10);

  // Pagination
  static const int defaultPageSize = 100;
  static const int maxPageSize = 100;

  // UI Constants
  static const double minCardWidth = 160.0;
  static const double productCardHeight = 280.0;
}
