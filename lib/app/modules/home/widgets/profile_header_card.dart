import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wolf_pack/app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:wolf_pack/app/uitilies/app_colors.dart';
import 'package:wolf_pack/app/uitilies/app_images.dart';
import '../../../uitilies/custom_loader.dart';
import '../../profile/controllers/get_myProfile_controller.dart';
import '../../profile/controllers/porfile_image_controller.dart';
import '../controllers/nav_controller.dart';
import 'dash_board_content.dart';
import 'leauge_conatainer.dart';
import 'nav_button_wigets.dart';
import 'nav_item.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String username;
  final String rankText;

  ProfileHeaderCard({
    super.key,
    required this.username,
    required this.rankText,
  });

  final HomeImageController _imageController = Get.put(HomeImageController());
  final GetMyProfileController profileController = Get.put(GetMyProfileController());
  final NavController _navController = Get.put(NavController());

  final List<NavItem> navItems = [
    NavItem(
      label: 'Dashboard',
      iconPath: AppImages.dashboard,
      content: DashboardContent(),
    ),
    NavItem(
      label: 'Sales',
      iconPath: AppImages.sales,
      content: CustomText(text: "This is Sales UI", color: Colors.white),
    ),
    NavItem(
      label: 'Leaderboards',
      iconPath: AppImages.leaderboards,
      content: CustomText(text: "This is Leaderboards UI", color: Colors.white),
    ),
    NavItem(
      label: 'Badges',
      iconPath: AppImages.badges,
      content: CustomText(text: "This is Badges UI", color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40.h),
        Center(
          child: Obx(() {
            final imageUrl = profileController.profileData.value.data?.profilePicture?? '';
            final localImagePath = _imageController.selectedImagePath.value;

            if (localImagePath.isNotEmpty) {
              // Local picked image
              return CircleAvatar(
                radius: 55.r,
                backgroundColor: AppColors.orangeColor,
                backgroundImage: FileImage(File(localImagePath)),
              );
            } else if (imageUrl.isNotEmpty) {
              // Network image with cache
              return CircleAvatar(
                radius: 55.r,
                backgroundColor: AppColors.orangeColor,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 110.r,
                    height: 110.r,
                    fit: BoxFit.cover,

                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage(AppImages.noData),
                    ),
                  ),
                ),
              );
            } else {
              // Default placeholder
              return CircleAvatar(
                radius: 55.r,
                backgroundColor: AppColors.orangeColor,
                backgroundImage: const AssetImage(AppImages.profile),
              );
            }
          }),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: 160.w,
          child: LeagueContainer(
            text: rankText,
            imagePath: AppImages.medal,
            textColor: AppColors.orangeColor,
          ),
        ),
        SizedBox(height: 16.h),
        CustomText(
          text: username,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        SizedBox(height: 20.h),
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];
            return NavButton(
              label: item.label,
              iconPath: item.iconPath,
              isActive: _navController.activeTabIndex.value == index,
              onTap: () => _navController.changeTab(index),
            );
          }),
        )),
        SizedBox(height: 20.h),
      ],
    );
  }
}
