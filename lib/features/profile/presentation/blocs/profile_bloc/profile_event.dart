part of 'profile_bloc.dart';

abstract class ProfileEvent{
//   @override
//   List<Object> get props => [];
}

/// Event to load user profile data from Firestore
class LoadProfile extends ProfileEvent {
  
}
// abstract class ProfileEvent extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// Event to fetch saved events from Firestore
class FetchSavedEvents extends ProfileEvent {}
// class UpdateShowEvents extends ProfileEvent {
//   final bool showEvents;

//   UpdateShowEvents(this.showEvents);

//   @override
//   List<Object> get props => [showEvents];
// }
/// Event to update the user avatar (pick from camera or gallery)

/// Event to logout the user
class LogoutUser extends ProfileEvent {}
class ToggleShowEvents extends ProfileEvent {
  final bool showEvents;
  ToggleShowEvents(this.showEvents);
}
