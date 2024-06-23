import 'package:flutter/material.dart';
import 'package:taskmanager/ui/utility/app_colors.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      child: ListTile(
        title: Text('Title wii be here'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Despriction will be here'),
            Text(
              '12/12/2024',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text('New'),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                ),
                ButtonBar(
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.edit),),
                    IconButton(onPressed: (){}, icon: Icon(Icons.delete),)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
