import 'dart:async';

import 'package:fui_lib/fui_lib.dart';

class Cache<T> {
  Cache(this.king, this.creator);
  final T Function() creator;
  King king;

  Map<String, T> cachedItems = {};
  Map<String, int> cachedTimes = {};
  Map<String, int> erroredTimes = {};
  Set<String> flaggedForUpdate = {};
  Set<String> requestInProgress = {};

  T makeNewCacheItem(String id) {
    final item = creator();
    initWrapper(item, id, king);
    return item;
  }

  T getItem(
    String id,
    String getUrl,
    Function unpackFunction, {
    Map<String, String>? payload,
  }) {
    T item = cachedItems.putIfAbsent(id, () => makeNewCacheItem(id));
    if (_shouldUpdate(id)) {
      _fetchWrapper(id, getUrl, unpackFunction, payload: payload);
    }
    return item;
  }

  T getItemFresh(
    String id,
    String getUrl,
    Function unpackFunction, {
    Map<String, String>? payload,
  }) {
    T item = cachedItems.putIfAbsent(id, () => makeNewCacheItem(id));
    if (_shouldUpdateForFresh(id)) {
      _fetchWrapper(id, getUrl, unpackFunction, payload: payload);
    }
    return item;
  }

  Future<T> getItemBlocking(
    String id,
    String getUrl,
    Function unpackFunction, {
    Map<String, String>? payload,
  }) async {
    T item = cachedItems.putIfAbsent(id, () => makeNewCacheItem(id));
    if (_shouldUpdate(id)) {
      await _fetchWrapper(id, getUrl, unpackFunction, payload: payload);
    }
    return item;
  }

  T getItemRef(String id) {
    T item = cachedItems.putIfAbsent(id, () => makeNewCacheItem(id));
    return item;
  }

  void setItem(String id, T item) {
    var cachedItem = cachedItems[id];
    if (cachedItem == null) {
      cachedItems[id] = item;
    } else {
      throw ImpossibleException(
          'We should never reach this case. Reaching this case means that we need to write a new function to unpack data into the existing cachedItem. If we overwrite the cachedItem, then we will lose references to the mobx items.');
    }
    cachedTimes[id] = DateTime.now().millisecondsSinceEpoch;
    erroredTimes.remove(id);
    flaggedForUpdate.remove(id);
  }

  Future<void> _fetchWrapper(
    String id,
    String getUrl,
    Function unpackFunction, {
    Map<String, String>? payload,
  }) async {
    payload ??= {'Id': id};

    requestInProgress.add(id);
    ApiResponse ares = await king.lip.api(getUrl, payload: payload);
    requestInProgress.remove(id);
    flaggedForUpdate.remove(id);
    erroredTimes.remove(id);

    if (ares.errored) {
      flaggedForUpdate.add(id);
      erroredTimes[id] = DateTime.now().millisecondsSinceEpoch;
    }

    if (ares.isOk) {
      var target = cachedItems[id];
      unpackFunction(ares.body, target);
      cachedTimes[id] = DateTime.now().millisecondsSinceEpoch;
    } else {
      // we could send the user an error
    }
  }

  bool _shouldUpdateForFresh(String id) {
    if (id == '') {
      print('_shouldUpdateForFresh false: id is blank');
      return false;
    }

    if (requestInProgress.contains(id)) {
      print('_shouldUpdateForFresh false: requestInProgress');
      return false;
    }

    int timeNow = DateTime.now().millisecondsSinceEpoch;
    int timeCached = cachedTimes[id] ?? 0;
    if (timeNow - timeCached < 1000) {
      print('_shouldUpdateForFresh false: cachedTime < 1 second');
      return false;
    }

    print('_shouldUpdateForFresh: true');
    return true;
  }

  bool _shouldUpdate(String id) {
    if (id == '') {
      print('_shouldUpdate false since id is blank');
      return false;
    }

    if (requestInProgress.contains(id)) {
      print('_shouldUpdate false since req in progress');
      return false;
    }

    if (!cachedItems.containsKey(id)) {
      //NOTE: this case should never trigger because we put an item in the cache
      // before we even attempt to update the cache
      print('_shouldUpdate true since cachedItem does not exist');
      return true;
    }

    if (flaggedForUpdate.contains(id)) {
      print('_shouldUpdate true since flagged');
      return true;
    }

    int timeNow = DateTime.now().millisecondsSinceEpoch;
    int timeCached = cachedTimes[id] ?? 0;
    int timeErrored = erroredTimes[id] ?? timeNow;
    //int cacheExpireMinutes = king.conf.cacheTimeoutMinutes;
    if ((timeNow - timeErrored > 2000) || (timeNow - timeCached > 3 * 60000)) {
      print('_shouldUpdate true since cachedTime expired');
      return true;
    }

    print('should update false since no reason found');
    return false;
  }
}

void initWrapper(dynamic item, String id, King king) async {
  switch (item.runtimeType) {
    //case ChannelSub:
    //item.king = king;
    //item.loadLocal();
    //break;

    //case NetworkSub:
    //item.king = king;
    //item.loadLocal();
    //break;

    default:
      break;
  }
}
