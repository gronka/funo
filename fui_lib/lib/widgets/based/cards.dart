import 'package:flutter/material.dart';

class FunctionCard extends StatelessWidget {
  const FunctionCard({
    this.onTap,
    required this.text,
  });
  final Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    bool enabled = onTap != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: this.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(this.text,
                style: enabled
                    ? const TextStyle(color: Colors.blue)
                    : const TextStyle(color: Colors.grey)),
          ),
        ),
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  const TextCard(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(this.text),
      ),
    );
  }
}
