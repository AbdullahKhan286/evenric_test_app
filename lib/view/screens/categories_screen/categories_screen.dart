import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/product_controller.dart';
import '../../custom/custom_text_field/custom_text_field.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController searchController = TextEditingController();
  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    productController.fetchCategories();
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
        title: const Text('Categories'),
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
              hintText: 'Search categories',
              onchanged: (value) {
                productController.applyCategorySearchFilter(value);
              },
            ),
          ),
          16.verticalSpace,

          Obx(() => Text(
                "${productController.totalCategories} results found",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.grey,
                    ),
              )),
          10.verticalSpace,
          // Categories grid
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
                        onPressed: () => productController.fetchCategories(),
                        child: Text(
                          'Retry',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (productController.filteredCategories.isEmpty) {
                return Center(
                  child: Text(
                    'No categories found',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => productController.fetchCategories(),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                  ),
                  itemCount: productController.filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category =
                        productController.filteredCategories[index];
                    return InkWell(
                      onTap: () {
                        // Fetch products by category slug
                        productController
                            .fetchProductsByCategory(category.slug);
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                // Placeholder image for category
                                "https://cdn.pixabay.com/photo/2021/10/11/23/49/app-6702045_1280.png",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8.r),
                                  bottomRight: Radius.circular(8.r),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withAlpha(100),
                                  ],
                                ),
                              ),
                              width: double.infinity,
                              padding: EdgeInsets.all(10.r),
                              child: Text(
                                category.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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
}
