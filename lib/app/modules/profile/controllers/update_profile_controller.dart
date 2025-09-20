import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:wolf_pack/app/modules/dashboard/views/dashboard_view.dart';
import '../../../common widget/customSnackBar.dart';
import '../../../uitilies/api/api_url.dart';
import '../../../uitilies/api/app_constant.dart';
import '../../../uitilies/api/local_storage.dart';

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wolf_pack/app/modules/dashboard/views/dashboard_view.dart';
import '../../../common widget/customSnackBar.dart';
import '../../../uitilies/api/api_url.dart';
import '../../../uitilies/api/app_constant.dart';
import '../../../uitilies/api/local_storage.dart';

class ProfileUpdateController extends GetxController {
  var isLoading = false.obs;
  final StorageService _storageService = Get.put(StorageService());

  Future<void> updateUserProfile({
    required String name,
    required String about,
    required String phoneNumber,
    required String imagePath,
  }) async {
    isLoading(true);

    try {
      final token = await _storageService.read(AppConstant.accessToken);
      final uri = Uri.parse(ApiUrl.updateProfile);

      final request = http.MultipartRequest('PATCH', uri);

      // headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // text fields
      request.fields['data'] = jsonEncode({
        "name": name,
        "about": about,
        "phoneNumber": phoneNumber,
      });

      // attach file if available
      if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
        print("📌 Adding image file: $imagePath");
        final file = await http.MultipartFile.fromPath(
          'profilePicture',
          imagePath,
        );
        request.files.add(file);
      } else {
        print("⚠️ No valid image selected.");
      }

      // send
      final response = await request.send();
      final result = await http.Response.fromStream(response);
      final body = jsonDecode(result.body);

      print("📥 Response: ${result.statusCode} - $body");

      if (result.statusCode == 200) {
        CustomSnackbar.showSuccess("Profile updated successfully!");
        Get.offAll(() => DashboardView());
      } else {
        final message = body["message"] ?? body["error"] ?? "Something went wrong.";
        CustomSnackbar.showError(message);
      }
    } catch (e) {
      print("🚨 Error: $e");
      CustomSnackbar.showError("Something went wrong.");
    } finally {
      isLoading(false);
    }
  }
}
