import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list/color.dart';
import 'package:todo_list/todo.dart';
import 'package:todo_list/todo_item.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: tdbColor));
    return const MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late final ToDo todo;
  final todosList = ToDo.todoList();
  final todoController = TextEditingController();
  List<ToDo> foundToDo = [];
  @override
  void initState() {
    // TODO: implement initState
    foundToDo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: tdbColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
               searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50,bottom: 20),
                        child: const Text('All ToDos',style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      for(ToDo todoo in foundToDo.reversed)
                        ToDoItem(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 15,
                    right: 20,
                    left: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0,0.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                    ),],
                    borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: todoController,
                        decoration: const InputDecoration(
                          hintText: ' Add a new todo item',
                          border: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 15,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () {_addToDoItem(todoController.text.toString());  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: const Size(50,50),
                      elevation: 10,
                    ),
                    child: const Text('+',style: TextStyle(fontSize: 40,),),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo){
    setState(() {
      todo.isDone = ! todo.isDone;
    });
  }

  void _deleteToDoItem(String id){
    setState(() {
      todosList.removeWhere((item) => item.id== id);
    });
  }

  void _addToDoItem(String toDo){
    setState(() {
      todosList.add(ToDo(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          todoText: toDo));

    });
    todoController.clear();
  }


  void searchResult(String enteredKeyword){
    List<ToDo> results = [];
    if(enteredKeyword.isEmpty){
      results = todosList;
    } else{
      results = todosList
          .where((item) => item.todoText!
          .contains(enteredKeyword.toLowerCase())).toList();
    }
    setState(() {
      foundToDo = results;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdbColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.menu,color: tdBlack,size:30 ,),
        ],
      ),
    );
  }

  Widget searchBox(){
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => searchResult(value),
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            maxWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(
              color: tdGrey
          ),
        ),
      ),
    );
  }
}
