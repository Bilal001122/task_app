import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final String title;
  final String time;
  final String date;

  const TaskWidget({
    required this.title,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            maxRadius: 40,
            backgroundColor: Colors.deepPurple[500],
            child: Text(
              '$time',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '$date',
              ),
            ],
          )
        ],
      ),
    );
  }
}
