import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Scanner Events
abstract class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object?> get props => [];
}

class InitiateScanEvent extends ScannerEvent {
  const InitiateScanEvent();
}

class EstimateWasteEvent extends ScannerEvent {
  final String imagePath;

  const EstimateWasteEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class UploadWastePhotoEvent extends ScannerEvent {
  final String imagePath;
  final String wasteType;
  final int quantity;

  const UploadWastePhotoEvent({
    required this.imagePath,
    required this.wasteType,
    required this.quantity,
  });

  @override
  List<Object?> get props => [imagePath, wasteType, quantity];
}

// Scanner States
abstract class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object?> get props => [];
}

class ScannerInitial extends ScannerState {
  const ScannerInitial();
}

class ScannerProcessing extends ScannerState {
  const ScannerProcessing();
}

class ScanResultReady extends ScannerState {
  final String wasteType;
  final double estimatedPrice;
  final String confidence;

  const ScanResultReady({
    required this.wasteType,
    required this.estimatedPrice,
    required this.confidence,
  });

  @override
  List<Object?> get props => [wasteType, estimatedPrice, confidence];
}

class UploadInProgress extends ScannerState {
  const UploadInProgress();
}

class UploadSuccess extends ScannerState {
  final String message;
  final double earnedAmount;

  const UploadSuccess({
    required this.message,
    required this.earnedAmount,
  });

  @override
  List<Object?> get props => [message, earnedAmount];
}

class ScannerError extends ScannerState {
  final String message;

  const ScannerError(this.message);

  @override
  List<Object?> get props => [message];
}

// Scanner BLoC
class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(const ScannerInitial()) {
    on<InitiateScanEvent>(_onInitiateScan);
    on<EstimateWasteEvent>(_onEstimate);
    on<UploadWastePhotoEvent>(_onUpload);
  }

  Future<void> _onInitiateScan(
      InitiateScanEvent event, Emitter<ScannerState> emit) async {
    emit(const ScannerProcessing());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(const ScanResultReady(
        wasteType: 'Plastic',
        estimatedPrice: 2.50,
        confidence: '92%',
      ));
    } catch (e) {
      emit(ScannerError(e.toString()));
    }
  }

  Future<void> _onEstimate(
      EstimateWasteEvent event, Emitter<ScannerState> emit) async {
    emit(const ScannerProcessing());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(const ScanResultReady(
        wasteType: 'Glass',
        estimatedPrice: 5.00,
        confidence: '88%',
      ));
    } catch (e) {
      emit(ScannerError(e.toString()));
    }
  }

  Future<void> _onUpload(
      UploadWastePhotoEvent event, Emitter<ScannerState> emit) async {
    emit(const UploadInProgress());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(UploadSuccess(
        message: '${event.wasteType} uploaded successfully',
        earnedAmount: event.quantity * 2.50,
      ));
    } catch (e) {
      emit(ScannerError(e.toString()));
    }
  }
}
