import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fui_web/widgets/home_page.dart';
import 'package:fui_lib/fui_lib.dart';

GoRouter makeGoRouter() {
  return GoRouter(
    //TODO: error page builder
    initialLocation: Routes.home,
    routes: <GoRoute>[
      GoRoute(
        path: Routes.home,
        builder: (BuildContext context, GoRouterState state) {
          return HomePage();
        },
      ),
      GoRoute(
        path: Routes.home,
        builder: (BuildContext context, GoRouterState state) {
          return HomePage();
        },
      ),
    ],
  );
}
