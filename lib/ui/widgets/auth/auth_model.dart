import 'dart:async';

import 'package:flutter/material.dart';

import 'package:themoviedb_example/domain/api_client/api_client_exeption.dart';
import 'package:themoviedb_example/ui/navigation/main_navigation_actions.dart';

abstract class AuthViewModelLoginProvider {
  Future<void> login(String login, String password);
}

class AuthViewModel extends ChangeNotifier {
  final MainNavigatioActions mainNavigatioActions;
  final AuthViewModelLoginProvider loginProvider;

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  bool _isValid(String login, String password) =>
      login.isNotEmpty || password.isNotEmpty;

  AuthViewModel({
    required this.mainNavigatioActions,
    required this.loginProvider,
  });

  Future<String?> _login(String login, String password) async {
    try {
      await loginProvider.login(login, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          return 'Server ne dostupen. Prover internet, dolboeb';
        case ApiClientExceptionType.auth:
          return 'Login ili parol ne pravilno, dolboeb';
        case ApiClientExceptionType.other:
          return 'Proizoshol pizdec. Poprobuy again, dolboeb';
        case ApiClientExceptionType.sessionExpired:
          // Сделал чтобы не жаловался
          break;
      }
    } catch (e) {
      return 'Неизвестная ошибка, повторите попытку';
    }
    return null;
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (!_isValid(login, password)) {
      _updateState('Заполните логин и пароль', false);
      return;
    }
    _updateState(null, true);

    _errorMessage = await _login(login, password);
    if (_errorMessage == null) {
      mainNavigatioActions.resetNavigation(context);
    } else {
      _updateState(_errorMessage, false);
    }
  }

  void _updateState(String? errorMessage, bool iisAuthProgress) {
    if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
      return;
    }
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
  }
}
