import 'package:mobx/mobx.dart';

import 'package:fui_lib/fui_lib.dart';

part 'chat.g.dart';

class Chats {
  Chats(this.king);
  final ObservableMap<String, Chat> byId = ObservableMap();
  King king;

  Chat getChatById(String chatId) {
    if (!byId.containsKey(chatId)) {
      byId[chatId] = Chat();
    }

    if (byId[chatId]!.isInitialLoad) {
      // only load all the chats on initialLoad
      getChatByIdFromApi(chatId, 0);
    }
    return byId[chatId]!;
  }

  Future<void> getChatByIdFromApi(String chatId, int afterTime) async {
    if (chatId == '') {
      return;
    }
    ApiResponse ares = await king.lip.api(
      EndpointsV1.chatGetById,
      payload: {
        'ChatId': chatId,
        'AfterTime': afterTime,
      },
    );

    final chat = byId[chatId];
    chat!.unpackFromApi(ares.body);
  }

  void getNewMsgs(String chatId) async {
    var chat = byId[chatId]!;
    ApiResponse ares = await king.lip.api(
      EndpointsV1.chatGetById,
      payload: {
        'ChatId': chatId,
        'AfterTime': chat.lastMsgTime,
      },
    );

    chat.unpackMsgs(ares.body);
  }
}

class Chat = ChatBase with _$Chat;

abstract class ChatBase with Store {
  final ObservableList<Msg> msgs = ObservableList();

  bool isInitialLoad = true;
  @observable
  String surferId = '';
  @observable
  String chatId = '';
  @observable
  String teaser = '';
  @observable
  String teaserSurferId = '';
  @observable
  int lastMsgTime = 0;

  void unpackFromApi(Map<String, dynamic> jin) {
    chatId = readString(jin, 'chatId');
    surferId = readString(jin, 'surferId');
    teaser = readString(jin, 'teaser');
    teaserSurferId = readString(jin, 'teaserSurferId');
    lastMsgTime = readInt(jin, 'LastMsgTime');

    unpackMsgs(jin);

    isInitialLoad = false;
  }

  void unpackMsgs(Map<String, dynamic> jin) {
    if (jin.containsKey('Msgs')) {
      for (final item in jin['Msgs']!) {
        var msg = Msg.fromJson(item);
        msgs.add(msg);
      }
    }
  }
}

class Msg {
  Msg({
    this.body = '',
    this.chatId = '',
    this.msgId = '',
    this.surferId = '',
    this.timeCreated = 0,
    this.timeUpdated = 0,
  });

  final String body;
  final String chatId;
  final String msgId;
  final String surferId;
  final int timeCreated;
  final int timeUpdated;

  DateTime get timeCreatedAsDateTime {
    return DateTime(timeCreated);
  }

  String username = 'placeholder';

  factory Msg.fromJson(Map<String, dynamic> jin) => Msg(
        body: readString(jin, 'body'),
        chatId: readString(jin, 'chatId'),
        msgId: readString(jin, 'chatId'),
        surferId: readString(jin, 'surferId'),
        timeCreated: readInt(jin, 'timeCreated'),
        timeUpdated: readInt(jin, 'timeUpdated'),
      );

  String get timeReadable {
    return '4:21 pm';
  }
}
