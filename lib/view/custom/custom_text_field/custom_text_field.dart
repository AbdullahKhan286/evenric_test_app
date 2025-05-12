import 'package:evenric_app/config/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Custom TextField Widget
class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isEnable;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final String? labelingText;
  final Function(String)? onchanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isEnable = true,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.prefixIcon,
    this.labelingText,
    this.onchanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: isEnable,
      onChanged: onchanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelMedium,
        prefix: prefixIcon != null
            ? Padding(padding: EdgeInsets.only(right: 10.w), child: prefixIcon)
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: primaryColor, width: 2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: primaryColor, width: 2)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      ),
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}
