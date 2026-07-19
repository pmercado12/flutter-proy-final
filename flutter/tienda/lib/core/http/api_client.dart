import 'package:dio/dio.dart';
import '../config/api_config.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {"Content-Type": "application/json"},
    ),
  );
}
