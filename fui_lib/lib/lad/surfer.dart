import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'package:fui_lib/fui_lib.dart';

part 'surfer.g.dart';

class SurferProxy {
  SurferProxy({required this.surferCache, required this.king});
  final Cache<Surfer> surferCache;
  final King king;

  Surfer getById(String surferId) {
    return surferCache.getItem(
      surferId,
      EndpointsV1.surferGetById,
      unpackSurferFromApi,
      payload: {'SurferId': surferId},
    );
  }
}

unpackSurferFromApi(Map<String, dynamic> body, SurferBase tt) {
  var temp = readString(body, 'SurferId');
  if (tt.surferId != temp) {
    tt.surferId = temp;
  }
  temp = readString(body, 'Email');
  if (tt.email != temp) {
    tt.email = temp;
  }
  temp = readString(body, 'Phone');
  if (tt.phone != temp) {
    tt.phone = temp;
  }
}

class Surfer = SurferBase with _$Surfer;

abstract class SurferBase with Store {
  @observable
  String surferId = '';
  @observable
  String email = '';
  @observable
  String phone = '';

  Future<void> loadFromApi(
    BuildContext context,
    String surferId,
  ) async {
    if (surferId == '') {
      return;
    }

    ApiResponse ares = await King.of(context).lip.api(
      EndpointsV1.surferGetById,
      payload: {'SurferId': surferId},
    );
    unpackFromApi(ares.body);
  }

  void unpackFromApi(Map<String, dynamic> body) {
    unpackSurferFromApi(body, this);
    //var temp = readString(body, 'SurferId');
    //if (surferId != temp) {
    //surferId = temp;
    //}
    //temp = readString(body, 'Email');
    //if (email != temp) {
    //email = temp;
    //}
    //temp = readString(body, 'Phone');
    //if (phone != temp) {
    //phone = temp;
    //}
  }

  void loadFromAltSurfer(Surfer alt) {
    surferId = alt.surferId;
    email = alt.email;
    phone = alt.phone;
  }
}
