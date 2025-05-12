import 'package:evenric_app/config/constant/asset.dart';
import 'package:evenric_app/view/screens/categories_screen/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../favorite_screen/favorite_screen.dart';
import '../product_screen/product_screen.dart';
import '../profile_screen/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final RxInt _currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: bodyContent(),
        bottomNavigationBar: bottomNavigationBarContent(),
      ),
    );
  }

  Widget bodyContent() {
    return Obx(() {
      return IndexedStack(
        index: _currentIndex.value,
        children: [
          ProductScreen(),
          CategoriesScreen(),
          FavoriteScreen(),
          ProfileScreen(),
        ],
      );
    });
  }

  Widget bottomNavigationBarContent() {
    return Obx(() {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5.r),
        ),
        child: SizedBox(
          height: 90.h,
          child: BottomNavigationBar(
            currentIndex: _currentIndex.value,
            onTap: (value) => _currentIndex.value = value,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: Image.asset(Asset.productIcon, width: 20.w),
                ),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Image.asset(Asset.menuIcon, width: 20.w)),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Image.asset(Asset.favouriteIcon, width: 20.w)),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                    padding: EdgeInsets.only(bottom: 5.h),
                    child: Image.asset(Asset.personIcon, width: 20.w)),
                label: 'Profile',
              ),
            ],
          ),
        ),
      );
    });
  }
}
