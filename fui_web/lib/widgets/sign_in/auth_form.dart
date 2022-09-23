import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fui_lib/fui_lib.dart';
import 'package:fui_web/widgets/sign_in/sign_in_page.dart';

class AuthFormFields {
  String email = '';
  String password = '';
}

class AuthForm extends StatefulWidget {
  const AuthForm(this.whichForm);
  final AuthPages whichForm;

  @override
  AuthFormState createState() => AuthFormState();
}

class AuthFormState extends State<AuthForm> {
  String _failureMsg = '';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _submitFailed = false;
  AuthFormFields fields = AuthFormFields();

  String validateEmail(String email) {
    if (email != '') {
      if (email.length < 5) {
        return 'Email is too short';
      }
      int atPosition = email.indexOf('@');
      int dotPosition = email.lastIndexOf('.');
      if (dotPosition == -1 || atPosition == -1 || dotPosition <= atPosition) {
        return 'Email format is invalid';
      }
    }
    if (email == '') {
      return 'You must provide an email.';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    String banner = '';
    switch (widget.whichForm) {
      case AuthPages.register:
        banner = 'Create your account.';
        break;
      case AuthPages.signIn:
        banner = 'Sign in to your account.';
        break;
    }

    return Container(
      width: 400,
      color: Colors.grey[150],
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Text(banner, style: const TextStyle(fontSize: 16)),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: const Key(XKeys.authFormEmailField),
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                maxLength: 320,
                autocorrect: false,
                onChanged: (value) {
                  if (this._submitFailed) {
                    setState(() {
                      this._submitFailed = false;
                      _failureMsg = '';
                    });
                  }
                  fields.email = value.trim();
                },
                validator: (value) {
                  String? error = validateEmail(value ?? '');
                  return error == '' ? null : error;
                },
              ),
              const SizedBox(height: 14),
              BasedCreatePassword(
                textFieldKey: const Key(XKeys.authFormPasswordField),
                onChanged: (password) {
                  if (this._submitFailed) {
                    setState(() {
                      this._submitFailed = false;
                      _failureMsg = '';
                    });
                  }
                  fields.password = password;
                },
                onFieldSubmitted: () {
                  _onSubmit(context);
                },
              ),
              const SizedBox(height: 32),
              //

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      key: const Key(XKeys.authFormRegisterOrSignInButton),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _onSubmit(context);
                      },
                      child: widget.whichForm == AuthPages.register
                          ? const Text('Register')
                          : const Text('Sign in'),
                    ),
              const SizedBox(height: 32),

              widget.whichForm == AuthPages.register
                  ? const SizedBox.shrink()
                  : TextButton(
                      key: const Key(XKeys.authFormResetPasswordButton),
                      onPressed: () =>
                          context.go(Routes.loggedOutChangePasswordRequest),
                      child: const Text('Forgot password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          )),
                    ),
              const SizedBox(height: 24),

              FailureMsg(_failureMsg)
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) async {
    var todd = King.of(context).todd;
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      switch (widget.whichForm) {
        case AuthPages.register:
          var ares = await todd.registerWithEmail(
              email: fields.email, password: fields.password);

          if (ares.isOk) {
            if (!mounted) return;
            context.go(Routes.home);
          } else {
            setState(() {
              _failureMsg =
                  ares.peekErrorMsg(defaultText: 'Could not register.');
              this._submitFailed = true;
            });
          }
          break;

        case AuthPages.signIn:
          var ares = await todd.signInWithEmail(
              email: fields.email, password: fields.password);

          if (ares.isOk) {
            if (!mounted) return;
            context.go(Routes.home);
          } else {
            setState(() {
              _failureMsg =
                  ares.peekErrorMsg(defaultText: 'Could not sign in.');
              this._submitFailed = true;
            });
          }
          break;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }
}
