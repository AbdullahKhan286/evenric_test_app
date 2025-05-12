import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/constant/color.dart';
import '../../../config/routes/routes_name.dart';
import '../../../controller/product_controller.dart';
import '../../../model/product.model.dart';
import '../../custom/custom_text_field/custom_text_field.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController searchController = TextEditingController();
  RxList<Product> displayedFavorites = <Product>[].obs;

  @override
  void initState() {
    super.initState();
    displayedFavorites.value = productController.favorites;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchFavorites(String query) {
    if (query.isEmpty) {
      displayedFavorites.value = productController.favorites;
      return;
    }

    final searchLower = query.toLowerCase();
    final filtered = productController.favorites.where((product) {
      final title = product.title.toLowerCase();
      final description = product.description.toLowerCase();
      final brand = product.brand.toLowerCase();
      final category = product.category.toLowerCase();

      return title.contains(searchLower) ||
          description.contains(searchLower) ||
          brand.contains(searchLower) ||
          category.contains(searchLower);
    }).toList();

    displayedFavorites.value = filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: bodyContent(context),
    );
  }

  Widget bodyContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          // Search bar
          SizedBox(
            height: 40.h,
            child: CustomTextField(
              controller: searchController,
              hintText: 'Search favorites',
              onchanged: searchFavorites,
            ),
          ),
          16.verticalSpace,

          // Favorites list
          Expanded(
            child: Obx(() {
              // Update displayed favorites whenever the main favorites list changes
              if (searchController.text.isEmpty) {
                displayedFavorites.value = productController.favorites;
              }

              if (productController.favorites.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64.r,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No favorites yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Add products to your favorites by tapping the heart icon on product details',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                );
              }

              // If search is active but no results
              if (searchController.text.isNotEmpty &&
                  displayedFavorites.isEmpty) {
                return Center(
                  child: Text(
                    'No favorites match your search',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return ListView.builder(
                itemCount: displayedFavorites.length,
                itemBuilder: (context, index) {
                  final product = displayedFavorites[index];
                  return Card(
                    elevation: 2,
                    color: greyColor.withAlpha(17),
                    margin: EdgeInsets.only(bottom: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: InkWell(
                      onTap: () => Get.toNamed(RouteName.productDetailScreen,
                          arguments: {'productId': product.id}),
                      child: Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Row(
                          children: [
                            // Product image (circular)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50.r),
                              child: Container(
                                width: 80.r,
                                height: 80.r,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                                child: Image.network(
                                  product.thumbnail,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.image_not_supported,
                                      size: 40.r,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            // Product info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '\$${product.price.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Text(
                                        product.rating.toStringAsFixed(1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      SizedBox(width: 4.w),
                                      _buildRatingStars(product.rating),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Remove favorite button
                            IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () {
                                productController.addToFavorites(product);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.amber, size: 16.r);
        } else if (index == fullStars && hasHalfStar) {
          return Icon(Icons.star_half, color: Colors.amber, size: 16.r);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: 16.r);
        }
      }),
    );
  }
}
