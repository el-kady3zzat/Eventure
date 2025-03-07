part of 'profile_bloc.dart';

// states of profile screen  to load data and upload , save and get the image


abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final FSUser? user;
  final Uint8List? image;
  List<Event>? savedEvents ;
  bool ? showEvents;
  ProfileLoaded({this.user, this.image , this.savedEvents , this.showEvents});
}

class ProfileError extends ProfileState {
  final String errorMessage;
  ProfileError(this.errorMessage);
}

class ProfileImageLoading extends ProfileState {}

class ProfileImageLoaded extends ProfileState {
  final Uint8List? image;
  ProfileImageLoaded({required this.image});
}
class ShowEventsUpdated extends ProfileState {
  final bool showEvents;
  ShowEventsUpdated(this.showEvents);
}

class ProfileImageUploaded extends ProfileState {
  final Uint8List image;
  ProfileImageUploaded({required this.image});
}

class ProfileImageRemoved extends ProfileState {
  ProfileImageRemoved();
}

class ProfileImageError extends ProfileState {
  final String errorMessage;
  ProfileImageError(this.errorMessage);
}

class HeaderLoaded extends ProfileState {
  final Uint8List? image;
  final String firstName;
  HeaderLoaded({required this.image, required this.firstName});
}

class HeaderDataError extends ProfileState {
  final String errorMessage;
  HeaderDataError(this.errorMessage);
}
class BiometricAuthenticationRequired extends ProfileState {}
class BiometricAuthenticationSuccess extends ProfileState {}
class BiometricAuthenticationFailure extends ProfileState {
  final String errorMessage;
  BiometricAuthenticationFailure(this.errorMessage);
}