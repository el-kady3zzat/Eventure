import 'package:eventure/features/admin_Dashboard/presentation/Cubit/events/events_cubit.dart';
import 'package:eventure/features/admin_Dashboard/presentation/pages/add_event.dart';
import 'package:eventure/features/admin_Dashboard/presentation/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsCubit()..fetchEvents(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Eventure Dashboard'),
          centerTitle: true,
          backgroundColor: Colors.purpleAccent,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: () async {
                  // await NotificationService().sendNotificationToAll();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddEvent()),
                  );
                },
                child: const Text("Add Event"),
              ),
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 3;

            if (constraints.maxWidth < 1200) {
              crossAxisCount = 2;
            }
            if (constraints.maxWidth < 800) {
              crossAxisCount = 1;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: BlocBuilder<EventsCubit, EventsState>(
                builder: (context, state) {
                  if (state is EventsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EventsError) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else if (state is EventsLoaded) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 50,
                        mainAxisSpacing: 20,
                        mainAxisExtent: 260,
                      ),
                      itemCount: state.events.length,
                      itemBuilder: (BuildContext context, int index) {
                        final event = state.events[index];
                        return WebEventCard(event: event);
                      },
                    );
                  }
                  return const Center(child: Text("No events found"));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
