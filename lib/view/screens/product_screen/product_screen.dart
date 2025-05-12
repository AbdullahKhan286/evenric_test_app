import 'package:evenric_app/config/constant/color.dart';
import 'package:evenric_app/config/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:evenric_app/controller/product_controller.dart';
import '../../custom/custom_text_field/custom_text_field.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productController.fetchProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      body: bodyContent(),
    );
  }

  Widget bodyContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          15.verticalSpace,
          // Search bar
          SizedBox(
            height: 40.h,
            child: CustomTextField(
              controller: searchController,
              hintText: 'Search',
              onchanged: (value) {
                productController.applyProductSearchFilter(value);
              },
            ),
          ),
          16.verticalSpace,

          Obx(() => Text(
                "${productController.totalProducts} results found",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey,
                    ),
              )),
          10.verticalSpace,
          // Product list
          Expanded(
            child: Obx(() {
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
                        onPressed: () => productController.fetchProducts(),
                        child: Text(
                          'Retry',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (productController.filteredProducts.isEmpty) {
                return Center(
                  child: Text(
                    'No products found',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => productController.fetchProducts(),
                child: ListView.builder(
                  itemCount: productController.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = productController.filteredProducts[index];
                    return Card(
                      elevation: 4,
                      color: Colors.transparent,
                      margin: EdgeInsets.only(bottom: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: InkWell(
                        onTap: () => Get.toNamed(RouteName.productDetailScreen,
                            arguments: {'productId': product.id}),
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product image
                              Container(
                                height: 180.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.r),
                                  image: DecorationImage(
                                    image: NetworkImage(product.thumbnail),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              10.verticalSpace,

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text("\$${product.price.toStringAsFixed(0)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                ],
                              ),
                              5.verticalSpace,

                              Row(
                                children: [
                                  Text(
                                    product.rating.toStringAsFixed(1),
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  SizedBox(width: 5.w),
                                  _buildRatingStars(product.rating),
                                ],
                              ),
                              5.verticalSpace,
                              Text("By ${product.brand}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: greyColor,
                                      )),
                              5.verticalSpace,

                              Text(
                                "In ${product.category}",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
