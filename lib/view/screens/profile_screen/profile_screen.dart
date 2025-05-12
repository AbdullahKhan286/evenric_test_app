import 'package:evenric_app/config/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: bodyContent(context),
    );
  }

  Widget bodyContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32.r,
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150?img=1"),
                    backgroundColor: greyColor,
                  ),
                  16.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Abdullah Khan', // Hardcoded name as per requirements
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.white),
                      ),
                      4.verticalSpace,
                      Text(
                        'abdullahkhan@gmail.com',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white),
                      ),
                      2.verticalSpace,
                      Text(
                        '07XXXXXXXX',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          64.verticalSpace,
          Column(
            children: [
              _buildMenuItem(
                icon: Icons.settings,
                title: 'Kontoinställningar',
                onTap: () {},
              ),
              SizedBox(height: 16.h),
              _buildMenuItem(
                icon: Icons.payment,
                title: 'Mina betalmetoder',
                onTap: () {},
              ),
              SizedBox(height: 16.h),
              _buildMenuItem(
                icon: Icons.support,
                title: 'Support',
                onTap: () {
                  // Handle navigation
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 28.w),
        child: Row(
          children: [
            Icon(icon, size: 24.sp),
            16.horizontalSpace,
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
