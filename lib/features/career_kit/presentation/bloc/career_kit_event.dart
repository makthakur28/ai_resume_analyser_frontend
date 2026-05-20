import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class CareerKitEvent extends Equatable {
  const CareerKitEvent();

  @override
  List<Object?> get props => [];
}

class GenerateKitEvent extends CareerKitEvent {
  final Uint8List fileBytes;
  final String fileName;
  final String targetRole;
  final String? companyName;
  final String? tone;

  const GenerateKitEvent({
    required this.fileBytes,
    required this.fileName,
    required this.targetRole,
    this.companyName,
    this.tone,
  });

  @override
  List<Object?> get props => [fileBytes, fileName, targetRole, companyName, tone];
}

class ResetCareerKitEvent extends CareerKitEvent {}
