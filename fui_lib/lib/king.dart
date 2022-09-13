import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:fui_lib/fui_lib.dart';

class King {
  AppConf conf;
  late Box box;
  late Deep deep;
  late Lad lad;
  late Pad pad;
  late Plogger log;
  late Lip lip;
  final navigatorKey = GlobalKey<NavigatorState>();
  late BuildContext routerContext;
  final Snacker snacker = Snacker();
  late ThemeSelect theme;
  late Todd todd;

  King({required this.conf}) {
    this.theme = ThemeSelect();

    // depends only on conf
    this.lip = Lip(this, pool: conf.apiPool);
    this.log = Plogger(
      level: Level.verbose,
      lip: lip,
      name: this.conf.appName,
      platform: conf.platform,
    );

    // depends on 'this'
    this.lad = Lad(this);
    this.pad = Pad(this);
    this.deep = Deep(this);
    this.todd = Todd(this);
    todd.toddMode = conf.toddMode;

    //if (this.conf.mockAutoSignIn) {
    //this.todd.signInWithEmail(email: '2@2.2', password: 'asdf');
    //}
  }

  initAsyncObjects() async {
    box = await Hive.openBox('box');

    todd.loadLogin();

    deep.initAppLinks();
  }

  static King of(BuildContext context) {
    return Provider.of<King>(context, listen: false);
  }

  // signOutCleanup should destroy all personal information
  void signOutCleanup() {
    //this.pac = Pac();
    this.lad = Lad(this);
    this.pad = Pad(this);
  }
}
