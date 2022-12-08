import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/shared/components/task_widget.dart';
import 'package:task_app/shared/cubit/cubit.dart';
import 'package:task_app/shared/cubit/states.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = AppCubit.get(context).newTasks;
        return tasks.isNotEmpty
            ? ListView.separated(
                itemBuilder: (context, index) {
                  return TaskWidget(
                    title: tasks[index]['title'],
                    time: tasks[index]['time'],
                    date: tasks[index]['date'],
                    id: tasks[index]['id'],
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 2,
                    color: Colors.grey[200],
                  );
                },
                itemCount: tasks.length,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.menu,
                      size: 100,
                      color: Colors.grey,
                    ),
                    Text(
                      'No Tasks Yet, Please add some Tasks',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
