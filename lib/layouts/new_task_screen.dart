import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/shared/components/task_widget.dart';
import 'package:task_app/shared/cubit/cubit.dart';
import 'package:task_app/shared/cubit/states.dart';

import '../shared/constants.dart';

class NewTaskScreen extends StatefulWidget {
  NewTaskScreen();

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return ListView.separated(
          itemBuilder: (context, index) {
            return TaskWidget(
              title: cubit.tasks[index]['title'],
              time: cubit.tasks[index]['time'],
              date: cubit.tasks[index]['date'],
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 2,
              color: Colors.grey[200],
            );
          },
          itemCount: cubit.tasks.length,
        );
      },
    );
  }
}
