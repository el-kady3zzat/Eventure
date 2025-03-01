import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/widgets/calendar_page/calendar_app_bar.dart';
import 'package:eventure/features/events/presentation/widgets/calendar_page/calendar_grid.dart';
import 'package:eventure/features/events/presentation/widgets/calendar_page/events_list.dart';
import 'package:eventure/features/events/presentation/widgets/calendar_page/grid_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:eventure/features/events/presentation/blocs/calendar/calendar_cubit.dart';
import 'package:eventure/injection.dart';

class CalendarPage extends StatelessWidget {
  CalendarPage({super.key});

  final Map<int, FocusNode> focusNodes = {};

  @override
  Widget build(BuildContext context) {
    final List<Event> events = [
      Event(name: 'Event 1', date: DateTime(2025, 4, 2, 11)),
      Event(name: 'Event 2', date: DateTime(2025, 3, 28, 11)),
      Event(name: 'Event 3', date: DateTime(2025, 3, 1, 11)),
      Event(name: 'Event 4', date: DateTime(2025, 3, 15, 11)),
      Event(name: 'Event 4', date: DateTime(2025, 3, 11, 11)),
      Event(name: 'Event 4', date: DateTime(2025, 3, 31, 11)),
      Event(name: 'Event 5', date: DateTime(2025, 2, 9, 11)),
      Event(name: 'Event 6', date: DateTime(2025, 2, 9, 11)),
      Event(name: 'Event 7', date: DateTime(2025, 2, 9, 11)),
      Event(name: 'Event 8', date: DateTime(2025, 2, 9, 11)),
      Event(name: 'Event 9', date: DateTime(2025, 2, 9, 11)),
      Event(name: 'Event 10', date: DateTime(2025, 2, 9, 11)),
      Event(name: 'Event 10', date: DateTime(2025, 2, 9, 11)),
      Event(name: 'Event 10', date: DateTime(2025, 2, 9, 11)),
      Event(name: 'Event 10', date: DateTime(2025, 2, 9, 11)),
      Event(name: 'Event 10', date: DateTime(2025, 2, 9, 11)),
      Event(name: 'Event 10', date: DateTime(2025, 2, 9, 11)),
      Event(name: 'Event 10', date: DateTime(2025, 2, 9, 11)),
    ];

    return Scaffold(
      backgroundColor: kMainLight,
      appBar: CalendarAppBar(),
      body: BlocProvider(
        create: (_) => getIt<CalendarCubit>(),
        child: BlocBuilder<CalendarCubit, DateTime>(
          builder: (context, currentMonth) {
            SizeConfig.mContext = context;

            List<Event> eventsOfCurrentMonth = [];
            eventsOfCurrentMonth.addAll(
              events.where((event) => event.date.month == currentMonth.month),
            );
            eventsOfCurrentMonth.sort(
              (a, b) => a.date.day.compareTo(b.date.day),
            );

            return SizedBox(
              height: 1.sh,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  GridHeader(currentMonth: currentMonth),
                  SizedBox(height: SizeConfig.size(p: 20, l: 10)),
                  CalendarGrid(currentMonth: currentMonth, events: events),
                  Expanded(child: SizedBox()),
                  if (SizeConfig.isPortrait())
                    EventsList(eventsOfCurrentMonth: eventsOfCurrentMonth),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
