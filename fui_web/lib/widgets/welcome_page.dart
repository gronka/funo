import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fui_lib/fui_lib.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 24),
            Text(
              'Welcome to Fridayy UI',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 24),
            const Text('Manage Fridayy'),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.go(Routes.signIn);
              },
              child: const Text('Sign in or create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
