import 'dart:convert';

List<Todo> todoFromJson(String str) => List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoToJson(List<Todo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  DateTime createdAt;
  String todo;
  bool complete;
  String id;

  Todo({
    required this.createdAt,
    required this.todo,
    required this.complete,
    required this.id,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    createdAt: DateTime.parse(json["createdAt"]),
    todo: json["todo"],
    complete: json["complete"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
    "todo": todo,
    "complete": complete,
    "id": id,
  };
}
