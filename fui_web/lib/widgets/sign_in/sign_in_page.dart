import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:fui_lib/fui_lib.dart';
import 'package:fui_web/widgets/sign_in/auth_form.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var king = King.of(context);

    return WebScaffold(
      body: Observer(
        builder: (_) => !king.todd.isSignedIn
            ? AuthFormContainer()
            : Column(children: <Widget>[
                const SizedBox(height: 20),
                const Text('You are already signed in.'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    king.todd.signOut();
                    //King.of(context).navman.switchToNav(Nav.home);
                  },
                  child: const Text('Sign out'),
                ),
                const SizedBox(height: 20),
              ]),
      ),
    );
  }
}

enum AuthPages { signIn, register }

class AuthFormContainer extends StatefulWidget {
  @override
  AuthFormContainerState createState() => AuthFormContainerState();
}

class AuthFormContainerState extends State<AuthFormContainer> {
  AuthPages viewingForm = AuthPages.signIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[150],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 24),
                    const Text(
                        'You must sign in to access all of Fridayy\'s features'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            key: const Key(XKeys.authFormSignInTabButton),
                            child: PageButton('Sign in',
                                selected: this.viewingForm == AuthPages.signIn
                                    ? true
                                    : false),
                            onTap: () {
                              if (this.viewingForm != AuthPages.signIn) {
                                setState(() {
                                  this.viewingForm = AuthPages.signIn;
                                });
                              }
                            }),
                        const SizedBox(width: 2),
                        //

                        InkWell(
                            key: const Key(XKeys.authFormRegisterTabButton),
                            child: PageButton('Register',
                                selected: this.viewingForm == AuthPages.register
                                    ? true
                                    : false),
                            onTap: () {
                              if (this.viewingForm != AuthPages.register) {
                                setState(() {
                                  this.viewingForm = AuthPages.register;
                                });
                              }
                            }),
                      ],
                    ),
                    AuthForm(this.viewingForm),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PageButton extends StatelessWidget {
  const PageButton(this.text, {required this.selected});
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Color bottomColor =
        this.selected ? Colors.yellow.shade700 : Colors.grey.shade400;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 8.0, color: bottomColor),
        ),
      ),
      child: Text(this.text,
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 30)),
    );
  }
}
