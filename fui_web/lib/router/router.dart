import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fui_lib/fui_lib.dart';
import 'package:fui_web/widgets/chat/chat_page.dart';
import 'package:fui_web/widgets/developer/developer_page.dart';
import 'package:fui_web/widgets/home_page.dart';
import 'package:fui_web/widgets/sign_in/sign_in_page.dart';

GoRouter makeGoRouter() {
  return GoRouter(
    // the default error builder seems fine
    //errorBuilder: (context, state) => ErrorScreen(state.error),
    initialLocation: Routes.home,
    routes: <GoRoute>[
      GoRoute(
        path: Routes.home,
        builder: (BuildContext context, GoRouterState state) {
          return HomePage();
        },
      ),
      //

      GoRoute(
        path: Routes.home,
        builder: (BuildContext context, GoRouterState state) {
          return HomePage();
        },
      ),

      GoRoute(
        path: Routes.chat,
        builder: (BuildContext context, GoRouterState state) {
          return ChatPage();
        },
      ),

      GoRoute(
        path: Routes.signIn,
        builder: (BuildContext context, GoRouterState state) {
          return SignInPage();
        },
      ),

      GoRoute(
        path: Routes.developer,
        builder: (BuildContext context, GoRouterState state) {
          return const DeveloperPage();
        },
      ),
    ],
  );
}
