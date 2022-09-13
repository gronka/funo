import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:fui_lib/fui_lib.dart';
import 'package:fui_web/widgets/chat/chat_options.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const Text('Allow us to select between session vs IP user'),
            ChatOptionsWidget(),
            const SizedBox(height: 24),
            ChatArea(),
            WriteMessage(),
          ],
        ),
      ),
    );
  }
}

class ChatArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var junk = ObservableList();
    junk.add('hi');
    junk.add('there');
    junk.add('my');

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xAAAAAAAA)),
          left: BorderSide(color: Color(0xAAAAAAAA)),
          right: BorderSide(color: Color(0xAAAAAAAA)),
          //bottom: BorderSide(color: Color(0xAAAAAAAA)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Observer(
          builder: (_) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: junk.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Text(junk[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class WriteMessage extends StatefulWidget {
  @override
  WriteMessageState createState() => WriteMessageState();
}

class WriteMessageState extends State<WriteMessage> {
  final _textController = TextEditingController();
  String _failureMsg = '';

  @override
  initState() {
    super.initState();
  }

  String get content {
    return _textController.text;
  }

  set content(String newText) {
    _textController.text = newText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xAAAAAAAA)),
          left: BorderSide(color: Color(0xAAAAAAAA)),
          right: BorderSide(color: Color(0xAAAAAAAA)),
          bottom: BorderSide(color: Color(0xAAAAAAAA)),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
                  child: TextField(
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Write to Fridayy...',
                      border: InputBorder.none,
                    ),
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  send();
                },
                child: const Text('send'),
              ),
            ],
          ),
          FailureMsg(_failureMsg),
        ],
      ),
    );
  }

  Future<void> send() async {
    if (content == '') {
      this.setState(() {
        _failureMsg = 'You must write something';
      });
      return;
    }

    this.setState(() {
      _failureMsg = '';
      content = '';
    });

    var opts = King.of(context).pad.chatOptions;
    Map<String, dynamic> payload = {
      'Phone': opts.phone,
      'Content': content,
    };

    var king = King.of(context);
    var ares = await king.lip.api(
      EndpointsV1.chatSendMsg,
      payload: payload,
    );

    if (ares.isNotOk) {
      this.setState(() {
        _failureMsg = 'Failed to send.';
      });
    }
  }
}
