import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/search_response_model.dart';
import '../config/global.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;

  void init() {
    _dio = Dio();

    _dio.options = BaseOptions(
      baseUrl: GlobalConfig.apiBaseUrl,
      connectTimeout: GlobalConfig.connectTimeout,
      receiveTimeout: GlobalConfig.receiveTimeout,
      sendTimeout: GlobalConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': GlobalConfig.userAgent,
      },
      // เพิ่มการตั้งค่าสำหรับ CORS และ network security
      validateStatus: (status) {
        return status != null && status >= 200 && status < 300;
      },
      followRedirects: true,
      maxRedirects: 3,
    );

    // เพิ่ม interceptor สำหรับ logging ในโหมด debug
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: true,
          logPrint: (object) {
            if (kDebugMode) {
              // ignore: avoid_print
              print('[API] $object');
            }
          },
        ),
      );
    }

    // เพิ่ม interceptor สำหรับ error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          if (kDebugMode) {
            print('[API Error] ${error.type}: ${error.message}');
            print('[API Error] URL: ${error.requestOptions.uri}');
            if (error.response != null) {
              print('[API Error] Status: ${error.response?.statusCode}');
              print('[API Error] Data: ${error.response?.data}');
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<SearchResponseModel> searchProducts({
    required String query,
    int offset = 0,
    int limit = 20,
    bool useAI = false,
  }) async {
    try {
      if (kDebugMode) {
        print(
          '[API] Vector searching for: "$query", offset: $offset, limit: $limit, AI: $useAI',
        );
      }

      final requestData = {'query': query, 'limit': limit, 'offset': offset};

      // เพิ่ม AI parameter ถ้าต้องการ
      if (useAI) {
        requestData['ai'] = true;
      }

      final response = await _dio.post(
        GlobalConfig.searchEndpoint,
        data: requestData,
      );

      if (response.statusCode == 200 && response.data != null) {
        return SearchResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = 'เกิดข้อผิดพลาดในการเชื่อมต่อ';

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่';
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = 'การส่งข้อมูลหมดเวลา กรุณาลองใหม่';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = 'การรับข้อมูลหมดเวลา กรุณาลองใหม่';
          break;
        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 404) {
            errorMessage = 'ไม่พบ API endpoint กรุณาตรวจสอบการตั้งค่า';
          } else if (e.response?.statusCode == 500) {
            errorMessage = 'เซิร์ฟเวอร์ขัดข้อง กรุณาลองใหม่ภายหลัง';
          } else {
            errorMessage =
                'เซิร์ฟเวอร์ตอบกลับผิดพลาด (${e.response?.statusCode})';
          }
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้';
          break;
        case DioExceptionType.badCertificate:
          errorMessage = 'ใบรับรองความปลอดภัยไม่ถูกต้อง';
          break;
        default:
          errorMessage = 'เกิดข้อผิดพลาด: ${e.message}';
      }

      if (kDebugMode) {
        print('[API Error Details] Type: ${e.type}');
        print('[API Error Details] Message: ${e.message}');
        print('[API Error Details] Response: ${e.response?.data}');
      }

      throw Exception(errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print('[API Unexpected Error] $e');
      }
      throw Exception('เกิดข้อผิดพลาดไม่คาดคิด: $e');
    }
  }

  /// ทดสอบการเชื่อมต่อ API
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get(
        GlobalConfig.healthEndpoint,
        options: Options(sendTimeout: GlobalConfig.healthCheckTimeout),
      );
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('[API Health Check] Failed: $e');
      }
      return false;
    }
  }

  /// ดึงข้อมูล API status
  Future<Map<String, dynamic>> getApiStatus() async {
    try {
      final response = await _dio.get(GlobalConfig.statusEndpoint);
      return response.data ?? {'status': 'unknown'};
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// รีเซ็ต Dio instance
  void reset() {
    init();
  }
}
