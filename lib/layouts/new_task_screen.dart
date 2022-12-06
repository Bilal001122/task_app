import 'package:flutter/material.dart';
import 'package:task_app/shared/components/task_widget.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return TaskWidget(
          title: 'Go to the GYM',
          time: '12:00 PM',
          date: 'Apr 23,2021',
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 2,
          color: Colors.grey[200],
        );
      },
      itemCount: 10,
    );
  }
}
