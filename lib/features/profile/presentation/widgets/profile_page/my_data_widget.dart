import 'package:eventure/features/profile/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:eventure/features/profile/presentation/widgets/profile_page/profile_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget myData() {
    return Center(
      child: BlocBuilder<ProfileBloc, ProfileState>(
                    buildWhen: (context, state) => state is ProfileLoaded,
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is ProfileLoaded) {
                        final user = state.user;
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                      context.read<ProfileBloc>().firstName,
                                      style: TextStyle(
                                          fontSize: 21.sp,
                                          fontWeight: FontWeight.bold))),
                              SizedBox(
                                height: 5.h,
                              ),
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
                                txt: user.phone.isEmpty
                                    ? 'N/A'
                                    : 
                                        user.phone,
                                icon: Icons.phone_android_outlined,
                              ),
                              
                            
                                  
                            ]);
                      }
                      if (state is ProfileError) {
                        return Center(child: Text(state.errorMessage));
                      }
                      return Container();
                    }),
    );
  }