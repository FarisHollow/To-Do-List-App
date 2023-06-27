import 'package:flutter/material.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();

  void _editTodo(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final TextEditingController titleController =
        TextEditingController(text: todos[index].title);
        final TextEditingController descriptionController =
        TextEditingController(text: todos[index].description);

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Todo',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  hintText: "Enter Title",
                ),
              ),
              const SizedBox(height: 7),
              TextFormField(
                maxLines: 6,
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  hintText: "Enter Description",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(

                onPressed: () {
                  setState(() {
                    todos[index].title = titleController.text.trim();
                    todos[index].description =
                        descriptionController.text.trim();
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteTodoConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                todos.removeAt(index);
              });
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }


  void _showTodoDetails(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Task Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Title: ${todos[index].title}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                'Description: ${todos[index].description}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }






  List<Todo> todos = [];

  GlobalKey<FormState> todoForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        actions: [
          IconButton(
            onPressed: () {

              // if (mounted) {
              //   setState(() {});
              // }
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmation'),
                  content: const Text('Are you sure you want to delete all lists?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          todos.clear();
                        });
                        Navigator.pop(context); // Close the dialog
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.playlist_remove),
          )
        ],
      ),
      body: ListView.separated(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          // if (true) {
          //   const Text('Hello');
          // }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              onLongPress: () {

                todos[index].isDone = !todos[index].isDone;
                if (mounted) {
                  setState(() {});
                }
              },
              onTap:() {_showTodoDetails(index);},
              leading: Visibility(
                visible: todos[index].isDone,
                replacement: const Icon(Icons.close),
                child: const Icon(Icons.done_outline),
              ),
              title: Text(todos[index].title),
              subtitle: Text(
                todos[index].description,
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {

                      _editTodo(index);

                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete_forever_outlined),
                    onPressed: () {
                      _deleteTodoConfirmation(index);


                      // todos.removeAt(index);
                      // if (mounted) {
                      //   setState(() {});
                      // }


                    },
                  ),
                ],
              ),

            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 4,
            color: Colors.deepPurple,
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 14,
        backgroundColor: Colors.deepPurple,
        label: Row(
          children: [
            Text("Press to Add"),
            Icon(Icons.note_add_sharp)
          ],
        ),

        onPressed: () {
          showAddNewTodoModalSheet();
        },


      ),
    );
  }

  void showAddNewTodoModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: todoForm,
                child: Column(
                  children: [
                    const Text('Add New List', style: TextStyle(
                      fontSize: 18,
                    ),),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _titleTEController,
                      decoration: InputDecoration(
                          labelText: "Enter Title",
                          hintText: "Title",

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.amber,
                                width: 20,
                              )
                          )
                      ),


                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Please enter your title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 7 ,),

                    TextFormField(
                      maxLines: 6,
                      controller: _descriptionTEController,
                      decoration: InputDecoration(
                          labelText: "Enter Description",
                          hintText: "Description",

                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.amber,
                                width: 20,
                              )
                          )
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20 ,),
                    ElevatedButton(
                      onPressed: () {
                        if (todoForm.currentState!.validate()) {
                          todos.add(Todo(_titleTEController.text.trim(),
                              _descriptionTEController.text.trim(), false));
                          if (mounted) {
                            setState(() {});
                          }
                          _titleTEController.clear();
                          _descriptionTEController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Add'),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

// To do
// title, description, done

class Todo {
  String title, description;
  bool isDone;

  Todo(this.title, this.description, this.isDone);
}
