import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/model/connection.dart';

import '../constants/colors.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // List to hold ToDo items
  //final todosList = ToDo.todoList();

  // List to store filtered ToDo items after search
  List<ToDo> _foundToDo = [];

  // Controller for the new ToDo item input
  final _todoController = TextEditingController();

  // Instance of the MySQL connection class
  var db = new Mysql();

  @override
  void initState() {
    // Load the ToDo list when the screen is initialized
    _loadToDoList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(), // App Bar at the top of the screen
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                _BuildSearchBox(), // Search box UI for filtering ToDo items
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Display ToDo items using ToDoItem widget
                      for (ToDo todo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todo,
                          onToDoChanged:
                              _handleToDoChange, // Handle ToDo item status change
                          onDeleteItem: _deleteToDoItem, // Delete a ToDo item
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // TextField for adding a new ToDo item
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      hintText: 'Add a new todo item',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              // Button to add a new ToDo item
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  // Load the ToDo list from the database
  Future<void> _loadToDoList() async {
    List<ToDo> fetchedList = await Mysql().fetchToDoList();
    setState(() {
      _foundToDo = fetchedList;
    });
  }

  // Handle the change in ToDo item status
  void _handleToDoChange(ToDo todo) async {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    // Update the isDone status in the MySQL database
    await Mysql().updateToDoStatus(todo.id, todo.isDone);
  }

  // Delete a ToDo item
  void _deleteToDoItem(String id) async {
    await Mysql().deleteToDoItem(id);
    _loadToDoList();
  }

  // Add a new ToDo item to the database
  void _addToDoItem(String todo) async {
    await Mysql().addToDoItem(todo);
    _loadToDoList();
    _todoController.clear();
  }

  // Filter ToDo items based on a keyword
  void _runFilter(String enteredKeyword) async {
    List<ToDo> results = [];

    if (enteredKeyword.isEmpty) {
      results =
          await Mysql().fetchToDoList(); // Fetch all items from the database
    } else {
      results = await Mysql().searchToDoItems(enteredKeyword);
    }

    setState(() {
      _foundToDo = results;
    });
  }

  // Build the search box UI
  Container _BuildSearchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      // TextField for searching ToDo items
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdRlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  // Build the app bar UI
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      // App bar title and icons
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: tdRlack,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/avatar.jpg'),
          ),
        ),
      ]),
    );
  }
}
