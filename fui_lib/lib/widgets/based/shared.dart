import 'package:flutter/material.dart';

class DividerOverview extends StatelessWidget {
  const DividerOverview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 24),
      child: Divider(color: Colors.grey),
    );
  }
}
