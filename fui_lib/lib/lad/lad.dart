import 'package:mobx/mobx.dart';

import 'package:fui_lib/king.dart';
import 'package:fui_lib/lad/cache.dart';
import 'package:fui_lib/lad/chat.dart';
import 'package:fui_lib/lad/surfer.dart';

export 'package:fui_lib/lad/chat.dart';
export 'package:fui_lib/lad/surfer.dart';

class Lad {
  final King king;

  late final Chats chats;
  //final ObservableList<Bill> bills = ObservableList();

  //late final Cache<ChannelSub> channelSubCache;
  //late final Cache<ObservableList<String>> channelSubIdsByNetworkSubIdCache;
  //late final ChannelSubProxy channelSubProxy;
  late final Cache<Surfer> surferCache;
  late final SurferProxy surferProxy;

  Lad(this.king) {
    chats = Chats(king);

    surferCache = Cache<Surfer>(king, Surfer.new);
    surferProxy = SurferProxy(surferCache: surferCache, king: king);

    //channelSubIdsByNetworkSubIdCache =
    //Cache<ObservableList<String>>(king, ObservableList.new);
    //channelSubProxy = ChannelSubProxy(
    //channelSubCache: channelSubCache,
    //channelSubIdsByNetworkSubIdCache: channelSubIdsByNetworkSubIdCache,
    //king: king,
    //);
  }
}
