// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Chat on ChatBase, Store {
  Computed<int>? _$lastMsgTimeComputed;

  @override
  int get lastMsgTime => (_$lastMsgTimeComputed ??=
          Computed<int>(() => super.lastMsgTime, name: 'ChatBase.lastMsgTime'))
      .value;

  late final _$surferIdAtom = Atom(name: 'ChatBase.surferId', context: context);

  @override
  String get surferId {
    _$surferIdAtom.reportRead();
    return super.surferId;
  }

  @override
  set surferId(String value) {
    _$surferIdAtom.reportWrite(value, super.surferId, () {
      super.surferId = value;
    });
  }

  late final _$chatIdAtom = Atom(name: 'ChatBase.chatId', context: context);

  @override
  String get chatId {
    _$chatIdAtom.reportRead();
    return super.chatId;
  }

  @override
  set chatId(String value) {
    _$chatIdAtom.reportWrite(value, super.chatId, () {
      super.chatId = value;
    });
  }

  late final _$teaserAtom = Atom(name: 'ChatBase.teaser', context: context);

  @override
  String get teaser {
    _$teaserAtom.reportRead();
    return super.teaser;
  }

  @override
  set teaser(String value) {
    _$teaserAtom.reportWrite(value, super.teaser, () {
      super.teaser = value;
    });
  }

  late final _$teaserSurferIdAtom =
      Atom(name: 'ChatBase.teaserSurferId', context: context);

  @override
  String get teaserSurferId {
    _$teaserSurferIdAtom.reportRead();
    return super.teaserSurferId;
  }

  @override
  set teaserSurferId(String value) {
    _$teaserSurferIdAtom.reportWrite(value, super.teaserSurferId, () {
      super.teaserSurferId = value;
    });
  }

  @override
  String toString() {
    return '''
surferId: ${surferId},
chatId: ${chatId},
teaser: ${teaser},
teaserSurferId: ${teaserSurferId},
lastMsgTime: ${lastMsgTime}
    ''';
  }
}
