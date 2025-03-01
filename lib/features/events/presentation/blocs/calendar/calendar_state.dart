part of 'calendar_cubit.dart';

sealed class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

final class CalendarInitial extends CalendarState {}
