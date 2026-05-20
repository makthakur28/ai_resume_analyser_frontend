import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class ResumeEvent extends Equatable {
  const ResumeEvent();

  @override
  List<Object?> get props => [];
}

class OptimizeResumeEvent extends ResumeEvent {
  final Uint8List fileBytes;
  final String fileName;

  const OptimizeResumeEvent({required this.fileBytes, required this.fileName});

  @override
  List<Object?> get props => [fileBytes, fileName];
}

class ResetResumeEvent extends ResumeEvent {}
