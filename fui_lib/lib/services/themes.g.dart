// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'themes.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ThemeSelect on ThemeSelectBase, Store {
  Computed<ThemeData>? _$themeDataComputed;

  @override
  ThemeData get themeData =>
      (_$themeDataComputed ??= Computed<ThemeData>(() => super.themeData,
              name: 'ThemeSelectBase.themeData'))
          .value;
  Computed<Styles>? _$stylesComputed;

  @override
  Styles get styles => (_$stylesComputed ??=
          Computed<Styles>(() => super.styles, name: 'ThemeSelectBase.styles'))
      .value;
  Computed<bool>? _$isDarkComputed;

  @override
  bool get isDark => (_$isDarkComputed ??=
          Computed<bool>(() => super.isDark, name: 'ThemeSelectBase.isDark'))
      .value;
  Computed<bool>? _$isLightComputed;

  @override
  bool get isLight => (_$isLightComputed ??=
          Computed<bool>(() => super.isLight, name: 'ThemeSelectBase.isLight'))
      .value;

  late final _$selectedThemeAtom =
      Atom(name: 'ThemeSelectBase.selectedTheme', context: context);

  @override
  ThemeOption get selectedTheme {
    _$selectedThemeAtom.reportRead();
    return super.selectedTheme;
  }

  @override
  set selectedTheme(ThemeOption value) {
    _$selectedThemeAtom.reportWrite(value, super.selectedTheme, () {
      super.selectedTheme = value;
    });
  }

  late final _$ThemeSelectBaseActionController =
      ActionController(name: 'ThemeSelectBase', context: context);

  @override
  dynamic setTheme(ThemeOption newTheme) {
    final _$actionInfo = _$ThemeSelectBaseActionController.startAction(
        name: 'ThemeSelectBase.setTheme');
    try {
      return super.setTheme(newTheme);
    } finally {
      _$ThemeSelectBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedTheme: ${selectedTheme},
themeData: ${themeData},
styles: ${styles},
isDark: ${isDark},
isLight: ${isLight}
    ''';
  }
}
