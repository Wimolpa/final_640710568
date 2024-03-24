import 'dart:convert';

import 'package:final_640710568/helpers/my_list_tile.dart';
import 'package:final_640710568/pages/todo_item.dart';
import 'package:flutter/material.dart';

import '../helpers/api_caller.dart';
import '../helpers/dialog_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> _todoItems = [];
  static const host = 'https://cpsu-api-49b593d4e146.herokuapp.com';
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  Future<void> _loadTodoItems() async {
    try {
      final data = await ApiCaller().get("web_types");
      // ข้อมูลที่ได้จาก API นี้จะเป็น JSON array ดังนั้นต้องใช้ List รับค่าจาก jsonDecode()
      List list = jsonDecode(data);
      setState(() {
        _todoItems = list.map((e) => TodoItem.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        title: const Text('    Webby Fondue \n ระบบรายงานเว็บเลวๆ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
                child:
                    Text('*ต้องการกรอกข้อมูล', style: textTheme.titleMedium)),
            const SizedBox(height: 8.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'URL*',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.only(
                  left: 16.0,
                  bottom: 12.0,
                  top: 12.0,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'รายละเอียด',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.only(
                  left: 16.0,
                  bottom: 12.0,
                  top: 12.0,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context, index) {
                  final item = _todoItems[index];
                  return Card(
                    child: ListTile(
                      trailing: Image.network(host + item.imageUrl),
                      title: Text(item.title),
                      subtitle: Text(item.subtitle),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),

            // ปุ่มทดสอบ POST API
            //ElevatedButton(
            //  onPressed: _handleApiPost,
            //  child: const Text('Test POST API'),
            //),

            //const SizedBox(height: 8.0),

            // ปุ่มทดสอบ OK Dialog
            ElevatedButton(
              onPressed: _handleShowDialog,
              child: const Text('ส่งข้อมูล'),

            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "todos",
        params: {
          "userId": 1,
          "title": "ทดสอบๆๆๆๆๆๆๆๆๆๆๆๆๆๆ",
          "completed": true,
        },
      );
      // API นี้จะส่งข้อมูลที่เรา post ไป กลับมาเป็น JSON object ดังนั้นต้องใช้ Map รับค่าจาก jsonDecode()
      Map map = jsonDecode(data);
      String text =
          'ส่งข้อมูลสำเร็จ\n\n - id: ${map['id']} \n - userId: ${map['userId']} \n - title: ${map['title']} \n - completed: ${map['completed']}';
      showOkDialog(context: context, title: "Success", message: text);
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Future<void> _handleShowDialog() async {
    await showOkDialog(
      context: context,
      title: "This is a title",
      message: "This is a message",
    );
  }
}
