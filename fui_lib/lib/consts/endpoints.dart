class EndpointsV1 {
  static const String developerPrivacy = 'developer/privacy.latest';
  static const String developerTerms = 'developer/terms.latest';
  static const String surferPrivacy = 'surfer/privacy.latest';

  static const String plog = 'v1/plog';

  static const String surferGetById = 'v1/surfer/get.byId';

  static const String toddGetById = 'v1/todd/get.byId';
  static const String toddRegisterWithEmail = 'v1/todd/register.withEmail';
  static const String toddSignInWithApple = 'v1/todd/signIn.withApple';
  static const String toddSignInWithEmail = 'v1/todd/signIn.withEmail';
  static const String toddSignInWithGoogle = 'v1/todd/signIn.withGoogle';
  static const String toddSignOut = 'v1/todd/signOut';
  static const String toddJwtRefresh = 'v1/todd/jwt.refresh';

  static const String chatGetById = 'v1/chat/get.byId';
  static const String chatGetByPhone = 'v1/chat/get.byPhone';
  static const String chatMsgsGetByPhone = 'v1/chatMsgs/get.byPhone';
  static const String chatMsgsGetById = 'v1/chatMsgs/get.byId';
  static const String chatSendMsg = 'v1/chat/sendMsg';
  static const String chatsGetList = 'v1/chats/get.list';
}
