// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eventure/features/auth/firebase/firebase_auth_services.dart';
// import 'package:eventure/features/profile/presentation/widgets/profile_page/asset_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ProfileAvatar extends StatefulWidget {
//   @override
//   _ProfileAvatarState createState() => _ProfileAvatarState();
// }

// class _ProfileAvatarState extends State<ProfileAvatar> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseService().currentUser!.uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircleAvatar(
//             radius: 75.r,
//             backgroundImage: assetProfileImage(),
//           );
//         }

//         if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
//           return CircleAvatar(
//             radius: 75.r,
//             backgroundImage: assetProfileImage(),
//           );
//         }

//         final data = snapshot.data!.data() as Map<String, dynamic>?;

//         if (data == null || data['image'] == null) {
//           return CircleAvatar(
//             radius: 75.r,
//             backgroundImage: assetProfileImage(),
//           );
//         }

//         Uint8List imageBytes = base64Decode(data['image']);

//         return CircleAvatar(
//           radius: 75.r,
//           backgroundImage: MemoryImage(imageBytes),
//         );
//       },
//     );
//   }
// }
