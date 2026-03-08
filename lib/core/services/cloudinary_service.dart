import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName = "dsecpkigi"; // من dashboard
  final String uploadPreset = "e008lcyx";

  Future<String> uploadImage(File imageFile) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    var request = http.MultipartRequest("POST", url);

    request.fields["upload_preset"] = uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        imageFile.path,
      ),
    );

    var response = await request.send();

    var responseData = await response.stream.bytesToString();

    var data = json.decode(responseData);

    return data["secure_url"]; // ← هذا هو رابط الصورة
  }
}
