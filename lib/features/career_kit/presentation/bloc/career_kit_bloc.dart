import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/career_kit_repository.dart';
import 'career_kit_event.dart';
import 'career_kit_state.dart';

class CareerKitBloc extends Bloc<CareerKitEvent, CareerKitState> {
  final CareerKitRepository repository;

  CareerKitBloc({required this.repository}) : super(CareerKitInitial()) {
    on<GenerateKitEvent>(_onGenerateKit);
    on<ResetCareerKitEvent>((event, emit) => emit(CareerKitInitial()));
  }

  Future<void> _onGenerateKit(GenerateKitEvent event, Emitter<CareerKitState> emit) async {
    emit(CareerKitLoading());
    try {
      final kit = await repository.generateKit(
        fileBytes: event.fileBytes,
        fileName: event.fileName,
        targetRole: event.targetRole,
        companyName: event.companyName,
        tone: event.tone,
      );
      emit(CareerKitLoaded(kit));
    } catch (e) {
      emit(CareerKitError(e.toString()));
    }
  }
}
