import 'dart:async';
import 'package:app_links/app_links.dart';

import 'package:fui_lib/fui_lib.dart';

class Deep {
  Deep(this.king);
  final AppLinks _appLinks = AppLinks();
  String? initialLink = '';
  Uri? initialUri = Uri();
  King king;

  Future<void> initAppLinks() async {
    initialUri = await _appLinks.getInitialAppLink();

    _appLinks.uriLinkStream.listen((Uri uri) {
      processUri(newUri: uri);
    }, onError: (Object err) {
      king.log.d('Error while getting from linkstream: $err');
    });
  }

  void processUri({required Uri newUri}) {
    if (!newUri.hasEmptyPath) {
      final realPath = newUri.pathSegments.sublist(1).join('/');
      switch (realPath) {
        case Routes.home:
          //TODO: we either need this to work with go_router, or use
          // navigators on mobile

          //final boi = Boi();
          //boi.loadFromApiWithKing(king, newUri.queryParameters['boiId'] ?? '');
          //king.navigatorKey.currentState
          //?.pushNamed(Routes.boiShow, arguments: Args(boi: boi));
          break;

        case Routes.homeWord:
          //king.navigatorKey.currentState?.pushNamed(Routes.home);
          break;

        default:
          throw Exception(
              'ERROR: no matching uri path for appLink. uri: +$newUri+');
      }
    }
  }
}
