import 'package:flutter/material.dart';

import 'package:fui_lib/fui_lib.dart';

class BaText extends StatelessWidget {
  const BaText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Styles.of(context).bodySmall);
  }
}

class TextWrapper extends StatelessWidget {
  const TextWrapper(
    this.text, {
    this.style,
  });
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style);
  }
}

class Text12 extends StatelessWidget {
  const Text12(
    this.text, {
    this.decoration,
    this.maxLines,
    this.style,
  });
  final TextDecoration? decoration;
  final int? maxLines;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: style?.color,
          decoration: style?.decoration,
          fontSize: 12,
          fontWeight: style?.fontWeight,
        ));
  }
}

class Text14 extends StatelessWidget {
  const Text14(
    this.text, {
    this.decoration,
    this.maxLines,
    this.style,
  });
  final TextDecoration? decoration;
  final int? maxLines;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: style?.color,
          decoration: style?.decoration,
          fontSize: 14,
          fontWeight: style?.fontWeight,
        ));
  }
}

class Text16 extends StatelessWidget {
  const Text16(
    this.text, {
    this.decoration,
    this.maxLines,
    this.style,
  });
  final TextDecoration? decoration;
  final int? maxLines;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: style?.color,
          decoration: style?.decoration,
          fontSize: 16,
          fontWeight: style?.fontWeight,
        ));
  }
}

class Text18 extends StatelessWidget {
  const Text18(
    this.text, {
    this.decoration,
    this.maxLines,
    this.style,
  });
  final TextDecoration? decoration;
  final int? maxLines;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: style?.color,
          decoration: style?.decoration,
          fontSize: 18,
          fontWeight: style?.fontWeight,
        ));
  }
}

class Text20 extends StatelessWidget {
  const Text20(
    this.text, {
    this.decoration,
    this.maxLines,
    this.style,
  });
  final TextDecoration? decoration;
  final int? maxLines;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: style?.color,
          decoration: style?.decoration,
          fontSize: 20,
          fontWeight: style?.fontWeight,
        ));
  }
}

class Text22 extends StatelessWidget {
  const Text22(
    this.text, {
    this.decoration,
    this.maxLines,
    this.style,
  });
  final TextDecoration? decoration;
  final int? maxLines;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: style?.color,
          decoration: style?.decoration,
          fontSize: 22,
          fontWeight: style?.fontWeight,
        ));
  }
}
