import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:serverless/model/Todo.dart';
import 'controller/todocontroller.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todoController = Get.put<TodoController>(TodoController());
  TextEditingController _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Todo App"),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add_box,
                size: 40,
              ),
              color: Colors.white,
              tooltip: 'New',
              onPressed: () {
                // handle the press
                _bottomSheetModal(context);
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => todoController.fetchTodo(),
          child: Obx(
                  () => todoController.isLoading.value ? const Center(child: CircularProgressIndicator())
                  :
              Column(
                children: [
                  const Text(
                    'Tâches en cours...',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                      height: 350,
                      child: ListView.builder(
                          itemCount: todoController.runingList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(5),
                              child: Card(
                                color: Colors.yellow,
                                child: ListTile(
                                  title: Text(
                                    todoController.runingList[index].todo,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Créer le ' + todoController.runingList[index].createdAt.toString(),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black
                                    ),
                                  ),
                                  leading: const Icon(
                                    Icons.running_with_errors_sharp,
                                    size: 60,
                                    color: Colors.black,
                                  ),
                                  onLongPress: () => _deleteTodo(context, todoController.runingList[index]),
                                  onTap: () => _showDetails(context, todoController.runingList[index]),
                                ),
                              ),
                            );
                          }
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Tâches Terminées',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Container(
                      height: 250,
                      child: ListView.builder(
                          itemCount: todoController.finishList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(5),
                              child: Card(
                                color: Colors.lightGreen,
                                child: ListTile(
                                  title: Text(
                                    todoController.finishList[index].todo,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Créer le ' + todoController.finishList[index].createdAt.toString(),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black
                                    ),
                                  ),
                                  leading: const Icon(
                                    Icons.running_with_errors_sharp,
                                    size: 60,
                                    color: Colors.black,
                                  ),
                                  onTap: () => _deleteTodo(context, todoController.finishList[index]),
                                ),
                              ),
                            );
                          }
                      )),
                ],
              )
          ),
        ),
    ) ;
  }

  void _bottomSheetModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Nouvelle Tâche',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nom de la tâche',
                      hintText: 'Nom de la tâche',
                    ),
                    autofocus: false,
                    controller: _ctrl,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 7,
                              backgroundColor: Colors.red
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fermer'),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 7,
                              backgroundColor: Colors.green
                          ),
                          child: const Text('Valider'),
                          onPressed: () => {
                            if(_ctrl.text.isNotEmpty){
                              _addTodo()
                            }else{
                                Get.snackbar('ATTENTION', 'Le nom de la tâche SVP!',
                                  snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.deepOrangeAccent)
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetails(BuildContext context, Todo todo) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 380,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Détail Tâche',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.timelapse_sharp,
                    color: Colors.lightGreen,
                    size: 80,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        const Text(
                          'Tâche : ',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Container(
                          child: Text(
                            todo.todo,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        const Text(
                          'Identifiant : ',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Container(
                          child: Text(
                            todo.id,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    )
                ),

                Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        const Text(
                          'Date : ',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Container(
                          child: Text(
                            todo.createdAt.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 7,
                              backgroundColor: Colors.red
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fermer'),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 7,
                              backgroundColor: Colors.green
                          ),
                          child: const Text('Terminer'),
                          onPressed: () => {
                            _updateTodo(todo)
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteTodo(BuildContext context, Todo todo) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Voulez-vous vraiment supprimer cette tâche?',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 7,
                              backgroundColor: Colors.red
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Non'),
                        ),
                        const SizedBox(width: 10,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 7,
                              backgroundColor: Colors.green
                          ),
                          child: const Text('Oui'),
                          onPressed: () => {
                            _removeTodo(todo)
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addTodo() {
    var todo = Todo(createdAt: DateTime.now(), todo: _ctrl.text, complete: false, id: '');
    todoController.addTodo(todo);
    Navigator.pop(context);
  }
  void _removeTodo(Todo todo) {
    todoController.deleteTodo(todo);
    Navigator.pop(context);
  }

  void _updateTodo(Todo todo) {
    todo.complete = true;
    todoController.updateTodo(todo);
    Navigator.pop(context);
  }
}
