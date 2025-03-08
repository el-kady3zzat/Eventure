import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/features/admin_Dashboard/Logic/notifications_handler.dart';
import 'package:eventure/features/admin_Dashboard/model/firestore_event_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  EventsCubit() : super(EventsInitial());

  // Stream<List<FSEvent>> getEventsStream() {
  //   return FirebaseFirestore.instance.collection('events').snapshots().map(
  //         (snapshot) =>
  //             snapshot.docs.map((doc) => FSEvent.fromFirestore(doc)).toList(),
  //       );
  // }
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

    Future<void> addEvent({
      required String address,
      required String title,
      required String seats,
      required DateTime selectedDateTime,
      required String description,
      required String price,
      required String location,
      required String cover,
    }) async {
      emit(AddEventLoading());

      var db = FirebaseFirestore.instance;
      DocumentReference docRef = db.collection("events").doc();
      String docId = docRef.id;

      try {
        await docRef.set({
          "id": docId,
          "address": address,
          "title": title,
          "seats": int.tryParse(seats) ?? 0,
          "dateTime": selectedDateTime != null
              ? Timestamp.fromDate(selectedDateTime!)
              : Timestamp.now(),
          "description": description,
          "price": price,
          "location": location,
          "cover": cover,
          "registeredUsers": [],
          "registeredUsersImages": [],
          "likedUsers": [],
        });

        // await NotificationService().sendNotificationToAll();

        emit(AddEventSuccess());
      } catch (e) {
        emit(AddEventError(e.toString()));
      }
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
}
