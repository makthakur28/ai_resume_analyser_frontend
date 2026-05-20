import 'package:equatable/equatable.dart';
import '../../data/models/career_kit_model.dart';

abstract class CareerKitState extends Equatable {
  const CareerKitState();

  @override
  List<Object?> get props => [];
}

class CareerKitInitial extends CareerKitState {}

class CareerKitLoading extends CareerKitState {}

class CareerKitLoaded extends CareerKitState {
  final CareerKitModel kit;

  const CareerKitLoaded(this.kit);

  @override
  List<Object?> get props => [kit];
}

class CareerKitError extends CareerKitState {
  final String message;

  const CareerKitError(this.message);

  @override
  List<Object?> get props => [message];
}
