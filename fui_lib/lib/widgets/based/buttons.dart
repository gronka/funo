import 'package:flutter/material.dart';

import 'package:fui_lib/fui_lib.dart';

class BaIconButton extends StatelessWidget {
  const BaIconButton({
    this.color,
    required this.text,
    required this.iconData,
    required this.onTap,
  });
  final Color? color;
  final IconData? iconData;
  final Function? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    final themeData = King.of(context).theme.themeData;
    return InkWell(
      onTap: () => onTap!(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              iconData,
              color: color ?? themeData.primaryColor,
            ),
            const SizedBox(width: 4),
            Text18(text,
                style: TextStyle(
                  fontSize: 18,
                  color: color ?? themeData.primaryColor,
                )),
          ],
        ),
      ),
    );
  }
}
