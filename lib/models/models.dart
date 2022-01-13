class CodeModel {
  CodeModel({this.deviceCode, this.userCode});
  String? deviceCode;
  String? userCode;
}

class Repo {
  Repo({required this.name});
  String name;

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
    );
  }
}

class AllRepos {
  List<Repo>? repos;

  AllRepos({this.repos});

  factory AllRepos.fromJson(List<dynamic> json) {
    List<Repo> repos = <Repo>[];
    repos = json.map((r) => Repo.fromJson(r)).toList();
    return AllRepos(repos: repos);
  }
}