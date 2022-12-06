import 'package:flutter/material.dart';
import 'package:task_app/shared/components/task_widget.dart';

import '../shared/constants.dart';

class NewTaskScreen extends StatefulWidget {
  NewTaskScreen();

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return TaskWidget(
          title: tasks[index]['title'],
          time: tasks[index]['time'],
          date: tasks[index]['date'],
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 2,
          color: Colors.grey[200],
        );
      },
      itemCount: tasks.length,
    );
  }
}
