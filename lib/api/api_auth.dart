import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:github_repo_app/api/api_constants.dart';
import 'package:github_repo_app/api/api_urls.dart';
import 'package:github_repo_app/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

var dio = Dio();

class GitHubAuth {

  final api = APIConstants();
  final url = APIUrls();
  final code = CodeModel();

  Future<CodeModel> getUserCode() async {
    final response = await dio.post(url.urlToGetCode, data: {
      "client_id": api.clientId,
    });

    if (response.statusCode != 404) {
      final msg = response.data.split("&");
      final userCode = msg[3].split("=")[1];
      final deviceCode = msg[0].split("=")[1];
      Clipboard.setData(ClipboardData(text: userCode));
      return CodeModel(deviceCode: deviceCode, userCode: userCode);
    } else {
      return CodeModel();
    }
  }

  Future<void> enterCode() async {
    if (await canLaunch(url.urlToEnterCode)) {
      await launch(url.urlToEnterCode, enableJavaScript: true);
    } else {
      throw 'Could not launch ' + url.urlToEnterCode;
    }
  }

  Future<String> login(deviceCode) async {
    final response = await dio.post(url.urlToGetToken, data: {
      "client_id": api.clientId,
      "device_code": deviceCode,
      "grant_type": api.grantType
    });

    if (response.statusCode != 404) {
      final msg = response.data.split("&");
      final token = msg[0].split("=")[1];
      return token;
    } else {
      return "Request failed with code: " + response.statusCode.toString();
    }
  }
}