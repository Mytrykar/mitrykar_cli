import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'provider.dart';

part 'event.dart';
part 'state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ExampleProvider provider = ExampleProvider();
  ExampleBloc() : super(InitialState()) {
    on<GetApiEvent>((event, emit) async {
      emit(LoadingState());
      await Future.delayed(const Duration(seconds: 2));
      emit(DoneState());
    });
  }
}
