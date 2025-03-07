part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class EditInitial extends EditProfileState {}

class EditLoading extends EditProfileState {}

class EditSuccess extends EditProfileState {}

class EditError extends EditProfileState {
  final String errorMessage;
  EditError(this.errorMessage);
}
class AvatarUpdating extends EditProfileState {}
class EditProfileLoading extends EditProfileState {}
class AvatarUpdated extends EditProfileState {
  final Uint8List image;
  AvatarUpdated({required this.image});
}
class EditProfileLoaded extends EditProfileState {
  final FSUser? user;
  // final Uint8List? image;
  EditProfileLoaded({this.user});
}
class EditProfileError extends EditProfileState {
  final String errorMessage;
  EditProfileError(this.errorMessage);
}
class EditProfileImageLoaded extends EditProfileState {
  final Uint8List? image;
  EditProfileImageLoaded({required this.image});
}
class EditProfileImageError extends EditProfileState {
  final String errorMessage;
  EditProfileImageError(this.errorMessage);
}
class EditProfileImageRemoved extends EditProfileState {
  EditProfileImageRemoved();
}
class EditProfileImageLoading extends EditProfileState {}
class AvatarRemoved extends EditProfileState {}
class EditProfileImageUploaded extends EditProfileState {
  final Uint8List image;
  EditProfileImageUploaded({required this.image});
}
class AvatarError extends EditProfileState {
  final String message;
  AvatarError(this.message);
}
