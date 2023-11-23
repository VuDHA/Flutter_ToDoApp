import 'package:mysql1/mysql1.dart';
import '../model/todo.dart';

//run - flutter pub get, this install dependencies exist in project, dont need to run below command if run this already
//run this in terminal to install mysql1 dependencies - dart pub add mysql1
class Mysql {
  // Database connection settings
  static String host = '10.0.2.2', user = 'root', password = '', db = 'todoapp';
  static int port = 3306;

  Mysql();

  // Establish a connection to the MySQL database
  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      //password: password, depend on user setting if password required or not
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }

  // Delete a ToDo item from the database based on its ID
  Future<void> deleteToDoItem(String id) async {
    MySqlConnection connection = await getConnection();
    await connection.query('DELETE FROM todoitem WHERE Id = ?', [id]);
    await connection.close();
  }

  // Add a new ToDo item to the database
  Future<void> addToDoItem(String todo) async {
    MySqlConnection connection = await getConnection();
    await connection.query(
      'INSERT INTO todoitem (Id, Content, isDone) VALUES (?, ?, ?)',
      [DateTime.now().millisecondsSinceEpoch.toString(), todo, 1],
    );
    await connection.close();
  }

  // Update the isDone status of a ToDo item in the database
  Future<void> updateToDoStatus(String? id, bool isDone) async {
    MySqlConnection connection = await getConnection();
    await connection.query(
      'UPDATE todoitem SET isDone = ? WHERE Id = ?',
      [isDone ? 0 : 1, id],
    );
    await connection.close();
  }

  // Fetch all ToDo items from the database
  Future<List<ToDo>> fetchToDoList() async {
    MySqlConnection connection = await getConnection();
    Results results = await connection.query('SELECT * FROM todoitem');

    List<ToDo> todoList = [];

    for (var row in results) {
      // Map database row to ToDo model
      ToDo todoItem = ToDo(
        id: row['Id'],
        todoText: row['Content'],
        isDone: row['isDone'] ==
            0, //data save in mysql is tinyint, use this to map the boolean for isDone status
      );
      todoList.add(todoItem);
    }

    await connection.close();
    return todoList;
  }

  // Search for ToDo items in the database based on a keyword
  Future<List<ToDo>> searchToDoItems(String keyword) async {
    MySqlConnection connection = await getConnection();
    Results results = await connection.query(
      'SELECT * FROM todoitem WHERE Content LIKE ?',
      ['%$keyword%'],
    );

    List<ToDo> todoList = [];

    for (var row in results) {
      // Map database row to ToDo model
      ToDo todoItem = ToDo(
        id: row['Id'],
        todoText: row['Content'],
        isDone: row['isDone'] ==
            0, //data save in mysql is tinyint, use this to map the boolean for isDone status
      );
      todoList.add(todoItem);
    }

    await connection.close();
    return todoList;
  }
}
