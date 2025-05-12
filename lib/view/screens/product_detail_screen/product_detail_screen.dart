import 'package:evenric_app/config/constant/color.dart';
import 'package:evenric_app/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductController productController = Get.find<ProductController>();
  late int productId;

  @override
  void initState() {
    super.initState();
    productId = Get.arguments['productId'];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.fetchProductById(productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blackColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productController.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${productController.errorMessage.value}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.red),
                ),
                16.verticalSpace,
                ElevatedButton(
                  onPressed: () =>
                      productController.fetchProductById(productId),
                  child: Text(
                    'Retry',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          );
        }

        final product = productController.selectedProduct.value;
        if (product == null) {
          return const Center(
            child: Text('Product not found'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: NetworkImage(product.thumbnail),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Product Details
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Product Details:',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        // Favorite Button
                        IconButton(
                          icon: Icon(
                            productController.isProductFavoriteById(product.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                            size: 30.r,
                          ),
                          onPressed: () {
                            productController.addToFavorites(product);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Name
                    _buildDetailRow(
                      context,
                      'Name:',
                      product.title,
                    ),
                    SizedBox(height: 12.h),

                    // Price
                    _buildDetailRow(
                      context,
                      'Price:',
                      '\$${product.price.toStringAsFixed(0)}',
                    ),
                    SizedBox(height: 12.h),

                    // Category
                    _buildDetailRow(
                      context,
                      'Category:',
                      product.category,
                    ),
                    SizedBox(height: 12.h),

                    // Brand
                    _buildDetailRow(
                      context,
                      'Brand:',
                      product.brand,
                    ),
                    SizedBox(height: 12.h),

                    // Rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Rating:',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(width: 8.w),
                        Row(
                          children: List.generate(5, (index) {
                            if (index < product.rating.floor()) {
                              return Icon(Icons.star,
                                  color: Colors.amber, size: 20.r);
                            } else if (index == product.rating.floor() &&
                                product.rating % 1 > 0) {
                              return Icon(Icons.star_half,
                                  color: Colors.amber, size: 20.r);
                            } else {
                              return Icon(Icons.star_border,
                                  color: Colors.amber, size: 20.r);
                            }
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Stock
                    _buildDetailRow(
                      context,
                      'Stock:',
                      product.stock.toString(),
                    ),
                    SizedBox(height: 12.h),

                    // Description
                    Text(
                      'Description:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 24.h),

                    // Product Gallery
                    Text(
                      'Product Gallery:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16.h),
                    _buildProductGallery(product.images),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildProductGallery(List<String> images) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1.2,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            images[index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.grey[700],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
