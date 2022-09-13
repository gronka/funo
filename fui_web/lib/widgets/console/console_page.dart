import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fui_lib/fui_lib.dart';

class ConsolePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 24),
            Text(
              'Console Page',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 24),
            const Text('Manage Friday'),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                context.go(Routes.signIn);
              },
              child: const Text('Sign in or create an account'),
            ),
            TextButton(
              onPressed: () {
                context.go(Routes.chat);
              },
              child: const Text('Chat with Fridayy'),
            ),
          ],
        ),
      ),
    );
  }
}
