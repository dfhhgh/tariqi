import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  /// Cloudinary cloud name
  final String cloudName = "dsecpkigi";

  /// preset للبلاغات
  final String reportsPreset = "e008lcyx";

  /// preset للتبرعات
  final String donationsPreset = "donations";

  Future<String> uploadImage(
    File imageFile, {
    required String preset,
  }) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    var request = http.MultipartRequest("POST", url);

    /// اختيار preset
    request.fields["upload_preset"] = preset;

    /// إضافة الصورة
    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        imageFile.path,
      ),
    );

    var response = await request.send();

    var responseData = await response.stream.bytesToString();

    var data = json.decode(responseData);

    if (data["secure_url"] == null) {
      throw Exception("Cloudinary upload failed: $data");
    }

    return data["secure_url"];
  }
}
