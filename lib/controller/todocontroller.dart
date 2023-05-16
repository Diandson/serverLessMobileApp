import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/Todo.dart';
import 'package:http/http.dart' as http;

class TodoController extends GetxController {
  var todoList = <Todo>[].obs;
  var runingList = <Todo>[].obs;
  var finishList = <Todo>[].obs;
  var isLoading = true.obs;

  static var client = http.Client();
  // static var url = 'https://b5ccei7awi.execute-api.us-east-1.amazonaws.com/';
  static var url = 'https://7lax2vfzwc.execute-api.us-east-1.amazonaws.com/';
  final _connect = GetConnect();

  @override
  void onInit() {
    // TODO: implement onInit
    fetchTodo();
    super.onInit();
  }

  fetchTodo () async {
    isLoading.value = true;
    var response = await _connect.get('${url}todos');
    if(response.statusCode == 200){
      var json = response.body;
      todoList.value = todoFromJson(json);
      finishList = todoList.value.where((element) => element.complete ).toList().obs;
      runingList = todoList.value.where((element) => !element.complete ).toList().obs;
      // for(var td in todoList.value) {
        // if(td.complete) {
        //   finishList.value.add(td);
        // }else{
        //   runingList.value.add(td);
        // }
      // }
      print(todoList.value);
      isLoading.value = false;
    }else {
      Get.snackbar('Erreur',
          'Server responded ${response.statusCode}:${response.statusText.toString()}'
      , snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }

  addTodo (Todo todo) async {
    isLoading.value = true;
    var response = await _connect.post(
        url, todo.toJson()
    );
    if(response.statusCode == 200){
      fetchTodo();
      Get.snackbar('SUCCES', 'Tâche ajoutée!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.lightGreenAccent);
    }else {
      isLoading.value = false;
      Get.snackbar('Erreur',
          'Server responded ${response.statusCode}:${response.statusText.toString()}'
      , snackPosition: SnackPosition.BOTTOM);
    }
  }

  updateTodo (Todo todo) async {
    isLoading.value = true;
    var response = await _connect.put(
        '${url}todo/${todo.id}', todo.toJson()
    );
    if(response.statusCode == 200){
      fetchTodo();
      Get.snackbar('SUCCES', 'Tâche Terminée!',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.lightGreenAccent);
    }else {
      Get.snackbar('Erreur',
          'Server responded ${response.statusCode}:${response.statusText.toString()}'
          , snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }
  deleteTodo (Todo todo) async {
    isLoading.value = true;
    var response = await _connect.delete(
        '${url}todo/${todo.id}'
    );
    if(response.statusCode == 200){
      fetchTodo();
      Get.snackbar('SUCCES', 'Tâche supprimée!'
          , snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.lightGreenAccent);
    }else {
      Get.snackbar('Erreur',
          'Server responded ${response.statusCode}:${response.statusText.toString()}'
          , snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }
}