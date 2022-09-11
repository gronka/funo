import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import 'package:fui_lib/fui_lib.dart';

class WebScaffold extends StatelessWidget {
  const WebScaffold({required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context) {
    var king = King.of(context);

    return Observer(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: TextButton(
                child: const Text('FridayyUI',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: () {
                  context.go(Routes.home);
                }),
            actions: <Widget>[
              TextButton(
                  child: const Text('Contact Us',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    context.go(Routes.contact);
                  }),
              king.todd.isSignedIn
                  ? TextButton(
                      child: const Text('Console',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        context.go(Routes.console);
                      })
                  : const SizedBox.shrink(),
              //

              king.todd.isSignedIn
                  ? TextButton(
                      child: const Text('Profile',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        context.go(Routes.developer);
                      })
                  : TextButton(
                      child: const Text('Sign In',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        context.go(Routes.signIn);
                      }),
            ]),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              //child: Center(child: body),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Flexible(child: SizedBox.shrink()),
                  //SizedBox.shrink(),
                  Flexible(
                    flex: 6,
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 140,
                          maxWidth: 900,
                        ),
                        child: body),
                  ),
                  //SizedBox.shrink(),
                  const Flexible(child: SizedBox.shrink()),
                ],
              ),
            ),
            BasedSnackBar(),
          ],
        ),
      ),
    );
  }
}
