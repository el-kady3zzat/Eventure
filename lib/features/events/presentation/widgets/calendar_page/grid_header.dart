import 'package:eventure/features/events/presentation/blocs/calendar/calendar_cubit.dart';
import 'package:eventure/features/events/presentation/widgets/calendar_page/arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class GridHeader extends StatelessWidget {
  final DateTime currentMonth;
  const GridHeader({super.key, required this.currentMonth});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Arrow(
          icon: Icons.arrow_back_rounded,
          onPress: () => context.read<CalendarCubit>().selectMonth(
                DateTime(
                  currentMonth.year,
                  currentMonth.month - 1,
                ),
              ),
        ),
        Text(
          DateFormat.yMMM().format(currentMonth),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Arrow(
          icon: Icons.arrow_forward_rounded,
          onPress: () => context.read<CalendarCubit>().selectMonth(
                DateTime(currentMonth.year, currentMonth.month + 1),
              ),
        ),
      ],
    );
  }
}
