import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import 'package:fui_lib/fui_lib.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage();

  @override
  DeveloperPageState createState() => DeveloperPageState();
}

class DeveloperPageState extends State<DeveloperPage> {
  //final developer = Developer();

  @override
  initState() {
    super.initState();
    //final king = King.of(context);
    //developer.loadFromApi(context, king.todd.developerId);
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Center(
            child: Observer(
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 24),
                  Row(
                    children: <Widget>[
                      const Text18('Email'),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const BaText('Edit'),
                        onPressed: () {
                          //Navigator.of(context).pushNamed(
                          //Routes.developerChangeEmailRequest,
                          //arguments: Args(developer: developer));
                        },
                      ),
                    ],
                  ),
                  //Text18(developer.email),
                  const DividerOverview(),
                  //

                  Row(
                    children: <Widget>[
                      const Text18('Password'),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const BaText('Edit'),
                        onPressed: () {
                          //Navigator.of(context).pushNamed(
                          //Routes.developerChangePasswordRequest,
                          //arguments: Args(developer: developer));
                        },
                      ),
                    ],
                  ),
                  const DividerOverview(),

                  Row(
                    children: <Widget>[
                      const Text18('Phone'),
                      const SizedBox(width: 8),
                      TextButton(
                        child: const BaText('Edit'),
                        onPressed: () {
                          //Navigator.of(context).pushNamed(
                          //Routes.developerChangePhone,
                          //arguments: Args(developer: developer));
                        },
                      ),
                    ],
                  ),
                  //Text18(developer.phone),
                  const DividerOverview(),

                  TextButton(
                    child: const BaText('Terms and Conditions'),
                    onPressed: () {
                      //Navigator.of(context).pushNamed(Routes.developerTerms);
                    },
                  ),
                  const DividerOverview(),

                  TextButton(
                    child: const BaText('Privacy Policy'),
                    onPressed: () {
                      //Navigator.of(context).pushNamed(Routes.developerPrivacy);
                    },
                  ),
                  const DividerOverview(),

                  FunctionCard(
                      text: 'Sign Out',
                      onTap: () {
                        King.of(context).todd.signOut();
                        context.go(Routes.home);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
