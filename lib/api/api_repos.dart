import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:github_repo_app/api/api_constants.dart';
import 'package:github_repo_app/api/api_urls.dart';
import 'package:github_repo_app/models/models.dart';

var dio = Dio();

class GitHubRepo {
  final api = APIConstants();
  final url = APIUrls();

  Future<AllRepos> getRepos(token) async {
    final response = await dio.get(url.urlToGetRepos,
        options: Options(
          headers: {
            "Authorization": "Bearer " + token,
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (response.statusCode == 200) {
      return AllRepos.fromJson(json.decode(json.encode(response.data)));
    } else {
      throw Exception(
          "Request failed with code: " + response.statusCode.toString());
    }
  }

  Future<String?> getUsername(token) async {
    final response = await dio.get(url.urlToGetMe,
        options: Options(headers: {"Authorization": "Bearer " + token}));
    if (response.statusCode == 200) {
      final responseMsg = jsonDecode(jsonEncode(response.data));
      final username = responseMsg[0];
      return username;
    } else {
      return "User unauthorized";
    }
  }

  Future<dynamic> giveAccess(token, collaborator, repo) async {
    final username = getUsername(token);
    final response = await dio.put(
        url.urlToGiveAccess + "/$username/$repo/collaborators/$collaborator",
        options: Options(
          headers: {"Authorization": "Bearer " + token},
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (response.statusCode == 200) {
      return "Success";
    } else {
      return "Request failed with code: " + response.statusCode.toString();
    }
  }
}
