import 'package:flutter/material.dart';

import 'package:fui_lib/fui_lib.dart';

class ChatOptionsWidget extends StatefulWidget {
  @override
  ChatOptionsState createState() => ChatOptionsState();
}

class ChatOptionsState extends State<ChatOptionsWidget> {
  final _textController = TextEditingController();
  late ChatOptions opts;

  @override
  initState() {
    super.initState();
    opts = King.of(context).pad.chatOptions;
    _textController.text = opts.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Text('Conversation for phone #:'),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
            child: TextField(
                controller: _textController,
                //keyboardType: TextInputType.multiline,
                //maxLines: 5,
                minLines: 1,
                onChanged: (String newPhone) {
                  opts.phone = newPhone;
                }),
          ),
        ),
      ],
    );
  }
}