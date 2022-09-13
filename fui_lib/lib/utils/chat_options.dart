import 'package:mobx/mobx.dart';

part 'chat_options.g.dart';

class ChatOptions = ChatOptionsBase with _$ChatOptions;

abstract class ChatOptionsBase with Store {
  @observable
  String phone = '';
}
