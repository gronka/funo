import 'package:mobx/mobx.dart';

import 'package:fui_lib/fui_lib.dart';

part 'chat.g.dart';

class Chats {
  Chats(this.king);
  final ObservableMap<String, Chat> byId = ObservableMap();
  bool isInitialLoad = true;
  King king;

  Future<void> loadAllChatsFromApiInitial() async {
    if (isInitialLoad) {
      loadAllChatsFromApi();
    }
    isInitialLoad = false;
  }

  Future<void> loadAllChatsFromApi() async {
    ApiResponse ares = await king.lip.api(EndpointsV1.chatsGetList);
    if (ares.body.containsKey('Collection')) {
      for (final item in ares.body['Collection']!) {
        var chat = makeChat();
        chat.unpackFromApi(item);
        if (!byId.containsKey(chat.chatId)) {
          byId[chat.chatId] = chat;
        }
      }
    }
  }

  Chat getChatById(String chatId) {
    if (!byId.containsKey(chatId)) {
      byId[chatId] = makeChat();
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

  Chat makeChat() {
    final chat = Chat();
    chat.king = king;
    return chat;
  }
}

class Chat = ChatBase with _$Chat;

abstract class ChatBase with Store {
  final ObservableList<Msg> msgs = ObservableList();

  King? king;
  bool isInitialLoad = true;
  @observable
  String surferId = '';
  @observable
  String chatId = '';
  @observable
  String teaser = '';
  @observable
  String teaserSurferId = '';

  @computed
  int get lastMsgTime {
    if (msgs.isNotEmpty) {
      return msgs[0].timeCreated;
    }
    return 0;
  }

  //@computed
  //String get phone {
  //final surfer = king!.lad.surferProxy.getById(surferId);
  //return surfer.phone;
  //}

  void unpackFromApi(Map<String, dynamic> jin) {
    chatId = readString(jin, 'ChatId');
    surferId = readString(jin, 'SurferId');
    teaser = readString(jin, 'Teaser');
    teaserSurferId = readString(jin, 'TeaserSurferId');

    unpackMsgs(jin);

    isInitialLoad = false;
  }

  void unpackMsgs(Map<String, dynamic> jin) {
    if (jin.containsKey('Msgs')) {
      //TODO append to msgs instead of refreshing all
      msgs.clear();
      for (final item in jin['Msgs']!) {
        var msg = Msg.fromJson(item);
        msgs.add(msg);
      }
    }
  }

  void unpackCollection(Map<String, dynamic> jin) {
    if (jin.containsKey('Collection')) {
      //TODO append to msgs instead of refreshing all
      msgs.clear();
      for (final item in jin['Collection']!) {
        var msg = Msg.fromJson(item);
        msgs.add(msg);
      }
    }
  }

  Future<void> getNewMsgsByChatIdFromApi() async {
    if (chatId == '') {
      return;
    }

    var afterTime = 0;
    if (msgs.isNotEmpty) {
      afterTime = msgs[0].timeCreated;
    }

    ApiResponse ares = await king!.lip.api(
      EndpointsV1.chatMsgsGetById,
      payload: {
        'ChatId': chatId,
        'AfterTime': afterTime,
      },
    );

    unpackCollection(ares.body);
  }
}

class Msg {
  Msg({
    this.content = '',
    this.chatId = '',
    this.msgId = '',
    this.senderSurferId = '',
    this.timeCreated = 0,
    this.timeUpdated = 0,
  });

  final String content;
  final String chatId;
  final String msgId;
  final String senderSurferId;
  final int timeCreated;
  final int timeUpdated;

  DateTime get timeCreatedAsDateTime {
    return DateTime(timeCreated);
  }

  String username = 'placeholder';

  factory Msg.fromJson(Map<String, dynamic> jin) => Msg(
        content: readString(jin, 'Content'),
        chatId: readString(jin, 'ChatId'),
        msgId: readString(jin, 'MsgId'),
        senderSurferId: readString(jin, 'SenderSurferId'),
        timeCreated: readInt(jin, 'TimeCreated'),
        timeUpdated: readInt(jin, 'TimeUpdated'),
      );

  String get timeReadable {
    return '4:21 pm';
  }
}
