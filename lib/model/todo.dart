//Model to use for the app
class ToDo {
  // Unique identifier for the ToDo item
  String? id;

  // Text content of the ToDo item
  String? todoText;

  // Flag indicating whether the ToDo item is marked as done
  bool isDone;

  // Constructor to initialize a ToDo instance
  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false, // Default value for isDone is false
  });

  // A static method to generate a sample ToDo list
  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Budy1', isDone: true),
      ToDo(id: '02', todoText: 'Budy2', isDone: true),
      ToDo(id: '03', todoText: 'Budy3'),
      ToDo(id: '04', todoText: 'Budy4'),
      ToDo(id: '05', todoText: 'Budy5'),
      ToDo(id: '06', todoText: 'Bud6y'),
    ];
  }
}
