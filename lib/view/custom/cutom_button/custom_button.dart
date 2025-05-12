// import 'package:evenric_app/config/constant/color.dart';
// import 'package:evenric_app/view/custom/custom_text/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomButton extends StatelessWidget {
//   final double width;
//   final double height;
//   final String text;
//   final Color color;
//   final Color borderColor;
//   final double borderRadius;
//   final Color textColor;
//   final double fontSize;
//   final VoidCallback? onTap;

//   const CustomButton({
//     super.key,
//     this.width = double.infinity,
//     this.height = 48,
//     required this.text,
//     this.color = buttonprimaryColor,
//     this.borderColor = Colors.transparent,
//     this.borderRadius = 8,
//     this.textColor = whiteColor,
//     this.fontSize = 16,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap ?? () {},
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(borderRadius.r),
//           border: Border.all(color: borderColor),
//         ),
//         child: Center(
//           child: CustomText(
//             text: text,
//             color: textColor,
//             fontSize: fontSize.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
