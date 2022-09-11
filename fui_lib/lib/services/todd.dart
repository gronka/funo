import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:mobx/mobx.dart';

import 'package:fui_lib/fui_lib.dart';

part 'todd.g.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
// Optional clientId
// clientId: '...m2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
  ],
);

enum AuthStatus {
  errored,
  initialized,
  loading,
  signedIn,
  signedOut,
}

class Todd = ToddBase with _$Todd;

abstract class ToddBase with Store {
  ToddBase(this.king);

  King king;
  @observable
  ClockFormat clockFormat = ClockFormat.twentyFour;
  @observable
  String developerId = '';
  String jwt = '';
  String sessionJwt = '';
  @observable
  String locale = 'en';
  @observable
  AuthStatus status = AuthStatus.initialized;
  @observable
  String stripeCustomerId = '';
  @observable
  String surferId = '';
  @observable
  ToddMode toddMode = ToddMode.none;

  @observable
  bool isAppleAccount = false;
  @observable
  bool isGoogleAccount = false;
  int googleLastRefresh = 0;

  //GoogleSignInAccount? _googleAccount;

  Todd of(BuildContext context) {
    return King.of(context).todd;
  }

  @action
  Future<void> refreshJwt() async {
    ApiResponse ares = await king.lip.api(
      toddMode.refreshEndpoint,
      payload: {
        'session_jwt': sessionJwt,
      },
    );

    if (ares.isOk) {
      if (ares.body.containsKey('new_jwt')) {
        jwt = ares.body['new_jwt'];
        if (jwt.isEmpty) {
          signOut();
        }
      } else {
        signOut();
      }
    } else {
      signOut();
    }
  }

  @action
  void processSignInResponse(ApiResponse ares) {
    if (ares.body.containsKey('new_jwt')) {
      jwt = ares.body['new_jwt'];
    }

    if (ares.body.containsKey('session_jwt')) {
      sessionJwt = ares.body['session_jwt'];
    }

    developerId = ares.body['developer_id'] ?? '';
    stripeCustomerId = ares.body['stripe_customer_id'] ?? '';
    surferId = ares.body['surfer_id'] ?? '';

    isAppleAccount = ares.body['is_apple_account'] ?? false;
    isGoogleAccount = ares.body['is_google_account'] ?? false;
    print('developer_id from server is +$developerId+');
    print('surfer_id from server is +$surferId+');

    if (jwt.isNotEmpty) {
      if (developerId.isNotEmpty) {
        status = AuthStatus.signedIn;
        updateLogin(
          developerIdIn: developerId,
          jwtIn: jwt,
          sessionJwtIn: sessionJwt,
          surferIdIn: '',
          stripeCustomerIdIn: stripeCustomerId,
          isAppleAccount: isAppleAccount,
          isGoogleAccount: isGoogleAccount,
        );
      } else if (surferId.isNotEmpty) {
        status = AuthStatus.signedIn;
        updateLogin(
          developerIdIn: '',
          jwtIn: jwt,
          sessionJwtIn: sessionJwt,
          surferIdIn: surferId,
          stripeCustomerIdIn: '',
          isAppleAccount: isAppleAccount,
          isGoogleAccount: isGoogleAccount,
        );
      }
      print('process sign in success');
    } else {
      updateLogin(
        developerIdIn: '',
        jwtIn: '',
        sessionJwtIn: '',
        surferIdIn: '',
        stripeCustomerIdIn: '',
        isAppleAccount: false,
        isGoogleAccount: false,
      );
      status = AuthStatus.errored;
      print('process sign in errored');
    }
  }

  void updateLogin({
    required String developerIdIn,
    required String jwtIn,
    required String sessionJwtIn,
    required String stripeCustomerIdIn,
    required String surferIdIn,
    required bool isAppleAccount,
    required bool isGoogleAccount,
  }) {
    developerId = developerIdIn;
    jwt = jwtIn;
    surferId = surferIdIn;
    stripeCustomerId = stripeCustomerIdIn;

    king.box.put('developerId', developerIdIn);
    king.box.put('jwt', jwtIn);
    king.box.put('sessionJwt', sessionJwtIn);
    king.box.put('surferId', surferIdIn);
    king.box.put('stripeCustomerId', stripeCustomerIdIn);

    king.box.put('isAppleAccount', isAppleAccount);
    king.box.put('isGoogleAccount', isGoogleAccount);
    king.box.put('googleLastRefresh', googleLastRefresh);
  }

