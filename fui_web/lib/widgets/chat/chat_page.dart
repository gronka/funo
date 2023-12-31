import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:fui_lib/fui_lib.dart';
import 'package:fui_web/widgets/chat/chat_options.dart';

class ChatPage extends StatelessWidget {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    King.of(context).lad.chats.loadAllChatsFromApiInitial();

    return WebScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('Allow us to select between session vs IP user'),
            TextButton(
              onPressed: () async {
                King.of(context).lad.chats.loadAllChatsFromApi();
              },
              child: const Text('update chat list'),
            ),
            ChatOptionsWidget(),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 200,
                      maxWidth: 300,
                      minHeight: 800,
                      maxHeight: 4000,
                    ),
                    child: ChatSelect(),
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 200,
                        maxWidth: 500,
                        minHeight: 800,
                        maxHeight: 4000,
                      ),
                      child: ChatArea(),
                    ),
                  ),
                  //Column(
                  //children: [
                  //Expanded(
                  //child: ChatArea(),
                  //),
                  //WriteMessage(),
                  //],
                  //),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lad = King.of(context).lad;
    final opts = King.of(context).pad.chatOptions;

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
            final chatValues = lad.chats.byId.values;
            final chats = ObservableList.of(chatValues);

            return ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 300,
                maxWidth: 900,
                maxHeight: 4000,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: chats.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final surfer = lad.surferProxy.getById(chat.surferId);

                  return Observer(
                    builder: (_) => surfer.phone == ''
                        ? const SizedBox.shrink()
                        : TextButton(
                            onPressed: () {
                              opts.selectedChatId = chat.chatId;
                              final testChat = King.of(context)
                                  .lad
                                  .chats
                                  .getChatById(opts.selectedChatId);

                              testChat.getNewMsgsByChatIdFromApi();
                            },
                            child: Text('chat phone: ${surfer.phone}'),
                          ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChatArea extends StatelessWidget {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final opts = King.of(context).pad.chatOptions;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xAAAAAAAA)),
          left: BorderSide(color: Color(0xAAAAAAAA)),
          right: BorderSide(color: Color(0xAAAAAAAA)),
          //bottom: BorderSide(color: Color(0xAAAAAAAA)),
        ),
      ),
      child: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Observer(
              builder: (_) {
                final msgs = King.of(context)
                    .lad
                    .chats
                    .getChatById(opts.selectedChatId)
                    .msgs;

                return ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 300,
                    maxWidth: 900,
                    maxHeight: 4000,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: msgs.length + 1,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index < msgs.length) {
                        final msg = msgs[index];
                        return Text('Msg: ${msg.content}');
                      } else {
                        Future.delayed(
                          const Duration(milliseconds: 300),
                          () => {
                            scrollController.jumpTo(
                              scrollController.position.maxScrollExtent,
                            )
                          },
                        );
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                );
              },
            ),
          ),
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
  bool _autoRefresh = false;

  Timer? timer;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  toggleTimer() {
    setState(() {
      _autoRefresh = !_autoRefresh;

      if (_autoRefresh) {
        timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
          refresh();
        });
      } else {
        timer?.cancel();
      }
    });
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
                  refresh();
                },
                child: const Text('reload chat'),
              ),
              TextButton(
                onPressed: () {
                  _textController.text = 'i want to buy a table';
                },
                child: const Text('set text'),
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: _autoRefresh,
                  onChanged: (bool? newValue) => toggleTimer(),
                ),
                const Expanded(child: Text('Auto update?')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> send() async {
    if (content == '') {
      setState(() {
        _failureMsg = 'You must write something';
      });
      return;
    }

    final lad = King.of(context).lad;
    final opts = King.of(context).pad.chatOptions;
    final chat = lad.chats.getChatById(opts.selectedChatId);

    Map<String, dynamic> payload = {
      'Content': content,
      'ChatId': chat.chatId,
      'SenderSurferId': chat.surferId,
    };

    final king = King.of(context);
    final ares = await king.lip.api(
      EndpointsV1.chatSendMsg,
      payload: payload,
    );

    if (ares.isOk) {
      setState(() {
        content = '';
        _failureMsg = '';
      });

      Future.delayed(const Duration(milliseconds: 100), () => refresh());
    } else {
      setState(() {
        _failureMsg = 'Failed to send.';
      });
    }
  }

  Future<void> refresh() async {
    final lad = King.of(context).lad;
    final opts = King.of(context).pad.chatOptions;
    final chat = lad.chats.getChatById(opts.selectedChatId);
    opts.selectedChatId = chat.chatId;

    chat.getNewMsgsByChatIdFromApi();
    //final opts = King.of(context).pad.chatOptions;
    //Map<String, dynamic> payload = {
    //'Phone': opts.phone,
    //};

    //final ares = await King.of(context).lip.api(
    //EndpointsV1.chatGetByPhone,
    //payload: payload,
    //);

    //if (ares.isNotOk) {
    //setState(() {
    //_failureMsg = 'Failed to get chat.';
    //});
    //} else {
    //setState(() {
    //_failureMsg = '';
    //});
    //}
  }
}
