import 'package:get/get.dart';
import 'package:evenric_app/controller/product_controller.dart';

class ControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ProductController>(ProductController());
  }
}
