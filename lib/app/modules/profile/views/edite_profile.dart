import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wolf_pack/app/common%20widget/custom_app_bar_widget.dart';

import 'package:wolf_pack/app/modules/home/controllers/image_controller.dart';

import 'package:wolf_pack/app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:wolf_pack/app/modules/onboarding/widgets/row_button_widgets.dart';
import 'package:wolf_pack/app/uitilies/app_colors.dart';
import 'package:wolf_pack/app/uitilies/app_images.dart';

import '../../../common widget/custom_text_filed.dart';
import '../../edit_profile/controllers/edit_profile_controller.dart';
import '../../edit_profile/controllers/edite_prifile_controller_sp.dart';
import '../controllers/update_profile_controller.dart';



class EditProfileView extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String about;

  EditProfileView({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.about,
  });

  final EditProfileImageController _imageController =
  Get.put(EditProfileImageController());
  final ProfileUpdateController _profileController =
  Get.put(ProfileUpdateController());

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phone);
    final aboutController = TextEditingController(text: about);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CommonAppBar(title: 'Edit Profile'),
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
                      backgroundImage:
                      _imageController.selectedImagePath.value.isEmpty
                          ? const AssetImage(AppImages.noData)
                          : FileImage(
                          File(_imageController.selectedImagePath.value))
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
                                  onTap: () =>
                                      Navigator.pop(context, ImageSource.camera),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Gallery'),
                                  onTap: () =>
                                      Navigator.pop(context, ImageSource.gallery),
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
            Gap(20.h),
            buildField("Name", nameController),
            buildField("Email address", emailController),
            buildField("Phone Number", phoneController),
            buildField("About Yourself", aboutController, maxLines: 5),
            Gap(10.h),
            RowButtonWidgets(
              buttonName1: 'Cancel',
              buttonName2: 'Save Changes',
              onTapCancel: () {
                Get.back();
              },
              onTapSave: () {
                _profileController.updateUserProfile(
                  name: nameController.text,
                  about: aboutController.text,
                  phoneNumber: phoneController.text,
                  imagePath: _imageController.selectedImagePath.value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.white.withOpacity(0.8),
        ),
        Gap(5.h),
        CustomTextField(
          hintText: label,
          controller: controller,
          showObscure: false,
          maxLines: maxLines,
        ),
        Gap(10.h),
      ],
    );
  }
}
