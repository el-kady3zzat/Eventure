import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String asset;
  final String title;
  final String date;
  final String time;

  const EventCard({
    Key? key,
    required this.asset,
    required this.title,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15 , bottom: 38),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kMainLight
,
         // Dark background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with edit icon
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      asset,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.edit_outlined, size: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Bottom section (OVERLAPS THE IMAGE)
          Positioned(
            bottom: -30, // Moves the container up slightly to overlap the image
            left: 10,
            right: 10,
            child: Container(
             margin: EdgeInsets.only(left: 5 , right: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
        color: kMainLight,
                 // Matches the background
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Event Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white54, size: 14),
                          const SizedBox(width: 5),
                          Text(date, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          const SizedBox(width: 10),
                          const Icon(Icons.access_time, color: Colors.white54, size: 14),
                          const SizedBox(width: 5),
                          Text(time, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  // Chat Button with Edit Icon
                 
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: kButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        ),
                        onPressed: () {},
                        child:  Text("Chat" ,
                         style:TextStyle(color: kMainLight)),
                      ),
                     
                    ],
                  ),
                
            ),
          ),
          
        ],
      ),
    );
  }
}
