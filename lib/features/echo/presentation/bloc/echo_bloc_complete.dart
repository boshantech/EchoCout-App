import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Echo Events
abstract class EchoEvent extends Equatable {
  const EchoEvent();

  @override
  List<Object?> get props => [];
}

class GetEchoSummaryEvent extends EchoEvent {
  const GetEchoSummaryEvent();
}

class GetPendingPickupsEvent extends EchoEvent {
  const GetPendingPickupsEvent();
}

class RefreshEchoEvent extends EchoEvent {
  const RefreshEchoEvent();
}

// Echo States
abstract class EchoState extends Equatable {
  const EchoState();

  @override
  List<Object?> get props => [];
}

class EchoInitial extends EchoState {
  const EchoInitial();
}

class EchoLoading extends EchoState {
  const EchoLoading();
}

class EchoLoaded extends EchoState {
  final Map<String, dynamic> summary;
  final List<Map<String, dynamic>> pickups;

  const EchoLoaded({
    required this.summary,
    required this.pickups,
  });

  @override
  List<Object?> get props => [summary, pickups];
}

class EchoError extends EchoState {
  final String message;

  const EchoError(this.message);

  @override
  List<Object?> get props => [message];
}

// Echo BLoC
class EchoBloc extends Bloc<EchoEvent, EchoState> {
  EchoBloc() : super(const EchoInitial()) {
    on<GetEchoSummaryEvent>(_onGetSummary);
    on<GetPendingPickupsEvent>(_onGetPickups);
    on<RefreshEchoEvent>(_onRefresh);
  }

  Future<void> _onGetSummary(
      GetEchoSummaryEvent event, Emitter<EchoState> emit) async {
    emit(const EchoLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final mockSummary = {
        'totalWasteSold': 245,
        'totalMoneyEarned': 6125.50,
        'pendingPickups': 3,
      };
      emit(EchoLoaded(summary: mockSummary, pickups: []));
    } catch (e) {
      emit(EchoError(e.toString()));
    }
  }

  Future<void> _onGetPickups(
      GetPendingPickupsEvent event, Emitter<EchoState> emit) async {
    try {
      if (state is EchoLoaded) {
        final currentState = state as EchoLoaded;
        await Future.delayed(const Duration(seconds: 1));
        final mockPickups = [
          {
            'id': '1',
            'collector': 'John',
            'date': 'Tomorrow, 10:00 AM',
            'amount': 450.0,
          },
          {
            'id': '2',
            'collector': 'Sarah',
            'date': 'Next Day, 2:00 PM',
            'amount': 320.0,
          },
        ];
        emit(EchoLoaded(
          summary: currentState.summary,
          pickups: mockPickups,
        ));
      }
    } catch (e) {
      emit(EchoError(e.toString()));
    }
  }

  Future<void> _onRefresh(
      RefreshEchoEvent event, Emitter<EchoState> emit) async {
    await _onGetSummary(GetEchoSummaryEvent(), emit);
  }
}
