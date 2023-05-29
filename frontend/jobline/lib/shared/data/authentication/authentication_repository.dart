import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:jobline/shared/data/authentication/authentication_api.dart';
import 'package:jobline/shared/data/network_client/dio_client.dart';
import 'package:jobline/shared/data/network_client/dio_exception.dart';

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  final AuthenticationApi authenticationApi = AuthenticationApi();
  final DioClient dio = DioClient();

  AuthenticationRepository();

  /// Creates a new user with the provided[name], [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> signUp(
      {required String fname,
      required String eMail,
      required String role,
      required String password}) async {
    try {
      final response = await authenticationApi.signUpApi(
        fname: fname,
        email: eMail,
        role: role,
        password: password,
      );
      print(response);

      print('repo response ${response.data}');
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e, isAuthentication: true);
    }
  }

  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  // Future<void> logInWithGoogle() async {
  //   try {
  //     late final firebase_auth.AuthCredential credential;
  //     if (isWeb) {
  //       final googleProvider = firebase_auth.GoogleAuthProvider();
  //       final userCredential = await _firebaseAuth.signInWithPopup(
  //         googleProvider,
  //       );
  //       credential = userCredential.credential!;
  //     } else {
  //       final googleUser = await _googleSignIn.signIn();
  //       final googleAuth = await googleUser!.authentication;
  //       credential = firebase_auth.GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //     }

  //     await _firebaseAuth.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     throw LogInWithGoogleFailure.fromCode(e.code);
  //   } catch (_) {
  //     throw const LogInWithGoogleFailure();
  //   }
  // }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logIn({
    String? email,
    required String password,
  }) async {
    try {
      final response = await authenticationApi.logInApi(
        email: email,
        password: password,
      );

      print('repo response ${response.data}');

      // Map<String, dynamic> respMap = response as Map<String, dynamic>;

      // String token = respMap['data']['accessToken'] as String;
      // String? refreshToken = respMap['data']['refreshToken'] as String?;
      // String emailResp = respMap['data']['email'] as String;
      // String familyId = respMap['data']['familyId'] as String;
      // String guardianId = respMap['data']['guardianId'] as String;
      // String parentName = respMap['data']['parentName'] as String;
      // String phone = respMap['data']['phoneNumber'] as String;
      // bool isPrimaryguardian =
      //     respMap['data']["guardianType"] == "primary" ? true : false;

      // var appBox = Hive.box('appBox');
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e, isAuthentication: true);
    }
  }

  Future<bool> forgotPassword(String strEmail) async {
    try {
      final response =
          await authenticationApi.forgotPasswordApi(email: strEmail);

      print("forgotPassword resp: ${response.toString()}");
      //print("forgotPassword resp eeee: ${response.e}");

      return response.data['success'];
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  // Future<void> logOut() async {
  //   try {
  //     final response = await authenticationApi.logOutApi();
  //     return response;
  //   } on DioError catch (e) {
  //     throw DioExceptions.fromDioError(e);
  //   }
  // }
  Future<void> logOut({bool routeToLoginPage = true}) async {
    try {
      final appBox = Hive.box("appBox");
      await appBox.clear();
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}
