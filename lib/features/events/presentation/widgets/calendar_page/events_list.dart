import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EventsList extends StatelessWidget {
  final List<Event> eventsOfCurrentMonth;
  const EventsList({super.key, required this.eventsOfCurrentMonth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
          // reverse: true,
          itemCount: eventsOfCurrentMonth.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: REdgeInsets.only(bottom: 8.0),
              child: ListTile(
                leading: SizedBox(
                  height: 100,
                  width: 55,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/event_bg.png',
                    ),
                  ),
                ),
                title: Text(
                  eventsOfCurrentMonth[index].name,
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  formatCustomDate(
                    eventsOfCurrentMonth[index].date,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
    );
  }

  String formatCustomDate(DateTime date) {
    // Get day as a number
    String day = DateFormat('d').format(date);
    // Get suffix (st, nd, rd, th)
    String suffix = getDaySuffix(int.parse(day));
    // Get time like "11 PM"
    String formattedTime = DateFormat('h a').format(date);

    return '$day$suffix at $formattedTime';
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
