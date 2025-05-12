import 'package:evenric_app/config/routes/routes_name.dart';
import 'package:evenric_app/view/splash/splash_screen.dart';
import 'package:get/get.dart';
import '../../view/screens/main/main_screen.dart';
import '../../view/screens/product_detail_screen/product_detail_screen.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(name: RouteName.splashScreen, page: () => const SplashScreen()),
        GetPage(name: RouteName.mainScreen, page: () => const MainScreen()),
        GetPage(
          name: RouteName.productDetailScreen,
          page: () => const ProductDetailScreen(),
        )
      ];
}
