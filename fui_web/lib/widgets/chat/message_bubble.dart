import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

import 'package:fui_lib/fui_lib.dart';

class MsgBubble extends StatelessWidget {
  const MsgBubble(
    this.msg, {
    this.isNextMsgSameUser = false,
    this.isPrevMsgSameUser = false,
  });

  final Msg msg;
  final bool isNextMsgSameUser;
  final bool isPrevMsgSameUser;

  bool get isMe {
    if (msg.surferId == '1111') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: smaller margin for msg from same user
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        (!isMe && !isPrevMsgSameUser)
            ? BasedCircleImage(
                src: '',
                radius: 18,
                altText: msg.username.substring(0, 2),
              )
            : const SizedBox(width: 36),
        Flexible(
          child: Bubble(
            margin: isNextMsgSameUser
                ? const BubbleEdges.only(top: 0, bottom: 0)
                : const BubbleEdges.only(top: 4, bottom: 0),
            nip: isMe ? BubbleNip.rightBottom : BubbleNip.leftBottom,
            color: isMe ? Colors.green[600] : Colors.grey[850],
            child: MsgBody(msg, isMe, isPrevMsgSameUser),
            //child:
            //Text(msg.text, style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

class MsgBody extends StatelessWidget {
  const MsgBody(this.msg, this.isMe, this.isPrevMsgSameUser);
  final Msg msg;
  final bool isMe;
  final bool isPrevMsgSameUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        (!isPrevMsgSameUser && !isMe)
            ? Text(msg.username, style: const TextStyle(color: Colors.blue))
            : const SizedBox.shrink(),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const SizedBox(width: 2),
            Flexible(
                child: Text(msg.body,
                    style: const TextStyle(color: Colors.white))),
            const SizedBox(width: 2),
          ],
        ),
        const SizedBox.shrink(),
// TODO: do we want/need a timestamp?
//IntrinsicWidth(
//child: Row(
//children: <Widget>[
//Text(msg.timeReadable,
//style: TextStyle(color: Colors.grey[300], fontSize: 10)),
//],
//),
//),
      ],
    );
  }
}