  Future<void> loadLogin() async {
    developerId = king.box.get('developerId') ?? '';
    jwt = king.box.get('jwt') ?? '';
    sessionJwt = king.box.get('sessionJwt') ?? '';
    surferId = king.box.get('surferId') ?? '';
    stripeCustomerId = king.box.get('stripeCustomerId') ?? '';

    isAppleAccount = king.box.get('isAppleAccount') ?? false;
    isGoogleAccount = king.box.get('isGoogleAccount') ?? false;
    googleLastRefresh = king.box.get('googleLastRefresh') ?? 0;

    if (developerId.isNotEmpty || surferId.isNotEmpty) {
      status = AuthStatus.signedIn;
    }

    if (googleNeedsRefresh) {
      signInWithGoogle();
    }

    if (appleNeedsRefresh) {
      signInWithApple();
    }
  }

  @computed
  bool get appleNeedsRefresh {
    if (isAppleAccount) {
      // 8.64e7 = 24 hours in ms
      if (googleLastRefresh - DateTime.now().millisecondsSinceEpoch > 8.64e7) {
        return true;
      }
    }
    return false;
  }

  @computed
  bool get googleNeedsRefresh {
    if (isGoogleAccount && king.conf.isAndroid) {
      // 8.64e7 = 24 hours in ms
      if (googleLastRefresh - DateTime.now().millisecondsSinceEpoch > 8.64e7) {
        return true;
      }
    }
    return false;
  }

  void attachSessionHeaders(Map<String, String> headers) {
    if (jwt != '') {
      headers['JWT'] = jwt;
    }
  }

  @computed
  bool get isSignedIn {
    return status == AuthStatus.signedIn;
  }

  @action
  Future<void> signOut() async {
    if (sessionJwt.isNotEmpty) {
      ApiResponse ares = await king.lip.api(
        toddMode.signOutEndpoint,
        payload: {
          'session_jwt': sessionJwt,
        },
      );

      if (ares.isNotOk) {
        king.snacker.addSnack(Snacks.signOutError);
      }
    }

    signOutLocally();
  }

  void signOutLocally() {
    status = AuthStatus.signedOut;
    updateLogin(
      developerIdIn: '',
      jwtIn: '',
      sessionJwtIn: '',
      surferIdIn: '',
      stripeCustomerIdIn: '',
      isAppleAccount: false,
      isGoogleAccount: false,
    );
    king.signOutCleanup();
  }

  @action
  Future<ApiResponse> registerWithEmail({
    required String email,
    required String password,
  }) async {
    status = AuthStatus.loading;
    ApiResponse ares = await king.lip.api(
      toddMode.registerWithEmailEndpoint,
      payload: {
        'email': email,
        'password': password,
        'instance_id': king.conf.firebaseToken,
        'platform': king.conf.platform,
      },
    );

    if (ares.isOk) {
    } else {
      print('register with email failed, so forcing sign out');
      status = AuthStatus.signedOut;
    }
    return ares;
  }

  @action
  Future<ApiResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    status = AuthStatus.loading;
    ApiResponse ares = await king.lip.api(
      toddMode.signInWithEmailEndpoint,
      payload: {
        'email': email,
        'password': password,
        'instance_id': king.conf.firebaseToken,
        'platform': king.conf.platform,
      },
    );

    if (ares.isOk) {
      print('signing in with email');
      processSignInResponse(ares);
    } else {
      print('sign in with email failed');
      status = AuthStatus.signedOut;
    }
    return ares;
  }

  @action
  Future<ApiResponse> signInWithGoogle() async {
    status = AuthStatus.loading;

    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print('sign in with google failed: $error');
      status = AuthStatus.signedOut;
    }

    Map<String, String> headers =
        await _googleSignIn.currentUser?.authHeaders ?? {};
    String auth = headers['Authorization'] ?? '';
    String token = auth.replaceAll('Bearer ', '');

    ApiResponse ares = await king.lip.api(
      toddMode.signInWithGoogleEndpoint,
      payload: {
        'instance_id': king.conf.firebaseToken,
        'platform': king.conf.platform,
        'token': token,
      },
    );

    if (ares.isOk) {
      print('signing in with google');
      processSignInResponse(ares);
    } else {
      print('sign in with google failed');
      signOut();
    }
    return ares;
  }

  @action
  Future<ApiResponse> signInWithApple() async {
    status = AuthStatus.loading;

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          //AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: king.conf.signInWithAppleClientId,
          redirectUri: king.conf.signInWithApplePapiCallback,
        ),
      );

      ApiResponse ares = await king.lip.api(
        toddMode.signInWithAppleEndpoint,
        payload: {
          'auth_code': credential.authorizationCode,
          //'client_id': king.conf.signInWithAppleClientId,
          //'email': credential.email ?? '',
          'id_token': credential.identityToken,
          'instance_id': king.conf.firebaseToken,
          'platform': king.conf.platform,
        },
      );

      if (ares.isOk) {
        print('signing in with apple');
        processSignInResponse(ares);
      } else {
        print('sign in with apple failed');
        signOut();
      }
      return ares;
    } catch (error) {
      status = AuthStatus.signedOut;
    }

    return ApiResponse();
  }
}
