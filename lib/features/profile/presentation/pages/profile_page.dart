import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/auth/firebase/firebase_auth_services.dart';
import 'package:eventure/features/auth/models/fire_store_user_model.dart';
import 'package:eventure/features/profile/presentation/blocs/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:eventure/features/profile/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:eventure/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:eventure/features/profile/presentation/widgets/profile_page/asset_image.dart';
import 'package:eventure/features/profile/presentation/widgets/profile_page/profile_image.dart';
import 'package:eventure/features/profile/presentation/widgets/profile_page/profile_item.dart';
import 'package:eventure/features/profile/presentation/widgets/profile_page/saved_events_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FSUser? userData;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    // Trigger biometric authentication
    // context.read<ProfileBloc>().add(SubscribeProfile());
    context.read<ProfileBloc>().add(LoadProfile());
    _pageController = PageController(initialPage: 0); // Default to "My Data"

    // print("object");
    // print(context.read<ProfileBloc>().user);
    // userData = context.read<ProfileBloc>().user;
  }

  bool show = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: kMainLight,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 21.w,
                        color: kWhite,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Add back navigation functionality here
                      },
                    ),
                    Text(
                      'PROFILE',
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: kWhite,
                        size: 25.w,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (con) => BlocProvider(
                                      create: (con) => EditProfileBloc(),
                                      child: EditProfilePage(
                                        name: userData!.name,
                                        email: userData!.email,
                                        phone: userData!.phone,
                                      ),
                                    )));
                        // Add edit profile functionality here
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                // ProfileAvatar(),
                BlocBuilder<ProfileBloc, ProfileState>(
                    buildWhen: (context, state) => state is ProfileLoaded,
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is ProfileLoaded) {
                        final user = state.user;
        
                        return CircleAvatar(
                            radius: 75.r,
                            backgroundImage: user!.image.isNotEmpty
                                ? MemoryImage(base64Decode(user.image))
                                : assetProfileImage());
                      }
                      if (state is ProfileImageRemoved) {
                        return CircleAvatar(
                            radius: 75.r,
                          backgroundImage: assetProfileImage(),
                        );
                      }
                      if (state is ProfileImageError) {
                        return Text(state.errorMessage);
                      }
        
                      return CircleAvatar(
                          radius: 75.r, backgroundImage: assetProfileImage());
                    }),
        
                SizedBox(height: 12.h),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is ProfileLoaded) {
                      final user = state.user;
        
                      userData = state.user; // Update when data is ready
        
                      return user != null
                          ? Text(user.name,
                              style: TextStyle(
                                  color: kWhite,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold))
                          : Center(
                              child: Text("User data not found",
                                  style: TextStyle(color: kWhite)));
                    }
                    return Container();
                  },
                ),
                SizedBox(height: 20.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: kMainDark,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                    bool showEvents = false; // Default
        
                    if (state is ShowEventsUpdated) {
                      showEvents = state.showEvents;
                    }
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      showEvents ? kHeader : Colors.transparent),
                                ),
                                onPressed: () {
                                  // setState(() {
                                  //   showEvents = true;
                                  // });
                                  context
                                      .read<ProfileBloc>()
                                      .add(ToggleShowEvents(true));
                                },
                                child: Text('Saved Events ',
                                    style: TextStyle(
                                        color: showEvents ? kWhite : kGrey)),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      !showEvents ? kHeader : Colors.transparent),
                                ),
                                onPressed: () {
                                  // setState(() {
                                  //   showEvents = false;
                                  // });
                                  context
                                      .read<ProfileBloc>()
                                      .add(ToggleShowEvents(false));
                                },
                                child: Text('My Data',
                                    style: TextStyle(
                                        color: !showEvents ? kWhite : kGrey)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 20.h),
        
                BlocConsumer<ProfileBloc, ProfileState>(
                  buildWhen: (context, state) =>
                      state is ProfileLoaded || state is ShowEventsUpdated,
                  listener: (context, state) {
                    show = false; // Default
        
                    if (state is ShowEventsUpdated) {
                      show = state.showEvents;
                    }
                    // if (!show)
                    // {
                    //   ProfileLoaded();
                    // }
                  },
                  builder: (context, state) {
                    // bool showEvents = false; // Default
        
                    if (state is ShowEventsUpdated) {
                      show = state.showEvents;
                    }
        
                    if (show) {
                      return Expanded(child: savedEvents());
                    }
        
                    // Now handling user profile in the same BlocBuilder
                    if (state is ProfileLoading && !show) {
                      return Center(child: CircularProgressIndicator());
                    }
        
                    if (state is ProfileLoaded && !show) {
                      final user = state.user;
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ProfileItem(
                              isObscure: true,
                              txt: user!.name,
                              icon: Icons.person_2_outlined,
                            ),
                            ProfileItem(
                              isObscure: true,
                              txt: user.email,
                              icon: Icons.email_outlined,
                            ),
                            ProfileItem(
                              txt: '888888888',
                              isObscure: false,
                              icon: Icons.lock_open_outlined,
                            ),
                            ProfileItem(
                              isObscure: true,
                              txt: user.phone.isEmpty ? 'N/A' : user.phone,
                              icon: Icons.phone_android_outlined,
                            ),
                          ],
                        ),
                      );
                    }
        
                    if (state is ProfileError && !show) {
                      return Center(child: Text(state.errorMessage));
                    }
        
                    return Container(); // Default empty state
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
