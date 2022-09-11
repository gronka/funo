import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'package:fui_lib/fui_lib.dart';

part 'themes.g.dart';

enum ThemeOption { dark, light }

class ThemeSelect = ThemeSelectBase with _$ThemeSelect;

abstract class ThemeSelectBase with Store {
  @observable
  var selectedTheme = ThemeOption.light;

  @action
  setTheme(ThemeOption newTheme) {
    this.selectedTheme = newTheme;
  }

  @computed
  ThemeData get themeData {
    switch (this.selectedTheme) {
      case ThemeOption.dark:
        return darkTheme;
      case ThemeOption.light:
        return lightTheme;
      default:
        throw Exception('ERROR: theme not found');
    }
  }

  @computed
  Styles get styles {
    switch (this.selectedTheme) {
      case ThemeOption.dark:
        return darkTextStyles;
      case ThemeOption.light:
        return lightTextStyles;
      default:
        throw Exception('ERROR: theme not found');
    }
  }

  @computed
  bool get isDark {
    return selectedTheme == ThemeOption.dark;
  }

  @computed
  bool get isLight {
    return selectedTheme == ThemeOption.light;
  }
}

// Other settings
// visualDensity: VisualDensity.adaptivePlatformDensity,
// fontFamily
// brightness
//primarySwatch: Colors.grey,
ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.green,
);

ThemeData darkTheme = ThemeData(
  primaryColor: Colors.grey[850],
  backgroundColor: Colors.grey[850],
  dialogBackgroundColor: Colors.grey[850],
  scaffoldBackgroundColor: Colors.grey[850],
  colorScheme: const ColorScheme.light(
    primary: Colors.black,
    onPrimary: Colors.black,
    primaryContainer: Colors.black,
    secondary: Colors.green,
  ),
  cardTheme: CardTheme(
    color: Colors.grey[850],
  ),
);

class Styles {
  const Styles({
    required this.bodySmall,
    required this.bodyMedium,
    required this.titleMedium,
  });
  final TextStyle bodySmall;
  final TextStyle bodyMedium;
  final TextStyle titleMedium;

  static Styles of(BuildContext context) {
    return King.of(context).theme.styles;
  }
}

var lightTextStyles = const Styles(
  bodySmall: TextStyle(fontSize: 16),
  bodyMedium: TextStyle(fontSize: 18),
  titleMedium: TextStyle(fontSize: 24),
);

var darkTextStyles = Styles(
  bodySmall: TextStyle(fontSize: 16, color: Colors.grey[100]),
  bodyMedium: TextStyle(fontSize: 18, color: Colors.grey[100]),
  titleMedium: TextStyle(fontSize: 24, color: Colors.grey[100]),
);
