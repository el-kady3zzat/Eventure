import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/features/auth/firebase/firebase_auth_services.dart';
import 'package:eventure/features/auth/models/fire_store_user_model.dart';
import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseService().currentUser;
  bool showEvents = false;
  FSUser? user;
  List<Event> savedEvents = [];
  Uint8List? image;
  Uint8List? headerImage;
  String firstName = "";

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_loadProfile);

    on<ToggleShowEvents>((event, emit) {
      showEvents = event.showEvents;
      emit(ShowEventsUpdated(showEvents));
      if (!showEvents) {
        // final currentState = state as ProfileLoaded;
        // emit(ProfileLoaded(user: currentState.user, showEvents: event.showEvents));

        add(LoadProfile());
      } // Emit new state
    });

    // Automatically load profile when bloc is created
    // add(LoadProfile());
  }

  /// Fetch user profile data (Triggered manually)
  void _loadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    if (currentUser == null) {
      emit(ProfileError("No user found"));
      return;
    }

    try {
      emit(ProfileLoading()); // Show loading indicator

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (doc.exists) {
        FSUser user = FSUser.fromFirestore(doc);

        // // ✅ Correct way to get 'savedEvents' from Firestore
        // List<dynamic> savedEventsData = doc.get('savedEvents') ?? [];

        // // ✅ Convert Firestore data into Event objects
        // List<Event> savedEvents = savedEventsData
        //     .map((eventData) => Event.fromFirestore(eventData))
        //     .toList();
        emit(ProfileLoaded(
            user: user,
            savedEvents: savedEvents)); // Update state with user data
      } else {
        emit(ProfileError("User data not found"));
      }
    } catch (e) {
      emit(ProfileError("Error loading profile: ${e.toString()}"));
    }
  }

  /// Logout
  void logout() {
    FirebaseService().signOut();
  }
}
