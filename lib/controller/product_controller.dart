import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:evenric_app/service/api_service.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../model/category.model.dart';
import '../model/product.model.dart';

class ProductController extends GetxController {
  final ApiService _apiService = ApiService.instance;

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Products data
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;

  // Categories data
  final RxList<Category> allCategories = <Category>[].obs;
  final RxList<Category> filteredCategories = <Category>[].obs;

  // Products by category
  final RxList<Product> productsByCategory = <Product>[].obs;
  final RxString selectedCategory = ''.obs;

  // Search queries
  final RxString productSearchQuery = ''.obs;
  final RxString categorySearchQuery = ''.obs;

  // Single product data
  final Rx<Product?> selectedProduct = Rx<Product?>(null);

  // Favorites data
  final RxList<Product> favorites = <Product>[].obs;

  // Computed values
  int get totalProducts => filteredProducts.length;
  int get totalCategories => filteredCategories.length;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCategories();
  }

  // Fetch all products
  Future<void> fetchProducts() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _apiService.getAllProducts();

      if (response.containsKey('products')) {
        final List<dynamic> productsData = response['products'];

        // Convert to Product objects with error handling
        final products = <Product>[];
        for (var item in productsData) {
          try {
            if (item is Map<String, dynamic>) {
              products.add(Product.fromJson(item));
            }
          } catch (e) {
            log("Error parsing product: $e");
          }
        }

        // Store products
        allProducts.value = products;

        // Apply any existing search filter or show all products
        if (productSearchQuery.value.isNotEmpty) {
          applyProductSearchFilter(productSearchQuery.value);
        } else {
          filteredProducts.value = products;
        }
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = _getErrorMessage(e);
      log("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all categories
  Future<void> fetchCategories() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _apiService.getProductCategories();

      // Convert to Category objects with error handling
      List<Category> categories = [];
      for (var item in response) {
        try {
          if (item is Map<String, dynamic>) {
            categories.add(Category.fromJson(item));
          }
        } catch (e) {
          log("Error parsing category: $e");
          // Continue with next category
        }
      }

      allCategories.value = categories;

      // Apply any existing search filter or show all categories
      if (categorySearchQuery.value.isNotEmpty) {
        applyCategorySearchFilter(categorySearchQuery.value);
      } else {
        filteredCategories.value = categories;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = _getErrorMessage(e);
      log("Error fetching categories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch products by category
  Future<void> fetchProductsByCategory(String categorySlug) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    selectedCategory.value = categorySlug;

    try {
      final response = await _apiService.getProductsByCategory(categorySlug);

      if (response.containsKey('products')) {
        final List<dynamic> productsData = response['products'];

        // Convert to Product objects with error handling
        final products = <Product>[];
        for (var item in productsData) {
          try {
            if (item is Map<String, dynamic>) {
              products.add(Product.fromJson(item));
            }
          } catch (e) {
            log("Error parsing product by category: $e");
            // Continue with next item
          }
        }

        productsByCategory.value = products;
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = _getErrorMessage(e);
      log("Error fetching products by category: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch product by ID
  Future<void> fetchProductById(int id) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _apiService.getProductById(id);

      selectedProduct.value = Product.fromJson(response);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = _getErrorMessage(e);
      log("Error fetching product by ID: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Local search filter for Products
  void applyProductSearchFilter(String query) {
    productSearchQuery.value = query;

    if (query.isEmpty) {
      filteredProducts.value = allProducts;
      return;
    }

    final searchLower = query.toLowerCase();
    final filtered = allProducts.where((product) {
      final title = product.title.toLowerCase();
      final description = product.description.toLowerCase();
      final brand = product.brand.toLowerCase();
      final category = product.category.toLowerCase();

      return title.contains(searchLower) ||
          description.contains(searchLower) ||
          brand.contains(searchLower) ||
          category.contains(searchLower);
    }).toList();

    filteredProducts.value = filtered;
  }

  // Local search filter for Categories
  void applyCategorySearchFilter(String query) {
    categorySearchQuery.value = query;

    if (query.isEmpty) {
      filteredCategories.value = allCategories;
      return;
    }

    final searchLower = query.toLowerCase();
    final filtered = allCategories.where((category) {
      final name = category.name.toLowerCase();
      final slug = category.slug.toLowerCase();

      return name.contains(searchLower) || slug.contains(searchLower);
    }).toList();

    filteredCategories.value = filtered;
  }

  // Add or remove product from favorites
  void addToFavorites(Product product) {
    if (isProductFavoriteById(product.id)) {
      // Remove from favorites
      favorites.removeWhere((p) => p.id == product.id);
    } else {
      // Add to favorites
      favorites.add(product);
    }
  }

  // Check if a product is in favorites
  bool isProductFavorite(Product product) {
    return favorites.any((p) => p.id == product.id);
  }

  // Check if a product is in favorites by ID
  bool isProductFavoriteById(int productId) {
    return favorites.any((p) => p.id == productId);
  }

  // Clear selected product
  void clearSelectedProduct() {
    selectedProduct.value = null;
  }

  // Helper method to get formatted error message
  String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please check your internet connection.';
        case DioExceptionType.badResponse:
          int? statusCode = error.response?.statusCode;
          if (statusCode == 404) {
            return 'Resource not found.';
          } else if (statusCode == 500) {
            return 'Server error. Please try again later.';
          }
          return 'Server error (${error.response?.statusCode}). Please try again.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        default:
          return 'Network error occurred. Please check your connection.';
      }
    } else if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    } else {
      return 'An unexpected error occurred: ${error.toString()}';
    }
  }
}
