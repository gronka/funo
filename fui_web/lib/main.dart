import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:fui_lib/fui_lib.dart';
import 'package:fui_web/app.dart';

AppConf defaultConf = AppConf();
King defaultKing = King(conf: defaultConf);

void main() async {
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }

  await defaultKing.initAsyncObjects();
  runApp(MyApp(king: defaultKing));
}
