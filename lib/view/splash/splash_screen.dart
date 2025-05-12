import 'package:evenric_app/config/constant/color.dart';
import 'package:evenric_app/config/constant/asset.dart';
import 'package:evenric_app/config/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// A beautifully animated splash screen that serves as the entry point to the application.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupNavigation();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupNavigation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_hasNavigated) {
        _hasNavigated = true;
        Get.offAllNamed(RouteName.mainScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            SafeArea(
              child: Column(
                children: [
                  // Animated title
                  40.verticalSpace,
                  SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      'My Store',
                      style: GoogleFonts.playfairDisplay(
                        color: blackColor,
                        fontSize: 62.sp,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 3.0,
                            color: Colors.black.withAlpha(70),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Animated subtitle and description
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Valkommen',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: whiteColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                        20.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Text(
                            'Hos ass kan du baka tid has nastan alla Sveriges salonger och motagningar. Baka frisor, massage, skonhetsbehandingar, friskvard och mycket mer.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: whiteColor,
                                  fontSize: 12.sp,
                                  height: 1.5,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom spacing
                  SizedBox(height: 0.15.sh),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Image.asset(
      Asset.splashBG,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: primaryColor,
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              color: Colors.white.withAlpha(100),
              size: 50.r,
            ),
          ),
        );
      },
    );
  }
}
