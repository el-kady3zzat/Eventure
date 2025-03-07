import 'package:eventure/features/profile/presentation/widgets/profile_page/event_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget savedEvents() {

  return ListView(
     children: [
          EventCard(
          title:   'Musical Event 2021',
            date: '26 Mar, 2021',
           time: '08:00 pm',
           asset: 'assets/images/event_bg.png',
          ),
          EventCard(
           title: 'Christmas Party',
           date: '24 Mar, 2021',
           time: '02:00 pm',
           asset: 'assets/images/event_bg.png',
          ),
        ],
  );
  // return BlocBuilder<ProfileBloc, ProfileState>(
  //  builder: (context, state) {
  //                 if (state is ProfileLoading) {
  //                   return Center(child: CircularProgressIndicator());
  //                 }
  //                 if (state is ProfileLoaded) {
  //                   final events = state.savedEvents;
                  
                 
  //      return events != null?  ListView.separated(
  //       itemCount: events.length,
  //       itemBuilder: (context, index) {
  //         return EventCard(
  //           title: events[index].name,
  //           date: events[index].date.day.toString(),
  //           time: events[index].date.hour.toString(),
  //           asset:  events[index].cover!,
  //         );
  //       },
  //       separatorBuilder: (context, index) => SizedBox(
  //         height: 10.h,
  //       ),
       
  //     )

  //      : Center(
  //                           child: Text("User data not found",
  //                               style: TextStyle(color: Colors.white)));
  //                 }
  //                 return Container();
  //   },
  // );
}
