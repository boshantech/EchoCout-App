import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Profile Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetUserProfileEvent extends ProfileEvent {
  const GetUserProfileEvent();
}

class UpdateUserProfileEvent extends ProfileEvent {
  final String? name;
  final String? email;

  const UpdateUserProfileEvent({
    this.name,
    this.email,
  });

  @override
  List<Object?> get props => [name, email];
}

class LogoutProfileEvent extends ProfileEvent {
  const LogoutProfileEvent();
}

// Profile States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateInProgress extends ProfileState {
  const ProfileUpdateInProgress();
}

class ProfileUpdateSuccess extends ProfileState {
  final Map<String, dynamic> updatedProfile;

  const ProfileUpdateSuccess(this.updatedProfile);

  @override
  List<Object?> get props => [updatedProfile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class LoggingOut extends ProfileState {
  const LoggingOut();
}

class LogoutSuccess extends ProfileState {
  const LogoutSuccess();
}

// Profile BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileInitial()) {
    on<GetUserProfileEvent>(_onGetProfile);
    on<UpdateUserProfileEvent>(_onUpdateProfile);
    on<LogoutProfileEvent>(_onLogout);
  }

  Future<void> _onGetProfile(
      GetUserProfileEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final mockProfile = {
        'id': '123',
        'phoneNumber': '+91 98765 43210',
        'name': 'John Doe',
        'email': 'john@example.com',
        'totalPoints': 1250,
        'totalEarnings': 6125.50,
        'totalItemsSold': 245,
        'memberSince': 'Jan 2024',
      };
      emit(ProfileLoaded(mockProfile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateUserProfileEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileUpdateInProgress());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final mockProfile = {
        'id': '123',
        'phoneNumber': '+91 98765 43210',
        'name': event.name ?? 'John Doe',
        'email': event.email ?? 'john@example.com',
        'totalPoints': 1250,
        'totalEarnings': 6125.50,
        'totalItemsSold': 245,
        'memberSince': 'Jan 2024',
      };
      emit(ProfileUpdateSuccess(mockProfile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLogout(
      LogoutProfileEvent event, Emitter<ProfileState> emit) async {
    emit(const LoggingOut());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(const LogoutSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
