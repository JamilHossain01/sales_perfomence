import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:wolf_pack/app/common%20widget/gradient.dart';
import 'package:wolf_pack/app/modules/profile/controllers/get_myProfile_controller.dart';
import 'package:wolf_pack/app/modules/profile/controllers/porfile_image_controller.dart';
import 'package:wolf_pack/app/modules/profile/controllers/profile_controller.dart';
import 'package:wolf_pack/app/modules/profile/views/about_us.dart';
import 'package:wolf_pack/app/modules/profile/views/edite_profile.dart';
import 'package:wolf_pack/app/modules/profile/views/privacy_policy.dart';
import 'package:wolf_pack/app/modules/profile/views/setting.dart';
import 'package:wolf_pack/app/modules/profile/views/terms_of_use_view.dart';
import 'package:wolf_pack/app/uitilies/app_images.dart';

import '../../../common widget/custom_app_bar_widget.dart';
import '../../../common widget/custom_button.dart';
import '../../../common widget/show_alert_dialog.dart';
import '../../../uitilies/app_colors.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../edit_profile/controllers/edite_prifile_controller_sp.dart';
import '../../pet_profile/widgets/infow_row_widgets.dart';

class ProfileView extends GetView<ProfileController> {
   ProfileView({super.key});

  @override
  final EditProfileImageController _imageController = Get.put(EditProfileImageController());
   final GetMyProfileController profileController = Get.put(GetMyProfileController());


   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.black,
       appBar: CommonAppBar(title: 'Profile'),
       body: SingleChildScrollView(
         padding: EdgeInsets.all(16.w),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Center(
               child: Obx(() {
                 return Stack(
                   alignment: Alignment.bottomRight,
                   children: [
                     CircleAvatar(
                       backgroundColor: AppColors.orangeColor,
                       radius: 55.r,
                       backgroundImage: _imageController.selectedImagePath.value.isEmpty
                           ? const AssetImage(AppImages.noData)
                           : FileImage(File(_imageController.selectedImagePath.value))
                       as ImageProvider,
                     ),
                     GestureDetector(
                       onTap: () async {
                         final source = await showModalBottomSheet<ImageSource>(
                           context: context,
                           builder: (_) => SafeArea(
                             child: Wrap(
                               children: [
                                 ListTile(
                                   leading: const Icon(Icons.camera_alt),
                                   title: const Text('Camera'),
                                   onTap: () => Navigator.pop(context, ImageSource.camera),
                                 ),
                                 ListTile(
                                   leading: const Icon(Icons.photo_library),
                                   title: const Text('Gallery'),
                                   onTap: () => Navigator.pop(context, ImageSource.gallery),
                                 ),
                               ],
                             ),
                           ),
                         );

                         if (source != null) {
                           await _imageController.pickImage(source);
                         }
                       },
                       child: Container(
                         padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           color: AppColors.orangeColor,
                         ),
                         child: Image.asset(
                           AppImages.edit,
                           height: 20.h,
                           width: 20.w,
                           color: Colors.black,
                         ),
                       ),
                     ),
                   ],
                 );
               }),
             ),
             Gap(40.h),

             Container(
               decoration: BoxDecoration(
                   color: Colors.black.withOpacity(0.09),
                   border: Border.all(color: AppColors.orangeColor),
                   borderRadius: BorderRadius.circular(12.r)),
               child: Padding(
                 padding:
                 const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                 child: Column(
                   children: [
                     InfoRow(
                       title: 'Name',
                       value:  profileController.profileData.value.data?.name ?? 'N/A',
                       iconBgColor: AppColors.borderColor,
                     ),
                     Gap(12.h),
                     InfoRow(
                       title: 'Email address',
                       value:  profileController.profileData.value.data?.email ?? 'N/A',
                       iconBgColor: AppColors.borderColor,
                     ),
                     Gap(12.h),
                     InfoRow(
                       title: 'Phone Number',
                       value:  profileController.profileData.value.data?.phoneNumber ?? 'N/A',
                       iconBgColor: AppColors.borderColor,
                     ),
                     Gap(12.h),
                     InfoRow(
                       title: 'About Yourself',
                       value: profileController.profileData.value.data?.about ?? 'N/A',
                       iconBgColor: AppColors.borderColor,
                     ),
                   ],
                 ),
               ),
             ),
             Gap(4.h),
             Gap(40.h),
             CustomButton(
               ImageColor: AppColors.white,
               imagePath: AppImages.edit,

               border: Border.all(color: AppColors.orangeColor),
               buttonColor: AppColors.orangeColor,
               isGradient: false,
               titleColor: AppColors.white,
               title: 'Edit Profile',
               onTap: () {
                 // Get.to(() => EditProfileView());
                 // if (_formKey.currentState!.validate()) {
                 //   if (selectedGender == null) {
                 //     Get.snackbar('Error', 'Please select gender',
                 //         snackPosition: SnackPosition.BOTTOM);
                 //     return;
                 //   }
                 //   if (selectedDate == null) {
                 //     Get.snackbar('Error', 'Please select date of birth',
                 //         snackPosition: SnackPosition.BOTTOM);
                 //     return;
                 //   }
                 //   // Proceed with save logic here
                 // }
               },
             ),
           ],
         ),
       ),
     );
   }
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Color(0xFF666666)),
      title: Text(
        title,
        style: TextStyle(color: textColor ??  Color(0xFF484848), fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
