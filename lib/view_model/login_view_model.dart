import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:toolivo/repo/appwrite_repo.dart';
import 'package:flutter/foundation.dart';

enum AuthState { uninitialized, initialized, unauthenticated, authenticated }

class LoginViewModel extends ChangeNotifier {
  AppwriteRepository repository = AppwriteRepository.instance;
  AuthState authState = AuthState.uninitialized;

  bool isPasswordVisible = true;

  bool loggingIn = false;

  late Account account;
  Session? session;
  User? user;
  LoginViewModel() {
    init();
  }

  init() async {
    if (kDebugMode) {
      print("Initing login view model");
    }
    account = Account(repository.client);
    authState = AuthState.initialized;
    loggingIn = true;

    notifyListeners();

    // try {
    //   user = await account.get();
    // loggingIn = false;
    // authState = AuthState.authenticated;
    // notifyListeners();
    // } catch (_) {
    //   loggingIn = false;
    //   authState = AuthState.unauthenticated;
    //   notifyListeners();
    // }
  }

  void togglePasswordVisible() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    if (email == '' || password == '') {
      return false;
    } else {
      loggingIn = true;
      notifyListeners();
      if (kDebugMode) {
        print("login result ---> $session");
      }
      try {
        session = await account.createEmailPasswordSession(
            email: email, password: password);
        user = await account.get();
        loggingIn = false;
        authState = AuthState.authenticated;
        notifyListeners();
        if (kDebugMode) {
          print("login result ---> $session");
        }
        if (session!.current) {
          return true;
        }
        return false;
      } on AppwriteException catch (e) {
        if (kDebugMode) {
          print("login exception ---> ${e.message}");
        }
        loggingIn = false;
        notifyListeners();
        return false;
      }
    }
  }

  Future<bool> checkSession() async {
    try {
      user = await account.get();
      loggingIn = false;
      if (user != null) {
        authState = AuthState.authenticated;
        notifyListeners();
        return true;
      }
      authState = AuthState.unauthenticated;
      notifyListeners();
      return false;
    } on AppwriteException catch (e) {
      if (kDebugMode) {
        print("$e");
      }
      loggingIn = false;
      authState = AuthState.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await account.deleteSessions();
    session = null;
    user = null;
    authState = AuthState.unauthenticated;
    notifyListeners();
  }
}
