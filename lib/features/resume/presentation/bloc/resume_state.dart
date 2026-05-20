import 'package:equatable/equatable.dart';
import '../../data/models/resume_model.dart';

abstract class ResumeState extends Equatable {
  const ResumeState();

  @override
  List<Object?> get props => [];
}

class ResumeInitial extends ResumeState {}

class ResumeLoading extends ResumeState {}

class ResumeOptimized extends ResumeState {
  final ResumeResultModel result;

  const ResumeOptimized(this.result);

  @override
  List<Object?> get props => [result];
}

class ResumeError extends ResumeState {
  final String message;

  const ResumeError(this.message);

  @override
  List<Object?> get props => [message];
}
