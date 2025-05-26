import 'api_service.dart';

class ServiceProvider {
  static late final ApiService _apiService;

  static ApiService get apiService => _apiService;

  static Future<void> initialize() async {
    _apiService = ApiService();
    // Add any other service initializations here
  }
}
