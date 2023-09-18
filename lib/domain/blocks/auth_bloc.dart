import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:themoviedb_example/domain/api_client/account_api_client.dart';
import 'package:themoviedb_example/domain/api_client/auth_api_client.dart';
import 'package:themoviedb_example/domain/data_providers/session_data_provider.dart';

sealed class AuthEvent {} // Почему здесь сеалед а не абстракт?

final class AuthCheckStatusEvent extends AuthEvent {}

final class AuthLogoutEvent extends AuthEvent {}

final class AuthLoginEvent extends AuthEvent {
  final String login;
  final String password;

  AuthLoginEvent({
    required this.login,
    required this.password,
  });
}

sealed class AuthState {} // Почему здесь сеалед а не абстракт?

class AuthUnauthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthUnauthorizedState;

  @override
  int get hashCode => 0;
}

class AuthAuthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthAuthorizedState;

  @override
  int get hashCode => 0;
}

class AuthFailureState extends AuthState {
  final Object error;

  AuthFailureState(this.error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthFailureState && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

class AuthInProgessState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthInProgessState;

  @override
  int get hashCode => 0;
}

class AuthCheckStatusInProgessState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AuthInProgessState;

  @override
  int get hashCode => 0;
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authApiClient = AuthApiClient();
  final _accountApiClient = AccountApiClient();
  final _sessionDataProvider = SessionDataProvider();
  AuthBloc(AuthState initialState) : super(initialState) {
    on<AuthEvent>(
      (event, emit) async {
        if (event is AuthCheckStatusEvent) {
          await onAuthCheckStatusEvent(event, emit);
        } else if (event is AuthLoginEvent) {
          await onAuthLoginEvent(event, emit);
        } else if (event is AuthLogoutEvent) {
          await onAuthLogoutEvent(event, emit);
        }
      },
      transformer: sequential(),
    );
    add(AuthCheckStatusEvent());
  }
  Future<void> onAuthCheckStatusEvent(
      AuthCheckStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthInProgessState());
    final sessionId = await _sessionDataProvider.getSessionId();
    final newState =
        sessionId != null ? AuthAuthorizedState() : AuthUnauthorizedState();
    emit(newState);
  }

  Future<void> onAuthLoginEvent(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthInProgessState());
      final sessionId = await _authApiClient.auth(
        username: event.login,
        password: event.password,
      );
      final accountId = await _accountApiClient.getAccountInfo(sessionId);
      await _sessionDataProvider.setSessionId(sessionId);
      await _sessionDataProvider.setAccountId(accountId);
      emit(AuthAuthorizedState());
    } catch (e) {
      emit(AuthFailureState(e));
    }
  }

  Future<void> onAuthLogoutEvent(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _sessionDataProvider.deleteSessionId();
      await _sessionDataProvider.deleteAccountId();
    } catch (e) {
      emit(AuthFailureState(e));
    }
  }
}
