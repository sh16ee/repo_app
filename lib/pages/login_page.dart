import 'package:flutter/material.dart';
import 'package:github_repo_app/api/api_auth.dart';
import 'package:github_repo_app/pages/repos_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final auth = GitHubAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GitHub Repos App"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final code = await auth.getUserCode();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              content: const Text(
                                  "User code has been copied to the clipboard.\nEnter user code in GitHub to login."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    auth.enterCode();
                                  },
                                  child: const Text('Enter user code'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final token = await auth
                                        .login(code.deviceCode);
                                    if (token[3] == "_") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReposPage(token: token)),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Enter your user code first!'),
                                      ));
                                    }
                                  },
                                  child: const Text('Login'),
                                ),
                              ],
                            ));
                  },
                  child: const Text("Login via GitHub")),
            ],
              ),
        ),
      ),
    );
  }
}

