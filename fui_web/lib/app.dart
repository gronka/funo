import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:fui_lib/fui_lib.dart';
import 'package:fui_web/l10n/localization.dart';
import 'package:fui_web/router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({required this.king});
  final King king;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => this.king,
      lazy: false,
      child: LocalizationsWrapper(),
    );
  }
}

class LocalizationsWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var todd = King.of(context).todd;
    final router = makeGoRouter();
    return Observer(
      builder: (_) => MaterialApp.router(
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: Locale(todd.locale, ''),
        supportedLocales: const [
          Locale('en', ''),
          //Locale('ru', ''),
        ],
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)?.title ?? 'Yuga',
        theme: King.of(context).theme.themeData,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
