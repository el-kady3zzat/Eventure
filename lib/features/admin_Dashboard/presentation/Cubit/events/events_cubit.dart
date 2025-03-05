import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/features/admin_Dashboard/model/firestore_event_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  EventsCubit() : super(EventsInitial());

  void fetchEvents() {
    emit(EventsLoading());
    FirebaseFirestore.instance.collection('events').snapshots().listen(
      (snapshot) {
        final events =
            snapshot.docs.map((doc) => FSEvent.fromFirestore(doc)).toList();
        emit(EventsLoaded(events));
      },
      onError: (error) {
        emit(EventsError(error.toString()));
      },
    );
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();
    } catch (error) {
      emit(EventsError("Failed to delete event: $error"));
    }
  }
}
