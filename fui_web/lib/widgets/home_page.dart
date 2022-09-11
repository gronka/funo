import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:fui_lib/fui_lib.dart';
import 'package:fui_web/widgets/console/console_page.dart';
import 'package:fui_web/widgets/welcome_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) =>
          King.of(context).todd.isSignedIn ? ConsolePage() : WelcomePage(),
    );
  }
}
