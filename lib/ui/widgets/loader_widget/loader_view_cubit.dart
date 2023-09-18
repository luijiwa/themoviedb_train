import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:themoviedb_example/domain/blocks/auth_bloc.dart';

enum LoaderViewCubitState { unknown, autorized, notAutorized }

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;
  LoaderViewCubit(
    LoaderViewCubitState initialState,
    this.authBloc,
  ) : super(initialState) {
    Future.microtask(() {
      _onState(authBloc.state);
      authBlocSubscription = authBloc.stream.listen(_onState);
      authBloc.add(AuthCheckStatusEvent());
    });
  }

  void _onState(AuthState state) {
    if (state is AuthAuthorizedState) {
      emit(LoaderViewCubitState.autorized);
    } else if (state is AuthUnauthorizedState) {
      emit(LoaderViewCubitState.notAutorized);
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}
