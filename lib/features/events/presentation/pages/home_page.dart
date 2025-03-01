import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/nav_bar/nav_bar_cubit.dart';
import 'package:eventure/features/events/presentation/pages/calendar_page.dart';
import 'package:eventure/features/events/presentation/pages/events_page.dart';
import 'package:eventure/features/events/presentation/widgets/home_page/nav_bar.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return BlocProvider(
      create: (_) => getIt<NavBarCubit>(),
      child: Scaffold(
        backgroundColor: kMainLight,
        bottomNavigationBar: NavBar(),
        body: BlocBuilder<NavBarCubit, int>(
          builder: (context, pageIndex) {
            if (pageIndex == 0) {
              return EventsPage();
            } else if (pageIndex == 1) {
              return CalendarPage();
            } else {
              return Placeholder();
            }
          },
        ),
      ),
    );
  }
}
