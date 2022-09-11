import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:fui_lib/fui_lib.dart';

class BasedSnackBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      var snacker = King.of(context).snacker;
      var snacks = snacker.snacks;

      if (snacks.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: kToolbarHeight * 2,
        ),
        child: ListView.separated(
            itemCount: snacks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 2),
            itemBuilder: (context, index) {
              var snack = snacks[index];
              King.of(context).snacker.startTimer(snack);

              return Card(
                elevation: 5,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(snack.msg),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => snacker.removeSnack(snack)),
                    ],
                  ),
                ),
              );
            }),
      );
    });
  }
}
