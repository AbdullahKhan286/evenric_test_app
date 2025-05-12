import 'package:dio/dio.dart';
import 'package:evenric_app/service/dio_service.dart';

class ApiService {
  ApiService._private();
  static final ApiService _instance = ApiService._private();
  static ApiService get instance => _instance;

  final Dio _dio = DioService.instance.dio;

  // Get all products
  Future<Map<String, dynamic>> getAllProducts() async {
    try {
      final response = await _dio.get('/products');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Get all product categories
  Future<List<dynamic>> getProductCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Get products by category
  Future<Map<String, dynamic>> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get('/products/category/$category');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Get product by ID
  Future<Map<String, dynamic>> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Search products
  Future<Map<String, dynamic>> searchProducts(String query) async {
    try {
      final response =
          await _dio.get('/products/search', queryParameters: {'q': query});
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      // Handle Dio specific errors
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timed out');
        case DioExceptionType.badResponse:
          return Exception('Server error: ${error.response?.statusCode}');
        case DioExceptionType.cancel:
          return Exception('Request cancelled');
        default:
          return Exception('Network error occurred');
      }
    }
    return Exception('Something went wrong: $error');
  }
}
