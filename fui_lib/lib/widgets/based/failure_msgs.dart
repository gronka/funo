import 'package:flutter/material.dart';

import 'package:fui_lib/fui_lib.dart';

class TextFailure extends StatelessWidget {
  const TextFailure(
    this.text, {
    this.maxLines = 4,
  });
  final int? maxLines;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: Bast.failure);
  }
}

class FailureMsg extends StatelessWidget {
  const FailureMsg(this.failureMsg);
  final String failureMsg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          failureMsg == '' ? const SizedBox.shrink() : TextFailure(failureMsg),
    );
  }
}
