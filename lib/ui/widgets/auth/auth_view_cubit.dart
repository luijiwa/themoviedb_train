import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:themoviedb_example/domain/api_client/api_client_exeption.dart';
import 'package:themoviedb_example/domain/blocks/auth_bloc.dart';

abstract class AuthViewCubitState {}

class AuthViewCubitFormFillInProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthViewCubitFormFillInProgressState &&
        other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => 0;
}

class AuthViewCubitErrorState extends AuthViewCubitState {
  final String errorMessage;

  AuthViewCubitErrorState(this.errorMessage);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthViewCubitErrorState &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => errorMessage.hashCode;
}

class AuthViewCubitAuthProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthViewCubitAuthProgressState &&
        other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => 0;
}

class AuthViewCubitSuccessAuthState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthViewCubitSuccessAuthState &&
        other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => 0;
}

class AuthViewCubit extends Cubit<AuthViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  AuthViewCubit(AuthViewCubitState initialState, this.authBloc)
      : super(initialState) {
    _onState(authBloc.state);
    authBlocSubscription = authBloc.stream.listen(_onState);
  }

  bool _isValid(String login, String password) =>
      login.isNotEmpty || password.isNotEmpty;

  void auth({
    required String login,
    required String password,
  }) {
    if (!_isValid(login, password)) {
      final state = AuthViewCubitErrorState('Заполните логин и пароль');
      emit(state);
      return;
    }
    authBloc.add(AuthLoginEvent(login: login, password: password));
  }

  void _onState(AuthState state) {
    if (state is AuthUnauthorizedState) {
      emit(AuthViewCubitFormFillInProgressState());
    } else if (state is AuthAuthorizedState) {
      authBlocSubscription.cancel();
      emit(AuthViewCubitSuccessAuthState());
    } else if (state is AuthFailureState) {
      final message = _mapErrorToMessage(state.error);
      emit(AuthViewCubitErrorState(message));
    } else if (state is AuthInProgessState) {
      emit(AuthViewCubitAuthProgressState());
    } else if (state is AuthCheckStatusInProgessState) {
      emit(AuthViewCubitAuthProgressState());
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is! ApiClientException) {
      return 'Неизвестная ошибка, повтори попытку';
    }
    switch (error.type) {
      case ApiClientExceptionType.network:
        return 'Server ne dostupen. Prover internet, dolboeb';
      case ApiClientExceptionType.auth:
        return 'Login ili parol ne pravilno, dolboeb';
      case ApiClientExceptionType.sessionExpired:
      case ApiClientExceptionType.other:
        return 'Proizoshol pizdec. Poprobuy again, dolboeb';
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}
