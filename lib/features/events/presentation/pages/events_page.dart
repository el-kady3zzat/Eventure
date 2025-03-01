import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/core/utils/widgets/event_card.dart';
import 'package:eventure/features/events/presentation/widgets/events_page/main_app_bar.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainLight,
      appBar: MainAppBar(),
      body: ListView.builder(
        scrollDirection:
            SizeConfig.isPortrait() ? Axis.vertical : Axis.horizontal,
        padding: EdgeInsets.all(12),
        itemCount: 10,
        itemBuilder: (context, index) => EventCard(),
      ),
    );
  }
}
