import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb_example/ui/navigation/main_navigation.dart';
import 'package:themoviedb_example/ui/widgets/loader_widget/loader_view_cubit.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderViewCubit, LoaderViewCubitState>(
      listenWhen: (prev, current) => current != LoaderViewCubitState.unknown,
      listener: _onLoaderViewCubitStateStateChange,
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  void _onLoaderViewCubitStateStateChange(
    BuildContext context,
    LoaderViewCubitState state,
  ) {
    final nextScreen = state == LoaderViewCubitState.autorized
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}
