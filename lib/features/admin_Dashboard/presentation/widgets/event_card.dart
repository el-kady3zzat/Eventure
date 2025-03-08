import 'dart:convert';

import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/admin_Dashboard/model/firestore_event_model.dart';
import 'package:eventure/features/admin_Dashboard/presentation/Cubit/events/events_cubit.dart';
import 'package:eventure/features/admin_Dashboard/presentation/pages/edit_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WebEventCard extends StatelessWidget {
  final FSEvent event;

  const WebEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM, yyyy').format(event.dateTime);
    String formattedTime = DateFormat('hh:mm a').format(event.dateTime);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 260,
          width: constraints.maxWidth,
          child: Stack(
            children: [
              SizedBox(
                height: 260,
                width: constraints.maxWidth,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      base64Decode(event.cover),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    margin: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(150),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // context.read<EventsCubit>().
                      },
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Card(
                      elevation: 10,
                      shadowColor: kHeader,
                      margin: EdgeInsets.zero,
                      color: kDetails,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          formattedTime,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(kButton),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditEvent(
                                            event: event,
                                          )),
                                );
                              },
                              child: const Text(
                                'Edit Event',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
