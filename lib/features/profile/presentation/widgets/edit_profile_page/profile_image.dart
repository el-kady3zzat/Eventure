import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/pages/home_page.dart';
import 'package:eventure/features/profile/domain/managers/profile_manager.dart';
import 'package:eventure/features/profile/presentation/blocs/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ProfileImage extends StatelessWidget {
  final ImageProvider<Object>? img;
  final BuildContext? con;

  ProfileImage({
    super.key,
    required this.img,
    this.con,
  });


  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 75.r,
              backgroundImage: img
            ),
            InkWell(
              onTap: () {
                showBottomSheet(context);
              },
              child: Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kHeader,
                  border: Border.all(color: kMainDark, width: 2.8.w),
                ),
                child: Icon(Icons.edit_outlined, color: kWhite, size: 20.w),
              ),
            ),
          ],
    
    );
    
  });
  
}
  
  // Show bottom sheet for options (Camera, Gallery, Remove)
  void showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext modalContext) {
      return BlocProvider.value( // Ensure BlocProvider is available
        value: BlocProvider.of<EditProfileBloc>(context),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text('Camera'),
                onTap: () {
                  ProfileManager().uploadImage(context, true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.green),
                title: Text('Gallery'),
                onTap: () {
                  ProfileManager().uploadImage(context, false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red),
                title: Text('Remove'),
                onTap: () {
                  ProfileManager().removeImage(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}


  // void uploadGallery(BuildaContext con) {
  //   ProfileManager().uploadImage(con!,false);
 

  // }

  // void uploadCamera() {
  //    ProfileManager().uploadImage(con!,true);

  // }

  // void removeImage() {
  //   ProfileManager().removeImage(con! );
  // }
}