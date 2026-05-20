import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/resume_repository.dart';
import 'resume_event.dart';
import 'resume_state.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final ResumeRepository repository;

  ResumeBloc({required this.repository}) : super(ResumeInitial()) {
    on<OptimizeResumeEvent>(_onOptimizeResume);
    on<ResetResumeEvent>((event, emit) => emit(ResumeInitial()));
  }

  Future<void> _onOptimizeResume(OptimizeResumeEvent event, Emitter<ResumeState> emit) async {
    emit(ResumeLoading());
    try {
      final result = await repository.optimizeAndAnalyzeResume(event.fileBytes, event.fileName);
      emit(ResumeOptimized(result));
    } catch (e) {
      emit(ResumeError(e.toString()));
    }
  }
}
