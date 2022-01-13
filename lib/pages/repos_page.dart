import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github_repo_app/api/api_repos.dart';
import 'package:github_repo_app/models/models.dart';

var dio = Dio();

class ReposPage extends StatefulWidget {
  const ReposPage({Key? key, required this.token}) : super(key: key);

  final String token;

  @override
  State<ReposPage> createState() => _ReposPageState();
}

class _ReposPageState extends State<ReposPage> {
  
  final apiRepo = GitHubRepo();

  final TextEditingController _textFieldController = TextEditingController();

  String valueText = "";
  String repoName = "";

  Future<void> _textInputDialog(BuildContext context, repo) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter username to add a collaborator'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                  repoName = repo;
                });
              },
              controller: _textFieldController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    apiRepo.giveAccess(widget.token, valueText, repoName);
                  },
                  child: const Text("Add user"))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    apiRepo.getRepos(widget.token);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Repos App"),
      ),
      body: Center(
          child: FutureBuilder<AllRepos>(
              future: apiRepo.getRepos(widget.token),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Repo> repos = <Repo>[];
                  for (int i = 0; i < snapshot.data!.repos!.length; i++) {
                    repos.add(Repo(name: snapshot.data!.repos![i].name));
                  }
                  return ListView(
                    padding: EdgeInsets.all(10),
                    children: repos
                        .map((r) => Card(
                                child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(r.name),
                                  IconButton(
                                      onPressed: () {
                                        _textInputDialog(context, r.name);
                                      },
                                      icon: const Icon(Icons.add))
                                ],
                              ),
                            )))
                        .toList(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error occured"),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }
}
