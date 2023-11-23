import 'package:flutter/material.dart';
import 'package:todolist/constants/colors.dart';

import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  // The ToDo item associated with this widget
  final ToDo todo;

  // Callback function to handle ToDo status changes
  final onToDoChanged;

  // Callback function to handle ToDo item deletion
  final onDeleteItem;

  // Constructor to initialize ToDoItem instance
  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        // Tap gesture to handle ToDo item click
        onTap: () {
          onToDoChanged(todo);
        },
        // Customized tile appearance
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        // Icon indicating ToDo status (done or not done)
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        // Text displaying ToDo content with styling based on status
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            color: tdRlack,
            // Apply text decoration (line through) if ToDo is marked as done
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        // Container with delete button
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: tdRed,
            borderRadius: BorderRadius.circular(5),
          ),
          // IconButton for deleting ToDo item
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              onDeleteItem(todo.id);
            },
          ),
        ),
      ),
    );
  }
}
