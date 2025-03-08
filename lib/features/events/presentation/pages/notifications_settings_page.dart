import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:eventure/features/events/presentation/widgets/notifications_settings_page/notification_item.dart';
import 'package:eventure/features/events/presentation/widgets/pages_header.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return Scaffold(
      backgroundColor: kMainLight,
      body: BlocProvider(
        create: (context) =>
            getIt<NotificationsBloc>()..add(FetchNotificationSettings()),
        child: SafeArea(
          child: Column(
            children: [
              PagesHeader(title: 'NOTIFICATION SETTINGS', hasBackBtn: true),
              Stack(
                children: [
                  Container(
                    margin: REdgeInsets.symmetric(horizontal: 20.w),
                    padding: REdgeInsets.fromLTRB(36, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: kDetails,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: BlocBuilder<NotificationsBloc, NotificationState>(
                      builder: (context, state) {
                        if (state is NotificationSettingsLoaded) {
                          final settings = state.notificationSettings;
                          return Column(
                            children: [
                              NotificationItem(
                                title: 'Show all Notifications',
                                state: settings['general_channel'] ?? true,
                                onChanged: (val) {
                                  context.read<NotificationsBloc>().add(
                                        ToggleNotificationChannel(
                                          'general_channel',
                                          val,
                                        ),
                                      );
                                },
                              ),
                              Divider(color: kMainDark, thickness: 1.5),
                              NotificationItem(
                                title: 'Booked Events Reminder',
                                state:
                                    settings['booked_events_channel'] ?? true,
                                onChanged: (val) {
                                  context.read<NotificationsBloc>().add(
                                        ToggleNotificationChannel(
                                          'booked_events_channel',
                                          val,
                                        ),
                                      );
                                },
                              ),
                              NotificationItem(
                                title: 'Favorite Events Reminder',
                                state:
                                    settings['favorite_events_channel'] ?? true,
                                onChanged: (val) {
                                  context.read<NotificationsBloc>().add(
                                        ToggleNotificationChannel(
                                          'favorite_events_channel',
                                          val,
                                        ),
                                      );
                                },
                              ),
                            ],
                          );
                        } else if (state is NotificationChannelUpdated) {
                          context
                              .read<NotificationsBloc>()
                              .add(FetchNotificationSettings());
                          return CircularProgressIndicator(color: kMainDark);
                        } else if (state is NotificationError) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error loading settings',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 16.sp),
                              ),
                              SizedBox(height: 10.h),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<NotificationsBloc>()
                                      .add(FetchNotificationSettings());
                                },
                                child: Text('Retry'),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text(
                              'Error loading settings',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.sp,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Transform.rotate(
                    angle: 12,
                    child: Container(
                      width: SizeConfig.size(p: 40.h, l: 80.h),
                      height: SizeConfig.size(p: 40.h, l: 80.h),
                      margin: REdgeInsets.only(top: 16),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: kHeader,
                          size: SizeConfig.size(p: 25.h, l: 50.h),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
